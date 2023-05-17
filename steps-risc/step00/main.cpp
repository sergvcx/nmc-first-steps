#include <time.h>
#include <stdio.h>
#include <string.h>
#define		SIZE	400 
unsigned int in[SIZE]  __attribute__ ((section (".data.imu1")));
unsigned int out[SIZE] __attribute__ ((section (".data.imu2")));
extern "C" {
 int clock_gettime(clockid_t, struct timespec *);
};

int main()
{
	clock_t t1, t2;
	//struct timespec	tms1, tms2;
	volatile int a=3;
	volatile int b=4;
	t1=clock();
	volatile int c=b-a;
	memcpy(in,out,SIZE);
	t2=clock();
	printf("NMC Hello %d %d\n", c, int(t2-t1));
	return 777;
}
