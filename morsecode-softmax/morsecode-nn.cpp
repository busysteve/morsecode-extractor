#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <dlib/dnn.h>
#include <iostream>
#include <dlib/data_io.h>

using namespace std;
using namespace dlib;

using in_type =  double;
using lab_type = unsigned long;


#ifndef _INPUTS_
#define _INPUTS_ 5
#endif

#ifndef _LAYER1_
#define _LAYER1_ _INPUTS_
#endif

#ifndef _LAYER2_
#define _LAYER2_ _LAYER1_
#endif

#ifndef _LAYER3_
#define _LAYER3_ _LAYER2_
#endif

#ifndef _LAYER4_
#define _LAYER4_ _LAYER3_
#endif

const int input_count = _INPUTS_;
const int layer1_count = _LAYER1_;
const int layer2_count = _LAYER2_;
const int layer3_count = _LAYER3_;
const int layer4_count = _LAYER4_;


void load_morse_code_training( 
	std::vector<matrix<in_type>> &training_images, 
	std::vector<lab_type> &training_labels, 
	std::vector<matrix<in_type>> &testing_images, 
	std::vector<lab_type> &testing_labels,
	int train_count,
	int test_count )
{
	
	
	
	
	// Training data read	
	cout << "Loading training data...." << endl;
	for( int c=0; c < train_count; c++ )
	{
		string str;
		getline( cin, str );
		stringstream ss( str );
		
		matrix< in_type, 1, input_count > img;
		lab_type lab;

		ss >> lab;

		for( int i=0; i < img.nr(); i++ )
		{
			for( int j=0; j < img.nc(); j++ )
			{
				ss >> img( i, j );
			}
		}
		training_images.push_back( img );
		training_labels.push_back( lab );
	}



	// Training data read	
	cout << "Loading testing data...." << endl;
	for( int c=0; c < test_count; c++ )
	{
		string str;
		getline( cin, str );
		stringstream ss( str );
		
	
		matrix<in_type, 1, input_count> img;
		lab_type lab;

		ss >> lab;

		for( int i=0; i < img.nr(); i++ )
		{
			for( int j=0; j < img.nc(); j++ )
			{
				ss >> img( i, j );
			}
		}
		testing_images.push_back( img );
		testing_labels.push_back( lab );
	}


	cout << "Done loading training and testing data...." << endl;

	return;
}


 

// The contents of this file are in the public domain. See LICENSE_FOR_EXAMPLE_PROGRAMS.txt
/*
    This is an example illustrating the use of the deep learning tools from the
    dlib C++ Library.  In it, we will train the venerable LeNet convolutional
    neural network to recognize hand written digits.  The network will take as
    input a small image and classify it as one of the 10 numeric digits between
    0 and 9.

    The specific network we will run is from the paper
        LeCun, Yann, et al. "Gradient-based learning applied to document recognition."
        Proceedings of the IEEE 86.11 (1998): 2278-2324.
    except that we replace the sigmoid non-linearities with rectified linear units. 

    These tools will use CUDA and cuDNN to drastically accelerate network
    training and testing.  CMake should automatically find them if they are
    installed and configure things appropriately.  If not, the program will
    still run but will be much slower to execute.
*/


#include <dlib/dnn.h>
#include <iostream>
#include <dlib/data_io.h>

using namespace std;
using namespace dlib;

void print_input( matrix<in_type> &img, lab_type label, lab_type predicted );
//void print_image( matrix<unsigned char> &img, unsigned long label, unsigned long predicted );

void print_probs( matrix<float,1,5> &softmax_probs, int x );

