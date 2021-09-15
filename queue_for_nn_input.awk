#!/bin/awk -f  
BEGIN{

	wide = ENVIRON["CW_DEEP"]

	if( wide == "" )
		wide = 20

	w = "0"

	for( i=1; i<wide; i++ )
		w = w "0"

	split( w, input, "" )


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



