#!/bin/awk -f
{

#	print $0
	
	s=2
	split( "0", neg, "" )
	split( "0", pos, "" )

	i=1
	for( x=s; x<=NF; x++ )
		if( $x < 0 )
			neg[i++] = $x

	i=1
	for( x=s; x<=NF; x++ )
		if( $x > 0 )
			pos[i++] = $x

	#for( e in neg ) print neg[e]

	if( length(neg) > 2 ) 
		o_neg = neg[find_outlier_e( neg )] 
	

#	print $0

	if( o_neg != 0 )
	{
		for( i=2; i <= NF; i++ )
			$i = ($i == o_neg ? 0 : $i)
	}
	
#	print $0

	if( o_neg != 0 )
	{
		max_n = neg[most_e(neg)]
		max_p = pos[most_e(pos)]

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
                $i = $i != 0 ? ($i / max_p) : -($i / max_n) 
        
#	for( i=s; i <= NF; i++ )
#                $i = $i >= 1 ? ($i / max_p) : -($i / max_n) 


	

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





func find_outlier_e( arr )
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
		if( ((fa-ga) > ga*2 ) )  #{ print "X   a=" a " b=" b " c=" c " d=" d " g=" g " f=" f "   -> " arr[m_e] " |  " $0 }	
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


