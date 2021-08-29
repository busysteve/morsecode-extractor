

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

const double PI = 3.141592653589793238463;

unsigned int bitReverse(unsigned int x, int log2n) 
{
  int n = 0;
  int mask = 0x1;
  for (int i=0; i < log2n; i++) {
    n <<= 1;
    n |= (x & 1);
    x >>= 1;
  }
  return n;
}

template<class Iter_T>
void fft(Iter_T a, Iter_T b, int log2n)
{
  typedef typename iterator_traits<Iter_T>::value_type complex;
  const complex J(0, 1);
  int n = 1 << log2n;
  for (unsigned int i=0; i < n; ++i) {
    b[bitReverse(i, log2n)] = a[i];
  }
  for (int s = 1; s <= log2n; ++s) {
    int m = 1 << s;
    int m2 = m >> 1;
    complex w(1, 0);
    complex wm = exp(-J * (PI / m2));
    for (int j=0; j < m2; ++j) {
      for (int k=j; k < n; k += m) {
	complex t = w * b[k + m2];
	complex u = b[k];
	b[k] = u + t;
	b[k + m2] = u - t;
      }
      w *= wm;
    }
  }
}



template<class cT, class T>
void fftv( cT& a, cT& b, int log2n)
{

  const complex<T> J(0, 1);
  int n = 1 << log2n;
  for (unsigned int i=0; i < n; ++i) {
    b[bitReverse(i, log2n)] = a[i];
  }
  for (int s = 1; s <= log2n; ++s) {
    int m = 1 << s;
    int m2 = m >> 1;
    complex<T> w(1, 0);
    complex<T> wm = exp(-J * (PI / m2));
    for (int j=0; j < m2; ++j) {
      for (int k=j; k < n; k += m) {
	complex<T> t = w * b[k + m2];
	complex<T> u = b[k];
	b[k] = u + t;
	b[k + m2] = u - t;
      }
      w *= wm;
    }
  }
}



int main( ) {
	typedef complex<double> cx;
	
	short sample;

	//vector<int> data;

	std::cin.clear();
	std::cin.ignore();
	std::freopen(nullptr, "rb", stdin);
	
        if(std::ferror(stdin))
            throw std::runtime_error(std::strerror(errno));

    const int N = 4096;

        std::size_t len;
        std::array<short, N> buf;
        std::array<cx, N> ana_in;
        std::array<cx, N> ana_out;

    fftw_complex *in, *out;
    fftw_plan p;

    in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N );
    out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N );
    
    //p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
    p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_MEASURE);




        // use std::fread and remember to only use as many bytes as are returned
        // according to len
        while((len = std::fread(buf.data(), sizeof(buf[0]), buf.size(), stdin)) > 0)
        {
		// somewhere to store the data
		std::vector<char> input;

            // whoopsie
            if(std::ferror(stdin) && !std::feof(stdin))
                throw std::runtime_error(std::strerror(errno));

            // use {buf.data(), buf.data() + len} here
            input.insert(input.end(), buf.data(), buf.data() + len); // append to vector
            
		for( int i = 0; i < ana_in.size(); i++ )
		{
			ana_in[i] = cx(input[i]);
			ana_out[i] = cx(0);
		}
			
		for( int i = 0; i < ana_in.size(); i++ )
		{
			auto *x = reinterpret_cast<fftw_complex*>( &(ana_in[i]) );
			in[i][0] = (*x)[0];
			in[i][1] = (*x)[1];
		}
			
            
    		fftw_execute(p); /* repeat as needed */

		for( int i = 0; i < ana_out.size(); i++ )
		{
		  	auto *x = reinterpret_cast<cx*>( &(out[i]) );
			ana_out[i].real( (*x).real() );
			ana_out[i].imag( (*x).imag() );
		}
			
            
            	//fft( ana_in.begin(), ana_out.begin(), 4 );

		for( auto o : ana_out )
			cout << o << endl;
        }

    fftw_destroy_plan(p);
    fftw_free(in); fftw_free(out);


}



	
	
