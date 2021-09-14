#!/bin/awk -f
BEGIN{

	pulse_short = 10
	pulse_long  = pulse_short * 3
	gap_short   = -pulse_short
	gap_long    = gap_short * 3
	gap_space = gap_long * 3

}{
	code = $1

	len = length( code )




	if( len == 0 )
	{
		if( last_gap != gap_space )
			print gap_space

		last_gap = gap_space
	}
	else
	{
		if( last_gap != gap_space )
			print gap_long
		

		last_gap = gap_long

		split( code, arr, "" )

		cnt=1
		for( e in arr )
		{
			if( cnt++ > 1 )
				print gap_short

			d = arr[e]

			if( d == "." )
				print pulse_short
			else if( d == "-" )
				print pulse_long

		}
		
	}
}