int main(int argc, char** argv) try
{

	bool correct_out = false;
	bool wrong_out = false;
	bool train_me = false;

	int training_count = 0;
	int testing_count = 0;

    // This example is going to run on the MNIST dataset.  
    if (argc >= 2)
    {
    	train_me = true;


	{
		int out_flag = atoi( argv[2] );

		if( out_flag == 1 )
			correct_out = true;

		if( out_flag == 2)
			wrong_out = true;

		if( out_flag == 3 )
			correct_out = wrong_out = true;
	}
	

	training_count = atoi( argv[3] );

	testing_count = atoi( argv[4] );

	

    }



    // MNIST is broken into two parts, a training set of 60000 images and a test set of
    // 10000 images.  Each image is labeled so that we know what hand written digit is
    // depicted.  These next statements load the dataset into memory.
    std::vector<matrix<in_type>> training_images;
    std::vector<lab_type>         training_labels;
    std::vector<matrix<in_type>> testing_images;
    std::vector<lab_type>         testing_labels;
    //load_mnist_dataset(argv[1], training_images, training_labels, testing_images, testing_labels);
//    load_morse_code_training(argv[1], training_images, training_labels, testing_images, testing_labels);


    // Now let's define the LeNet.  Broadly speaking, there are 3 parts to a network
    // definition.  The loss layer, a bunch of computational layers, and then an input
    // layer.  You can see these components in the network definition below.  
    // 
    // The input layer here says the network expects to be given matrix<unsigned char>
    // objects as input.  In general, you can use any dlib image or matrix type here, or
    // even define your own types by creating custom input layers.
    //
    // Then the middle layers define the computation the network will do to transform the
    // input into whatever we want.  Here we run the image through multiple convolutions,
    // ReLU units, max pooling operations, and then finally a fully connected layer that
    // converts the whole thing into just 10 numbers.  
    // 
    // Finally, the loss layer defines the relationship between the network outputs, our 10
    // numbers, and the labels in our dataset.  Since we selected loss_multiclass_log it
    // means we want to do multiclass classification with our network.   Moreover, the
    // number of network outputs (i.e. 10) is the number of possible labels.  Whichever
    // network output is largest is the predicted label.  So for example, if the first
    // network output is largest then the predicted digit is 0, if the last network output
    // is largest then the predicted digit is 9.  
//    using net_type = loss_multiclass_log<
//                                fc<10,        
//                                relu<fc<84,   
//                                relu<fc<120,  
//                                max_pool<2,2,2,2,relu<con<16,5,5,1,1,
//                                max_pool<2,2,2,2,relu<con<6,5,5,1,1,
//                                input<matrix<unsigned char>> 
//                                >>>>>>>>>>>>;


#if ( CUSTOMIZED == 4 )

    using net_type = loss_multiclass_log<
                                fc<5, 
                                LAYER4TYPE<fc<layer4_count,   
                                LAYER3TYPE<fc<layer3_count,   
                                LAYER2TYPE<fc<layer2_count,   
                                LAYER1TYPE<fc<layer1_count,   
                                INPUTTYPE<fc<input_count,  
                                input<matrix<in_type>>
                                >>>>>>>>>>>>;
                                
#elif ( CUSTOMIZED == 3 )

    using net_type = loss_multiclass_log<
                                fc<5, 
                                LAYER3TYPE<fc<layer3_count,   
                                LAYER2TYPE<fc<layer2_count,   
                                LAYER1TYPE<fc<layer1_count,   
                                INPUTTYPE<fc<input_count,  
                                input<matrix<in_type>>
                                >>>>>>>>>>;
                                
#elif ( CUSTOMIZED == 2 )

    using net_type = loss_multiclass_log<
                                fc<5, 
                                LAYER2TYPE<fc<layer2_count,   
                                LAYER1TYPE<fc<layer1_count,   
                                INPUTTYPE<fc<input_count,  
                                input<matrix<in_type>>
                                >>>>>>>>;
                                
#elif ( CUSTOMIZED == 1 )

    using net_type = loss_multiclass_log<
                                fc<5, 
                                LAYER1TYPE<fc<layer1_count,   
                                INPUTTYPE<fc<input_count,  
                                input<matrix<in_type>>
                                >>>>>>;
                                
#else                           
     
    using net_type = loss_multiclass_log<
                                fc<5, 
                                htan<fc<layer2_count,   
                                htan<fc<layer1_count,   
                                htan<fc<input_count,  
                                input<matrix<in_type>>
                                >>>>>>>>;
                                
#endif

                                
    // This net_type defines the entire network architecture.  For example, the block
    // relu<fc<84,SUBNET>> means we take the output from the subnetwork, pass it through a
    // fully connected layer with 84 outputs, then apply ReLU.  Similarly, a block of
    // max_pool<2,2,2,2,relu<con<16,5,5,1,1,SUBNET>>> means we apply 16 convolutions with a
    // 5x5 filter size and 1x1 stride to the output of a subnetwork, then apply ReLU, then
    // perform max pooling with a 2x2 window and 2x2 stride.  



    // So with that out of the way, we can make a network instance.
    net_type net;
    
    if( train_me == true )
    {

#define QUOTE(q) Q(q)
#define Q(q) #q

    	    #ifdef CUSTOMIZED
    	    	cerr << endl << endl << "Input " << "  = " << input_count << "\t" << QUOTE(INPUTTYPE) << endl;
    	    #endif
	    #if( CUSTOMIZED >= 1 )
    	    	cerr << "Layer " << 1 << " = " << layer1_count << "\t" << QUOTE(LAYER1TYPE) << endl;
    	    #endif
	    #if( CUSTOMIZED >= 2 )
    	    	cerr << "Layer " << 2 << " = " << layer2_count << "\t" << QUOTE(LAYER2TYPE) << endl;
    	    #endif
	    #if( CUSTOMIZED >= 3 )
    	    	cerr << "Layer " << 3 << " = " << layer3_count << "\t" << QUOTE(LAYER3TYPE) << endl;
    	    #endif
	    #if( CUSTOMIZED >= 4 )
    	    	cerr << "Layer " << 4 << " = " << layer4_count << "\t" << QUOTE(LAYER4TYPE) << endl;
    	    #endif
    	    #ifdef CUSTOMIZED
    	    	cerr << endl << endl << flush;
    	    #endif
    	    
    	    	
    
          load_morse_code_training( training_images, training_labels, testing_images, testing_labels, training_count, testing_count);
          
	    // And then train it using the MNIST data.  The code below uses mini-batch stochastic
	    // gradient descent with an initial learning rate of 0.01 to accomplish this.
	    dnn_trainer<net_type> trainer(net);
	    trainer.set_learning_rate(0.01);
	    trainer.set_min_learning_rate(0.00001);
	    trainer.set_mini_batch_size(128);
	    trainer.be_verbose();
	    // Since DNN training can take a long time, we can ask the trainer to save its state to
	    // a file named "mnist_sync" every 20 seconds.  This way, if we kill this program and
	    // start it again it will begin where it left off rather than restarting the training
	    // from scratch.  This is because, when the program restarts, this call to
	    // set_synchronization_file() will automatically reload the settings from mnist_sync if
	    // the file exists.
	    trainer.set_synchronization_file("nn_cw_sync", std::chrono::seconds(20));
	    // Finally, this line begins training.  By default, it runs SGD with our specified
	    // learning rate until the loss stops decreasing.  Then it reduces the learning rate by
	    // a factor of 10 and continues running until the loss stops decreasing again.  It will
	    // keep doing this until the learning rate has dropped below the min learning rate
	    // defined above or the maximum number of epochs as been executed (defaulted to 10000). 
	    trainer.train(training_images, training_labels);

	    // At this point our net object should have learned how to classify MNIST images.  But
	    // before we try it out let's save it to disk.  Note that, since the trainer has been
	    // running images through the network, net will have a bunch of state in it related to
	    // the last batch of images it processed (e.g. outputs from each layer).  Since we
	    // don't care about saving that kind of stuff to disk we can tell the network to forget
	    // about that kind of transient data so that our file will be smaller.  We do this by
	    // "cleaning" the network before saving it.
	    net.clean();
	    serialize("nn_cw_network.dat") << net;
	    // Now if we later wanted to recall the network from disk we can simply say:
	    // deserialize("mnist_network.dat") >> net;


	    // Now let's run the training images through the network.  This statement runs all the
	    // images through it and asks the loss layer to convert the network's raw output into
	    // labels.  In our case, these labels are the numbers between 0 and 9.
	    std::vector<lab_type> predicted_labels = net(training_images);
	    int num_right = 0;
	    int num_wrong = 0;
	    // And then let's see if it classified them correctly.
	    for (size_t i = 0; i < training_images.size(); ++i)
	    {
		if (predicted_labels[i] == training_labels[i])
		    ++num_right;
		else
		    ++num_wrong;
		
	    }
	    cout << "training num_right: " << num_right << endl;
	    cout << "training num_wrong: " << num_wrong << endl;
	    cout << "training accuracy:  " << num_right/(double)(num_right+num_wrong) << endl;

	    // Let's also see if the network can correctly classify the testing images.  Since
	    // MNIST is an easy dataset, we should see at least 99% accuracy.
	    predicted_labels = net(testing_images);
		softmax<net_type::subnet_type> snet; snet.subnet() = net.subnet();
		//auto &sp = ((snet(testing_images.begin(), testing_images.end())));
		//std::vector<matrix<float>> sp = ((snet(testing_images)));
	    num_right = 0;
	    num_wrong = 0;
	    for (size_t i = 0; i < testing_images.size(); ++i)
	    {
		if (predicted_labels[i] == testing_labels[i])
			{
		    ++num_right;
				if( correct_out == true )
				{
					print_input( testing_images[i], testing_labels[i], predicted_labels[i] );
					//print_image( testing_images[i], testing_labels[i], sp[i] );
					//matrix<float,1,10> sp = sum_rows(mat(snet(testing_images.begin()+i, testing_images.begin()+(i+1))));
					matrix<float,1,5> sp = mat(snet(testing_images.begin()+i, testing_images.begin()+(i+1)));
					print_probs( sp, i );
				}
			
			}
		else
			{
		    ++num_wrong;
				
				if( wrong_out == true )
				{
					print_input( testing_images[i], testing_labels[i], predicted_labels[i] );
					//print_image( testing_images[i], testing_labels[i], sp[i] );
					//matrix<float,1,10> sp = sum_rows(mat(snet(testing_images.begin()+i, testing_images.begin()+(i+1))));
					matrix<float,1,5> sp = (mat(snet(testing_images.begin()+i, testing_images.begin()+(i+1))));
					print_probs( sp, i );
				}
		}
	    }
	    cout << "testing num_right: " << num_right << endl;
	    cout << "testing num_wrong: " << num_wrong << endl;
	    cout << "testing accuracy:  " << num_right/(double)(num_right+num_wrong) << endl;


	    // Finally, you can also save network parameters to XML files if you want to do
	    // something with the network in another tool.  For example, you could use dlib's
	    // tools/convert_dlib_nets_to_caffe to convert the network to a caffe model.
	    net_to_xml(net, "nn_cw_lenet.xml");
	}
	else
	{
		deserialize("nn_cw_network.dat") >> net;
		
		
		string str;
		
		std::map<lab_type, string> labels;
		
		labels[0] = "L";
		labels[1] = "G";
		labels[2] = "g";
		labels[3] = ".";
		labels[4] = "-";
		
		labels[0] = "\n\n";
		labels[1] = "\n";
		labels[2] = "";
		labels[3] = ".";
		labels[4] = "-";
		
		training_images.push_back( matrix<in_type, 1, input_count>() );
		
		while( !getline( cin, str ).eof() )
		{
			stringstream ss( str );
			
			matrix<in_type, 1, input_count> img;
			lab_type lab;

			//ss >> lab;

			for( int i=0; i < img.nr(); i++ )
			{
				for( int j=0; j < img.nc(); j++ )
				{
					ss >> img( i, j );
				}
			}
			
			training_images[0] = img;


			std::vector<lab_type> predicted_labels = net(training_images);
			
			//cout << labels[ predicted_labels[0] ];
			cout << labels[ predicted_labels[0] ] << flush;
			
			fflush( stdout );
		}
	}
}
catch(std::exception& e)
{
    cout << e.what() << endl;
}


void print_probs2( matrix<float,1,5> &softmax_probs, int x )
{
	for( int i=0; i < 5; i++ )
	{
		cout << i << "=" << softmax_probs(0,i) << "  |  ";
	}
	cout << endl;
}

void print_probs( matrix<float,1,5> &softmax_probs, int x )
{
	for( int i=0; i < 5; i++ )
	{
		printf( "%d\t", i );
	}
	cout << endl;

	for( int i=0; i < 5; i++ )
	{
		printf( "%0.1f%%\t", (float)softmax_probs(0,i) * 100.0 );
	}
	cout << endl;
}

void print_input( matrix<in_type> &img, lab_type label, lab_type predicted )
{

	for( int i=0; i<img.nr(); i++ )
	{
		for( int j=0; j<img.nc(); j++ )
		{
			cout << img( i, j ) << "\t";
		}
		cout << endl;
	}
	cout << "label=" << label << "  predicted=" << predicted << endl;
}


