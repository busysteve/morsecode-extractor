


rm -f morsecode-nn.o

#custom=3 inputs=5 layer1=6 layer2=4 layer3=8 inputtype=htan layer1type=layer_norm layer2type=relu layer3type=relu

make $1 -f Makefile.no-cuda

#cp morsecode-nn ~/github/morsecode-extractor/


