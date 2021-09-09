
layer1=$1
layers=1

layer2=$2
if [[ $layer2 -gt 0 ]]
then
	layers=2
	#layer1=$layer2
else
	layer2=0
fi

layer3=$3
if [[ $layer3 -gt 0 ]]
then
	layers=3
        #layer2=$layer1
else
	layer3=0
fi

layer4=$4
if [[ $layer4 -gt 0 ]]
then
	layers=4
        #layer3=$layer2
else
	layer4=0
fi


cd ./morsecode-softmax/

./build_nn.sh "custom=$layers inputs=5 layer1=$layer1 layer2=$layer2 layer3=$layer3 layer4=$layer4 inputtype=htan layer1type=htan layer2type=htan layer3type=htan layer4type=htan"


#./build_nn_cp.sh "custom=2 inputs=5 layer1=10 layer2=6 inputtype=htan layer1type=htan layer2type=htan"


cp morsecode-nn ..

cd ..


