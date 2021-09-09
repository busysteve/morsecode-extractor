#!/bin/bash




for layers in 2 3
do
for layer in 5 7 9 12
do
	cd ./morsecode-softmax/

	./build_nn.sh "custom=$layers inputs=5 layer1=$layer layer2=$layer layer3=$layer inputtype=htan layer1type=htan layer2type=htan layer3type=htan"


	cp morsecode-nn ..

	cd ..


	for pulse_width in 8 16 
	do
		for fiddle in 2 6  
		do
			for set_size in 20000 50000 100000 
			do

				test_size=`echo \"$set_size / 10\" | bc`

			./train_nn.sh 5 $fiddle $pulse_width $set_size  $test_size  2>&1
			echo "custom=$layers inputs=5 layer1=$layer layer2=$layer layer3=$layer inputtype=htan layer1type=htan layer2type=htan layer3type=htan"
			echo "./train_nn.sh 5 $fiddle $pulse_width $set_size $test_size"
			./test_nn.sh 20000226_045335.wav

			done
		done
	done
done
done




