
my_dlib_mnist-1: my_dlib_mnist-1.o dlib_source.o Makefile
	nvcc -std=c++11 -DDLIB_USE_LAPACK -DDLIB_USE_CUDA -DDLIB_USE_BLAS -o my_dlib_mnist-1 my_dlib_mnist-1.o dlib_source.o -L/home/smathews/dlib.d/dlib -L/usr/local/cuda/lib64 -L/usr/lib/x86_64-linux-gnu -ldlib -lcuda -lcurand_static -lcudart_static -lcusolver_static -lcublas_static -lcusparse_static -lculibos -lcudnn_static -lblas -llapack -lX11 -lXrender -lpthread -ldl

my_dlib_mnist-1.o: my_dlib_mnist-1.cpp
	nvcc -std=c++11 -DDLIB_USE_LAPACK -DDLIB_USE_CUDA -DDLIB_USE_BLAS -c my_dlib_mnist-1.cpp -o my_dlib_mnist-1.o -I/home/smathews/dlib-19.16/

dlib_source.o: /home/smathews/dlib-19.16/dlib/all/source.cpp 
	nvcc -std=c++11 -DDLIB_USE_LAPACK -DDLIB_USE_CUDA -DDLIB_USE_BLAS -c /home/smathews/dlib-19.16/dlib/all/source.cpp -o dlib_source.o -I/home/smathews/dlib-19.15/


