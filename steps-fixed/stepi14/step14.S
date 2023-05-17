.global __main	

.p2align 3            	  	// директива для выравнивания секции по  чётному адресу.		
.section .data.MyData	
	.global A
	A: .quad 	0, 1, 2, 3, 4, 5, 6, 7,	8, 9, 10, 11, 12, 13, 14, 15 
	

.p2align 3            	  	// директива для выравнивания секции по  чётному адресу.		
.section .data.MyData1
	.global C
	C: .space 16<<3
	
.text	
__main:	

#if __NM4__== 0
.branch;     // псевдокоманда разрешения параллельного выполнения 
             // векторных инструкций.
#endif

	ar0 = A;	
	ar4 = C;	
		
	rep 16 data = [ar0++] with data;
	rep 16 [ar4++] = afifo;
	
	return;	
#if __NM4__== 0	
.wait;       // запрет параллельного выполнения векторных инструкций
#endif

	
