#!/bin/bash

for x in 14 16 18 20 22 24 26 28 30
do
	for y in .05 .1 .15 .2 .25 .3 .35
	do
		./stats-run.sh $x $y
	done
done


