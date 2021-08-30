#!/bin/awk -f 

BEGIN{
	if( cw_shift == 0 )
		cw_shift = ENVIRON["CW_SHIFT"]
		
	if( cw_shift == 0 )
		cw_shift = 1
		
	#print "cw_shift = " cw_shift
}{

	#print tone " - " gap

	if( gap > 0 && tone > 0 )
	{
		tone_start = (10 * cw_shift)
		tone_thresh = (10 * cw_shift)
		tone_dit = tone_start
		tone_dah = tone_start + tone_thresh
				
		gap_start = (10 * cw_shift)
		gap_thresh = (90 * cw_shift)
		gap_letter = gap_start
		gap_word = gap_start + gap_thresh
				
		if( tone >= tone_dit && tone < tone_dah )
			printf(".")
		else if( tone >= tone_dah )
			printf("-")
			
		if( gap >= gap_letter && gap <= gap_word )
			printf("\n")
		else if( gap > gap_word )
			printf("\n\n")
		
		system("")
			
		gap = 0
		tone = 0
	}


	if( length($0) > 0 )
	{
		tone_thresh = 4
		tone_width = 5
		tone_min = tone_thresh
		tone_max = ( tone_thresh + tone_width )

		#if( tone > tone_min && tone <= tone_max )
		{
			tone++
		}
	}
	else
	{
		gap_thresh = 4
		gap_width = 10
		gap_min = gap_thresh
		gap_max = ( gap_thresh + gap_width )
		
		#if( gap >= gap_min && gap <= gap_max )
		{
			gap++
		}
	}


}
END {
	print ""
}

