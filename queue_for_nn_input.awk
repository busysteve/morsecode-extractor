#!/bin/awk -f
BEGIN{
	wid = 10
	split( "0000000000", input, "" )

}{
	push_queue( input, $1 )
	
	system("")
}

func push_queue(q,val)
{
	l = length(q)

	for( i=1; i< l; i++)
		q[i] = q[i+1]
	q[l] = val

	#printf( q[1] )

	for( e in q )
		printf( "%d\t", q[e] );
		#printf( "\t%d", pulse_times[ q[e]]+(((rand()*3)+1) ) );

	print ""

}



