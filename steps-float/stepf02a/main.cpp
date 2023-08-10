#include "time.h"
#include "stdio.h"
extern "C" void accmul_asm(double* a, double* b, double* c, double* d,int size);

void accmul_cpp(double* a, double* b, double* c,double *d, int size){
	for(int i=0; i<size; i++){
		d[i]=a[i]*b[i]+c[i];
	}
}

#define SIZE 1024
double buffer_a[SIZE];
double buffer_b[SIZE];
double buffer_c[SIZE];
double buffer_d[SIZE];
double buffer_D[SIZE];

int main(){
	int i;
	clock_t t0,t1;
	// инициализация
	for (i=0; i<SIZE; i++){
		buffer_a[i]=i+1;
		buffer_b[i]=2;
		buffer_c[i]=1000;
	}

	t0=clock();
	t1=clock();
	clock_t dt=t1-t0; // Оценка коррекции замера времени
	
	t0=clock();
	accmul_asm(buffer_a, buffer_b, buffer_c, buffer_d, SIZE);
	t1=clock();
	clock_t dt_asm=t1-t0-dt;	// время asm-функции

	t0=clock();
	accmul_cpp(buffer_a, buffer_b, buffer_c, buffer_D, SIZE);
	t1=clock();
	clock_t dt_cpp=t1-t0-dt;    // время cpp-функции

	printf("   lang: %12s %12s\n","buffer_d(asm)","buffer_D(c++)");
	printf("    res: %e %e\n",buffer_d[0], buffer_D[0]);
	printf("             ...          ...\n");
	printf("    res: %e %e\n",buffer_d[SIZE-1], buffer_D[SIZE-1]);
	printf(" clocks: %12ld %12ld\n", dt_asm, dt_cpp);
	printf("cl/elem: %12.2f %12.2f\n", 1.0*dt_asm/SIZE, 1.0*dt_cpp/SIZE);
	
	return 0; 	
}
