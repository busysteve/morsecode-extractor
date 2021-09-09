#!/bin/awk -f 
BEGIN{
	FS=","

	thresh = ENVIRON["CW_THRESH"]
	
	if( thresh == "" )
		thresh = 2
}{
	freq = 0.0

	if( NF > 0 )
	{

		split($1,data,":")

		freq = data[1]
		level = data[2]
	
		levels[freq][level]

		freq_level_min = 99
		freq_level_max = -99
		for( frq in levels )
		for( lvl in levels[frq] )
		{
			if( lvl < freq_level_min )
				freq_level_min = lvl

			if( lvl > freq_level_max )
				freq_level_max = lvl
		}

		if( length(levels[freq]) > 20 )
			delete levels[freq][freq_level_max]

		#print "   " freq "  :  " level

		if( level < freq_level_max*.86 )
			freq = 0.0

		#print freq "  :  " level

		
	}

	peak_freq = freq

	if( peak_freq == 0.0 )
	{
		#recount = 1
		#if( gaps >= thresh && lines >= thresh )
		if( lines >= thresh )
		{
			print lines
			lines = 0
			gaps = 0
			recount = 0
		}
		else # if( recount == 1 ) 
		{
			gaps = gaps + lines
			lines = 0
		}
		
		gaps++
	}
	else
	{
		#recount = 1
		#if( gaps >= thresh && lines >= thresh )
		if( gaps >= thresh )
		{
			print -gaps
			gaps = 0
			lines = 0
			recount = 0
		}
		else # if( recount == 1 )
		{
			lines = lines + gaps
			gaps = 0
		}
		
		lines++
	}








	system("")
}

