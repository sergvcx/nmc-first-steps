#include "time.h"


//extern "C" {
double accmul_asm(double a, double b, double c);
extern double buffer_a[];
extern double buffer_b[];
extern double buffer_c[];
extern double buffer_d[];

double accmul_cpp(double a, double b, double c){
	return a*b+c;
}


int main(){
	
	clock_t t0,t1;
	double d;
	//led();
	//d =accmul_cpp(a, b, c);
	buffer_a[0] = 3.3333333333333333333333;
	buffer_b[0] = 4.4444444444444444444444;
	buffer_c[0] = 5.5555555555555555555555;
	t0=clock();
	d =accmul_asm(buffer_a[0], buffer_b[0], buffer_c[0]);
	t1=clock();
	//int i=d;
	int *pd=(int*)&d;
	return *(pd);
	//return (t1-t0)/500000; 
	
	return (t1-t0); 
	//0x40345ED0-91CCF4BA
	// 40345ED0
	// 187
	// mc12101run : 307 ticks
}
//};