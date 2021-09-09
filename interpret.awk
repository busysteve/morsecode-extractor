#!/bin/awk -f
{
	i = $1
	thresh = .25
	max_neg = $2
	min_neg = $3
	max_pos = $4
	min_pos = $5
	zero = 0
	


	

	x = nearest( $1, $2, $3, $4, $5 )

	if( i == zero )
		printf("\n\n")

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

