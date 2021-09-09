#!/bin/awk -f
{

	min_n = -1.0
	max_n = 0
	min_p = 1.0
	max_p = 0

	x=1

	for( i=x; i<=NF; i++ )
	{
		min_p = $i > 0 && min_p > $i ? $i : min_p
		max_p = $i > 0 && max_p < $i ? $i : max_p
		min_n = $i < 0 && min_n < $i ? $i : min_n
		max_n = $i < 0 && max_n > $i ? $i : max_n
	}

	print $1 " " max_n " " min_n " " max_p " " min_p

	system("")

}


func find_outlier_e( arr )
{
	m_e = most_e(arr)
	med = abs( median( arr ) )
	min = abs(arr[ least_e(arr) ])
	max = abs(arr[ m_e ])
	cnt = length(arr)
	avgz = avg_not_zero(arr)

	if( med != 0 && min != 0 && max != 0 )
	{
		skew = med - min
		diff = max - min

		if( diff > (skew*2) )
			return m_e
	}
}

func avg( arr )
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
	x=999999999

	for( e in arr )
	{
		y = abs( arr[e] )
		if( y < x )
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
		if( y > x )
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


