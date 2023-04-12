#include <math.h>
#include "time.h"
#include <stdio.h>

#define		N_ST	400 // число байт

unsigned int in[N_ST/4]  __attribute__ ((section (".data.imu1")));
unsigned int out[N_ST/4] __attribute__ ((section (".data.imu2")));


extern "C" {
 int clock_gettime(clockid_t, struct timespec *);
};

int main()
{
	clock_t t1, t2;
	//struct timespec	tms1, tms2;
	int a=3;
	int b=4;
	t1=clock();
	int c=b-a;
	t2=clock();
	printf("Hello %d\n", 123);
	return t2-t1;
}