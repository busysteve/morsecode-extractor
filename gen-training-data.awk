#!/bin/awk -f
BEGIN{


	inputs = ENVIRON["INPUT_COUNT"]
	if( inputs <= 0 )
		inputs = 10
		
	factor = ENVIRON["FACTOR"]
	if( factor <= 0 )
		factor = 3
		

	pulse_width = ENVIRON["PULSE_WIDTH"]
	if( pulse_width <= 0 )
		pulse_width = 10

	gap_width = ENVIRON["GAP_WIDTH"]
	if( gap_width <= 0 )
		gap_width = $pulse_width


txt2mc["A"] = ".-"
txt2mc["B"] = "-..."
txt2mc["C"] = "-.-."
txt2mc["D"] = "-.."
txt2mc["E"] = "."
txt2mc["F"] = "..-."
txt2mc["G"] = "--."
txt2mc["H"] = "...."
txt2mc["I"] = ".."
txt2mc["J"] = ".---"
txt2mc["K"] = "-.-"
txt2mc["L"] = ".-.."
txt2mc["M"] = "--"
txt2mc["N"] = "-."
txt2mc["O"] = "---"
txt2mc["P"] = ".--."
txt2mc["Q"] = "--.-"
txt2mc["R"] = ".-."
txt2mc["S"] = "..."
txt2mc["T"] = "-"
txt2mc["U"] = "..-"
txt2mc["V"] = "...-"
txt2mc["W"] = ".--"
txt2mc["X"] = "-..-"
txt2mc["Y"] = "-.--"
txt2mc["Z"] = "--.."
txt2mc["0"] = "-----"
txt2mc["1"] = ".----"
txt2mc["2"] = "..---"
txt2mc["3"] = "...--"
txt2mc["4"] = "....-"
txt2mc["5"] = "....."
txt2mc["6"] = "-...."
txt2mc["7"] = "--..."
txt2mc["8"] = "---.."
txt2mc["9"] = "----."
txt2mc["."] = ".-.-.-"
txt2mc[","] = "--..--"
txt2mc["?"] = "..--.."
txt2mc["-"] = "-....-"
txt2mc["/"] = "-..-."
txt2mc[":"] = "---..."
txt2mc["'"] = ".----."
txt2mc["-"] = "-....-"
txt2mc[")"] = "-.--.-"
txt2mc[";"] = "-.-.-"
txt2mc["("] = "-.--."
txt2mc["="] = "-...-"
txt2mc["@"] = ".--.-."
txt2mc[" "] = ""

        cmd = "date +%s"

	cmd | getline 

        seed = $1

        srand( seed )


	pulse_times["."] = pulse_width
	pulse_times["-"] = pulse_width*3
	pulse_times["g"] = g = -(gap_width)
	pulse_times["G"] = G = -((-g)*6)
	pulse_times["L"] = -((-G)*5)

	pulse_map["-"] = 4
	pulse_map["."] = 3
	pulse_map["g"] = 2
	pulse_map["G"] = 1
	pulse_map["L"] = 0

	fudge = 0

	exit

}END{
	len = length(txt2mc)
	x = ( rand()*(len+1) ) 
	r = x-x%1



	i=0
	for( e in txt2mc )
	{
		#data[i] = e "|" txt2mc[e]
		data[i] = txt2mc[e]
		i++
	}

	#    0123456789
	q = ""	
	#q = "    "	
	#q = "          "	

	for( i=1; i <= inputs; i++ )
		q = q "0"


	split( q, queue, "" )

	
	


	qlen = length(queue)

	j = 0
	for( i=1; i <= 1000; i++ )
	{
		j++;
		
		x = ( rand()*(len) )
		r = x-x%1

		code =  data[r]

		split( code, dat, "" )
		
		g = 0
		for( d in dat )
		{
			if( g > 0 )
				push_queue(queue, "g" )
				
			g++
			
			v = dat[d]
			push_queue(queue, v )
		}

		w = (  j%2 ? "G" : "L")
		push_queue(queue, w ) 
	}

	
}

func push_queue(q,val)
{
	
	l = length(q)

	fudge++

	fiddle = ( .5 + rand() * .75 ) * factor


	#roll queue
	for( i=1; i< l; i++)
		q[i] = q[i+1]

	q[l] = val

	printf( pulse_map[ q[1] ] )

	#for( e in q )
	for( i=1; i <=l; i++ )
	{
		v = pulse_times[q[i]] * fiddle
		r = ( (.5+(rand()-0.5) * factor * 1.5 ) ) 

		#print v "  :  " r

		printf( "\t%d", v + r );
		
	}

	print ""

}






