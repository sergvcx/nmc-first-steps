#include "time.h"
extern "C" 
double accmul32_asm(double* a, double* b, double* c, double* d,int size);

double accmul32_cpp(double* a, double* b, double* c,double *d, int size){
	int i=0;		
	for(i=0; i<size; i++){
		d[i]=a[i]*b[i]+c[i];
	}
	return d[0];
}

#define SIZE 64

extern double buffer_a[];
extern double buffer_b[];
extern double buffer_c[];
extern double buffer_d[];

int main(){
	int i;
	clock_t t0,t1;
	for (i=0; i<SIZE; i++){
		buffer_a[i]=i+1;
		buffer_b[i]=2;
		buffer_c[i]=1000;
	}
	//d =accmul_cpp(a, b, c);
	t0=clock();
	accmul32_asm(buffer_a, buffer_b, buffer_c, buffer_d, SIZE);
	t1=clock();
	i=buffer_d[SIZE-1];
	return t1-t0; 	
			// verilog: 	234 ticks buffers are in different banks 
			// mc12101run:  203 ticks buffers are in different banks 
			// verilog: 	374 ticks buffers are in the same bank
			// mc12101run:  353 ticks buffers are in the same bank
}
