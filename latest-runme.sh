




#./pa-out.sh | ./pa-in.sh | ./fftw3_stream 8000 100 1 560 100 0.15 0.05 0 | ./count-lines-n-gaps.awk | ./dits-n-dahs.awk | ./morsecode.awk 
./pa-out.sh | ./pa-in.sh | ./fftw3_stream $1 $2 $3 $4 $5 $6 $7 0 | ./count-lines-n-gaps.awk | ./dits-n-dahs.awk | ./morsecode.awk 
