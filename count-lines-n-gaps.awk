#!/bin/awk -f 
BEGIN{
	thresh = ENVIRON["CW_THRESH"]
	
	if( thresh == "" )
		thresh = 5
}{
	if( NF == 0 )
	{
		if( gaps >= thresh && lines >= thresh )
		{
			print lines
			lines = 0
		}
		
		gaps++
	}
	else
	{
		if( gaps >= thresh && lines >= thresh )
		{
			print -gaps
			gaps = 0
		}
		
		lines++
	}
	
	system("")
}

