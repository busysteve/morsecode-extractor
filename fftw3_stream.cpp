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
#include <map>
#include <algorithm>
#include <array>
#include <complex>
#include <string>
#include <cstring>
#include <cmath>
#include <float.h>
#include <fftw3.h>



using namespace std;


struct ordering {
    bool operator ()(pair<double, double> const& a, pair<double, double> const& b) {
	return (a.first) > (b.first);
    }
};





int main( int argc, char** argv ) {
        int i;
        double y;
        double Fs = atoi( argv[1] ); //sampling frequency
        int N = atoi( argv[2] ); //Number of points acquired inside the window

	int dig = atoi( argv[3] );

        int freq_cen = atoi( argv[4] ); //min pass frequency
        int freq_wid = atoi( argv[5] ); //max pass frequency

	double freq_min_db = atof( argv[6] ); // min db

	double freq_slope = atof( argv[7] ); // min db

	double gnu_plot_report = atoi( argv[8] ); // min db

        int freq_min = freq_cen - freq_wid; //min pass frequency
        int freq_max = freq_cen + freq_wid; //max pass frequency

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
        //std::array<short, N> buf;
        short buf[N];
        double ana_in[N];



        //while((len = std::fread(buf.data(), sizeof(buf[0]), buf.size(), stdin)) > 0)
        while((len = std::fread(buf, sizeof(buf[0]), N, stdin)) > 0)
        {
		// somewhere to store the data
		std::vector<short> input;

            // whoopsie
            if(std::ferror(stdin) && !std::feof(stdin))
                throw std::runtime_error(std::strerror(errno));

            // use {buf.data(), buf.data() + len} here
            input.insert(input.end(), buf, buf + len); // append to vector
            
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


/*
		for (i = 0; i < ((N / 2) - 1); i++)
		{
		        cout << ff[i] << " " << v[i] << std::endl;
		}
*/

		vector<pair<double, double> > order(N);
		map<double, double> spectrum;
		map<double, double>::iterator spectrum_it;
		
		for ( int i=0; i < N; i++ )
		{
		    order[i] = make_pair( v[i], ff[i] );
		    spectrum[ff[i]] = v[i];
		}
		
		sort( order.begin(), order.end(), ordering() );

		//auto m = max( order.begin(), order.end(), ordering() );
		
		if( gnu_plot_report > 0 )
		{
			cout << "set term png" << std::endl;
			cout << "set output printme.png" << std::endl;

			cout << "plot '-' using 1:2" << std::endl;

			for (i = 0; i < ((N / 2) - 1); i++)

			{

				cout << ff[i] << " " << v[i] << std::endl;

			}

			break;
		}
		
		for( int count=0,i=0; i < order.size() && count < dig; i++ )
		{
			if( count > 0 )
				cout << ",";
				
			double freq = order[i].second;
			
			if( order[i].second >= freq_min && order[i].second <= freq_max )
			{
				double freq_db = order[i].first;
				double freq_left_db=0;
				double freq_right_db=0;
				double freq_left=1;
				double freq_right=1;
				
				
				if( freq_db >= freq_min_db )
				{
					spectrum_it = spectrum.find( freq );
					if( spectrum_it != spectrum.begin() )
					{
						spectrum_it--;				
						freq_left = spectrum_it->first;
						freq_left_db = spectrum_it->second;
						spectrum_it++;
					}
					
					if( spectrum_it++ != spectrum.end() )
					{
						freq_right = spectrum_it->first;
						freq_right_db = spectrum_it->second;
					}
					
					
						
					//double slope_left = (freq_db - freq_left_db) / ( freq - freq_left ); 
					//double slope_right = (freq_right_db - freq_db) / ( freq_right - freq ); 
					
					double slope_left = (freq_db - freq_left_db); 
					double slope_right = (freq_db - freq_right_db); 
					
					if( slope_left >= freq_slope && slope_right >= freq_slope )
					{
						cout << order[i].first << ":" << order[i].second << "     " << slope_left << "   " << slope_right;				
						count++;
					}
				}
			}
			else
			{
				//cout << "0:0";
				//break;
			}
		}
		cout << endl;
/*
		for ( auto o : order )
			cout << o.first << " - " << o.second << endl;
*/		
	}




        fftw_destroy_plan(plan_forward);
        fftw_free( in );
        fftw_free(out);
        return 0;
}
















