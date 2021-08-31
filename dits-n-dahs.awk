#!/bin/awk -f
BEGIN{
}
{
	if( length( $0 ) > 0 )
	{


		data[8] = data[7]
		data[7] = data[6]
		data[6] = data[5]
		data[5] = data[4]
		data[4] = data[3]
		data[3] = data[2]
		data[2] = data[1]
		data[1] = $1

		val = data[8]

		if( length( val ) > 0 )
		{
			process_data( val )
		}


	}

	fflush(stdout)
}
END{
	for( i in data )
		process_data( data[i] )
}

func process_data( val )
{

			min_pos = 9999
			max_pos = 0
			min_neg = -9999
			max_neg = 0

			for( i in data )
			{
				dat = data[i]

				if( dat > 0 )
				{
					if( max_pos < dat ) max_pos = dat

					if( min_pos > dat ) min_pos = dat
				}
				else if( dat < 0 )
				{
					if( min_neg < dat ) min_neg = dat

					if( max_neg > dat ) max_neg = dat
				}
			}

			avg_pos = ( min_pos + max_pos ) / 2
			avg_neg = ( min_neg + max_neg ) / 2

			if( val > 0 )
			{
				if( val >= avg_pos ) 
					printf( "-" )
				else 
					printf( "." )
			}

			if( val < 0 )
			{
				if( val <= avg_neg )
				{
					print_data_state( min_pos, max_pos, min_neg, max_neg, avg_pos, avg_neg )
					printf( "\n" )
				}
				else if( val < (avg_neg)+(max_neg/2) ) 
				{ printf( "\n" ) }
			}



}

func print_data_state( min_pos, max_pos, min_neg, max_neg, avg_pos, avg_neg )
{

	printf( " min_pos=%s, max_pos=%s, min_neg=%s, max_neg=%s, avg_pos=%s, avg_neg=%s", min_pos, max_pos, min_neg, max_neg, avg_pos, avg_neg )


}
