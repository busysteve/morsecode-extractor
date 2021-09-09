#!/bin/awk -f
BEGIN{
	slot_count = ENVIRON["CW_SLOTS"]

	if( slot_count < 1 )
		slot_count = 5

}
{

	if( length( $0 ) > 0 )
	{
		val = $1

		if( length( val ) > 0 )
		{
			slot_data( val )
			process_data( val )
		}


	}

	system("")
}
END{
	for( i in data )
		process_data( data[i] )
}

func slot_data( val )
{

	if( val > 0 )
	{
		for( s = slot_count; s > 0; s-- )
                	data[s+1] = data[s]
                data[1] = val
	}
	else if( val < 0 ) 
	{
		for( s = slot_count; s > 0; s-- )
                	data[-(s+1)] = data[-s]
                data[-1] = val
	}


}


func process_data( val )
{

			min_pos = 9999
			max_pos = 0
			min_neg = 9999
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
					dat = -dat
					
					if( min_neg > dat ) min_neg = dat

					if( max_neg < dat ) 
					{
						max_neg = dat
						
						#if( max_neg < -( min_neg * 5 ) ) max_neg = -( min_pos * 5 )
					}
				}
			}

			avg_pos = ( min_pos + max_pos ) / 2
			avg_neg = ( min_neg + max_neg ) / 2


			#std_pos = stddev_pos(data)
			#std_neg = stddev_neg(data)
			


			if( val > 0 )
			{
				#if( val > avg_pos ) 
				if( val > max_pos*(min_pos/max_pos)*2.3 )
					printf( "-" )
				else 
					printf( "." )
			}

			if( val < 0 )
			{
				val = -val;
				
				if( val > max_neg*(min_neg/max_neg)*2 )
				{
					#print_data_state( min_pos, max_pos, min_neg, max_neg, avg_pos, avg_neg )
					printf( "\n" )
				}
				#if( val >= ( max_neg * (min_neg / max_neg)*6 ) ) { printf( "\n" ) }
				if( val >= ( max_neg ) ) { printf( "\n" ) }
				#if( val >= ( max_neg*(min_neg/max_neg)*6 ) ) { printf( "\n" ) }
			}



}

func print_data_state( min_pos, max_pos, min_neg, max_neg, avg_pos, avg_neg )
{

	printf( " min_pos=%s, max_pos=%s, min_neg=%s, max_neg=%s, avg_pos=%s, avg_neg=%s", min_pos, max_pos, min_neg, max_neg, avg_pos, avg_neg )


}
