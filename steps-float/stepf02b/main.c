#include "time.h"

double accmul32_asm(double* a, double* b, double* c, double* d,int size);


double accmul32_cpp(double* a, double* b, double* c,double *d, int size){
	int i=0;
	for(i=0; i<size; i++){
		d[i]=a[i]*b[i]+c[i];
	}
	return d[0];
}

#define SIZE 1024

double buffer_a[SIZE] __attribute__ ((section (".data_imu1")));
double buffer_b[SIZE] __attribute__ ((section (".data_imu2")));
double buffer_c[SIZE] __attribute__ ((section (".data_imu3")));
double buffer_d[SIZE] __attribute__ ((section (".data_imu4")));

int main(){

	clock_t t0,t1;
	int i;
	for (i=0; i<SIZE; i++){
		buffer_a[i]=i+1;
		buffer_b[i]=2;
		buffer_c[i]=1000;
	}
	//d =accmul_cpp(a, b, c);
	t0=clock();
	accmul32_asm(buffer_a, buffer_b, buffer_c, buffer_d, SIZE);
	t1=clock();
	return t1-t0;
}

// SIZE CLOCKS
// 1024 4343  4343/1024 = 4,2412109375 (a,b,c,d,code in the same bank)
// 1024 4179  4179/1024 = 4,0810546875 (a,d,b,d - in one bank & code in other bnak)
// 1024 1639 mc12101run: 1639/1024 = 1,6005859375 (a,b,c,d,code - in different banks)
// 1024 1639 verilog   : 1674/1024 = 1,6305859375 (a,b,c,d,code - in different banks)
 
