#!/bin/awk -f
{
	i = $1
	max_neg = $2
	min_neg = $3
	max_pos = $4
	min_pos = $5
	zero = 0
	

	if( i == zero )
	{
		printf("\n\n")
		next
	}

	x = closest( $1, $2, $3, $4, $5 )

	switch( x )
	{
		case 1:
			printf( "\n" )
			break
		case 2:
			printf( "" )
			break
		case 3:
			printf( "." )
			break
		case 4:
			printf( "-" )
			break
		default:
			printf("\n   what?  %s\n", x )
		
	}

	system("")
}

func closest( i, a, b, c, d )
{

	if( i < 0 )
	{
		x = i - a
		y = b - i
		
		#print i, a, b, c, d, "   -diff:    " x "   :   " y

		if( x < y )
			return 1
		else if( x > y )
			return 2
		else
		{
			print ""
			print i, a, b, x, y
			return -1
		}
	}
	else if( i > 0 )
	{
		x = i - b
		y = c - i
		
		#print i, a, b, c, d, "    diff:    " x "   :   " y

		if( x < y )
			return 3
		else if( x > y )
			return 4
		else
			return -2
	}
	else
		return -3
	
	
	
}

func closest_old( i, a, b, c, d )
{

	delete arr
	delete sarr


	w = dif( i, a )
	x = dif( i, b )
	y = dif( i, c )
	z = dif( i, d )

	arr[w] = 1
	arr[x] = 2
	arr[y] = 3
	arr[z] = 4

	presorting = PROCINFO["sorted_in"] 

	xx = 0
	PROCINFO["sorted_in"] = "@ind_num_asc"
	for( e in arr )
	{
		xx++
		sarr[xx] = arr[e]
	}

	PROCINFO["sorted_in"] = presorting

	if( 0 )
	{

		for( e in arr ) print e , arr[e]
		print ""
	
		for( e in sarr ) print e , sarr[e]
		print ""
		print sarr[1]
		print ""
		print $0
		print ""
		print ""
	}


	return sarr[1]
	
}

func dif( x, y )
{

	if( x == y )
		return 0
	else if( x < 0 && y < 0 && x > y )
		return x - y
	else if( x < 0 && y < 0 && x < y )
		return y - x
	else if( x > 0 && y > 0 && x > y )
		return x - y
	else if( x > 0 && y > 0 && x < y )
		return y - x
	else if( x > 0 && y < 0 )
		return x - y
	else if( x < 0 && y > 0 )
		return y - x
	else
		printf( "\n\n crap!!!  x=%s   y=%s   |  %s  \n\n", x, y, $0 )



}

func nearest( i, a, b, c, d )
{

	delete arr
	delete sarr

	w = a-i
	x = b-i
	y = c-i
	z = d-i


	j = abs(i)

	w = abs(a)-j
	x = abs(b)-j
	y = abs(c)-j
	z = abs(d)-j

	arr[abs(w)] = 1
	arr[abs(x)] = 2
	arr[abs(y)] = 3
	arr[abs(z)] = 4

	presorting = PROCINFO["sorted_in"] 

	xx = 0
	PROCINFO["sorted_in"] = "@ind_num_asc"
	for( e in arr )
	{
		xx++
		sarr[xx] = arr[e]
	}

	PROCINFO["sorted_in"] = presorting

#	for( e in arr ) print e , arr[e]
#	print ""
#
#	for( e in sarr ) print e , sarr[e]
#	print ""
#	print sarr[1]
#	print ""
#	print ""



	return sarr[1]
	
}


func abs(x)
{
	return x<0 ? -x : x
}

