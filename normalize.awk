#!/bin/awk -f
{

#	print $0

	memhold=" inline: " $0

	s=1
	#split( "0", neg, "" )
	#split( "0", pos, "" )

	delete neg
	delete pos

	i=1
	for( x=s; x<=NF; x++ )
		if( $x < 0 )
			neg[i++] = -$x

	i=1
	for( x=s; x<=NF; x++ )
		if( $x > 0 )
			pos[i++] = $x

	#for( e in neg ) print neg[e]

	o_neg = ""
	if( length(neg) > 2 ) 
		o_neg = -(find_outlier( neg ) )
	

#	print o_neg

	if( o_neg != 0 )
	{
		for( i=s; i <= NF; i++ )
			$i = ($i == o_neg ? 0 : $i)

		for( e in neg )
			if( neg[e] == o_neg )
				neg[e] = 0
	}
	
#	print $0

	#if( o_neg != 0 )
	{
		max_n = -neg[most_e(neg)]
		max_p = pos[most_e(pos)]

		#print most_e(neg) "=" max_n "     " most_e(pos)  "=" max_p "   o=" o_neg   " <> " $0 "  |  " memhold

		max_n = max_n == 0 ? 1 : max_n
		max_p = max_p == 0 ? 1 : max_p
	}

	if( (s > 1 && ($1 < 0 || $1 > 4)) || max_n == 0 || max_p == 0 )
	{
		#print "state: $1="$1 "  max_n=" max_n "  max_p=" max_p  "   |> " $0
		#for( i=0; i < NF; i++ ) printf( "0 " );
		#print "err " $0
		next	
	}

        for( i=s; i <= NF; i++ )
                $i = $i < 0 ? -($i / max_n) : ($i / max_p) 
        
#	for( i=s; i <= NF; i++ )
#                $i = $i >= 1 ? ($i / max_p) : -($i / max_n) 


	#print most_e(neg) ":max_n=" max_n "     " most_e(pos)  ":max_p=" max_p "   o=" o_neg   " <> " $0 "  |  " memhold
	
	print $0
}


# Outlier approach
#
# |------------|-----|-----|----------|-----------|
# 0            a     b     c          d           f
#
#
# a = minimum non-zero duration
# b = median point of all positive values
# c = a+(b-a)  <- an assumed proper max point
# d = b+(b-a)*2  <- outlier threshold
# f = an outlier (converted to zero)
#
#
# NOTE:  All inputs are less that or greater than zero
#       only converted outliers will be zero for final values
#
#       All final inputs are between -1 and +1


func find_outlier( arr )
{
	if( length(arr) <= 2 )
		return

	delete sorted

	PROCINFO["sorted_in"] = "@val_num_asc"

	i=1
	for( e in arr )
	{
		sorted[i++] = arr[e] 
	}

	min = sorted[1]
	max = sorted[length(sorted)]

	#if( max > (min*10) )
	if( max > (min*5) )
		return max
	else
		return ""
}





func find_outlier_old( arr )
{
	if( length(arr) <= 2 )
		return

	delete cata

	PROCINFO["sorted_in"] = "@val_num_asc"
if( 0 )
{
	printf( "	arr:" )
	for( e in arr )
		printf( "  %f", arr[e] )
	print ""
}

	x=""
	i=1
	for( e in arr )
	{
		if( x == "" )
		{
			x = arr[e]
			cata[i][x] = x
		}
		else
		{
			c = arr[e]
			{
				if( (c-x) > x*0.2 )
					x = cata[++i][c] = c
				else
					cata[++i][x] = c
			}
				
		}
	}

if( 0 )
{
	print( "	cata: " )
	for( e in cata )
	{
		print "		|"
		for( f in cata[e] )
			printf( "  %f  ", cata[e][f] )
		print ""
	}
}

	if( length(cata) > 2 )
		return x
	else
		return ""

}



func find_outlier_e_old( arr )
{
	if( length(arr) <= 2 )
		return


	m_e = most_e(arr)
	l_e = least_e(arr)
	b = abs( median( arr ) )
	a = abs(arr[ l_e ])
		a = (a == "" ? 0 : a)

	f = abs(arr[ m_e ])
	c = a + (b - a)
	d = c + a*3

	g = abs(avg_a(arr))

			#print "0   a=" a " b=" b " c=" c " d=" d " f=" f

	cnt = length(arr)
	avgz = avg_not_zero(arr)

	if( b != 0 && f != 0 )
	{
		ga = g - a
		fa = f - a
		if( ((fa-ga) > ga*3 ) )  #{ print "X   a=" a " b=" b " c=" c " d=" d " g=" g " f=" f "   -> " arr[m_e] " |  " $0 }	
		#if( f > d )
		{
			#print "F   a=" a " b=" b " c=" c " d=" d " g=" g " f=" f "   -> " arr[m_e] " |  " $0
			return m_e
		}
	}

}

func avg_a( arr )
{
	l = length(arr)
	t = sum( arr )

	return l == 0 ? l : ( t / l )
}

func avg_not_zero( arr )
{
        l = length(arr)

	for( e in arr )
		if( arr[e] == 0 )
			l--

        t = sum( arr )

        return l == 0 ? l : (t / l)
}



func sum( arr )
{
	x=0
	for( e in arr )
		x = x + arr[e]

	return x
}


func abs( x )
{
	return( x < 0 ? -x : x ) 
}


func least_e( arr )
{
	x=9999999

	for( e in arr )
	{
		y = abs( arr[e] )
		#print "0   y="y
		if( y != "" && y < x )
		{
			x = y
			z = e
		}
	}

	return z
}

func most_e( arr )
{
	x=0

	for( e in arr )
	{
		y = abs( arr[e] )
		if( y != "" && y > x )
		{
			x = y
			z = e
		}
	}

	return z
}

func median( arr )
{
	PROCINFO["sorted_in"] = "@val_num_asc"
	split( "", sorted, "" )

	i=1
	for( e in arr )
	{
		v = arr[e]
		#sorted[ v<0 ? -v : v ] = e
		sorted[ i ] = e
		i++
	}

	len = length(sorted)

	if( len%2 == 0 )  # even
	{
		mid1pos = int( len / 2 )
		mid2pos = mid1pos + 1

		mid1 = sorted[mid1pos]
		mid2 = sorted[mid2pos]

		return ( ( arr[mid1] + arr[mid2] ) / 2.0 )
	}
	else  # odd
	{
		midpos = int( len / 2 )
		midpos += 1

		return arr[ sorted[midpos] ]
	}

}


