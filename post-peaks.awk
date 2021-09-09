#!/bin/awk -f 
{

	if( $1 > 0 )
	{	
		val = $1
		if( neg > 0 )
		{
			print -neg
			neg = 0
		}
		pos+=val
	}
	if( $1 < 0 )
	{
		val = -$1
		if( pos > 0 )
		{
			print pos
			pos = 0
		}
		neg+=val
	}

	system("")
}END{
	if( pos > 0 )
		print pos
	else if( neg > 0 )
		print -neg
}
