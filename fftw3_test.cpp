#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <fftw3.h>
#include <iostream>
#include <cmath>
#include <fstream>
#include <iostream>
#include <fstream>
#include <vector>
#include <array>
#include <complex>
#include <string>
#include <cstring>
#include <cmath>
#include <float.h>
#include <fftw3.h>



using namespace std;

int main() {
        int i;
        double y;
        const int N = 4*1024; //Number of points acquired inside the window
        double Fs = 8000; //sampling frequency
        double dF = Fs / N;
        double T = 1 / Fs; //sample time 
        double f = 50; //frequency
        double * in ;
        fftw_complex * out;
        double t[N]; //time vector 
        double ff[N];
        fftw_plan plan_forward;

        in = (double * ) fftw_malloc(sizeof(double) * N);
        out = (fftw_complex * ) fftw_malloc(sizeof(fftw_complex) * N);

        for (int i = 0; i <= N; i++) {
                t[i] = i * T;

                in [i] = 0.7 * sin(2 * M_PI * f * t[i]); // generate sine waveform
                double multiplier = 0.5 * (1 - cos(2 * M_PI * i / (N - 1))); //Hanning Window
                in [i] = multiplier * in [i];
        }

//-------------------------------------------------------------------------
	typedef complex<double> cx;
	
	short sample;

	//vector<int> data;

	std::cin.clear();
	std::cin.ignore();
	std::freopen(nullptr, "rb", stdin);
	
        if(std::ferror(stdin))
            throw std::runtime_error(std::strerror(errno));

    //const int N = 4096;

        std::size_t len;
        std::array<short, N> buf;
        std::array<double, N> ana_in;
        std::array<cx, N> ana_out;


        //while((len = std::fread(buf.data(), sizeof(buf[0]), buf.size(), stdin)) > 0)
        len = std::fread(buf.data(), sizeof(buf[0]), buf.size(), stdin);
        
        //{
		// somewhere to store the data
		std::vector<short> input;

            // whoopsie
            if(std::ferror(stdin) && !std::feof(stdin))
                throw std::runtime_error(std::strerror(errno));

            // use {buf.data(), buf.data() + len} here
            input.insert(input.end(), buf.data(), buf.data() + len); // append to vector
            
            // convert the s16 input to float for calculating
		for( int i = 0; i < N; i++ )
		{
			in[i] = ( ( (double)input[i] ) / ( (double) (1 << 16) ) );
		}
			

//-------------------------------------------------------------------------


		for (int i = 0; i <= ((N / 2) - 1); i++) {
		        ff[i] = Fs * i / N;
		}
		
		plan_forward = fftw_plan_dft_r2c_1d(N, in , out, FFTW_ESTIMATE);

		fftw_execute(plan_forward);

		double v[N];

		for (int i = 0; i <= ((N / 2) - 1); i++) {

		        v[i] = (20 * log(sqrt(out[i][0] * out[i][0] + out[i][1] * out[i][1]))) / N; //Here   I  have calculated the y axis of the spectrum in dB

		}

	//}


        //fstream myfile;

        //myfile.open("example2.txt", fstream::out);
        cout << "set term png" << std::endl;
        cout << "set output printme.png" << std::endl;

        cout << "plot '-' using 1:2" << std::endl;

        for (i = 0; i < ((N / 2) - 1); i++)

        {

                cout << ff[i] << " " << v[i] << std::endl;

        }

        //myfile.close();

        fftw_destroy_plan(plan_forward);
        fftw_free( in );
        fftw_free(out);
        return 0;
}
