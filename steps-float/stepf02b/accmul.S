//#include "printx.hs"
//PRINTF1("ar0=%x\n",ar0)
//PRINTF1("ar1=%x\n",ar1)
//PRINTF1("ar2=%x\n",ar2)
//PRINTF1("ar3=%x\n",ar3)
//PRINTF1("gr3=%x\n",gr3)

.global _accmul_asm
.data
	result: .quad

.text
_accmul_asm:
	
	ar5 = ar7 - 2;
	push ar0,gr0;
	push ar1,gr1;
	push ar2,gr2;
	push ar3,gr3;
	

	ar0 = [--ar5];	// a
	ar1 = [--ar5];	// b
	ar2 = [--ar5];	// c
	ar3 = [--ar5];	// d
	gr3 = [--ar5];	// size
	gr7 = gr3 >>5;  // gr7=size/32
	gr3 = gr3<<27 ;
	gr3 = gr3>>27 ;  // gr3=size%32
		
	with gr7;		
	if =0 goto accmul_tail with gr7--;
		
	accmul_rep32:
		fpu 0 rep 32 vreg0 = [ar0++]; 
		fpu 0 rep 32 vreg1 = [ar1++]; 
		fpu 0 rep 32 vreg2 = [ar2++]; 
	if > delayed goto accmul_rep32 with gr7--;
		fpu 0 .double vreg3 = vreg0*vreg1+vreg2;
		fpu 0 rep 32 [ar3++] = vreg3;
		
	accmul_tail:
	with gr3;
	if =0 delayed goto accmul_end with gr3--;
		vlen = gr3;
		nul;
		
	fpu 0 rep vlen vreg0 = [ar0++]; 
	fpu 0 rep vlen vreg1 = [ar1++]; 
	fpu 0 rep vlen vreg2 = [ar2++]; 
	fpu 0 .double vreg3 = vreg0*vreg1+vreg2;
	fpu 0 rep vlen [ar3++] = vreg3;
		
	accmul_end:
	
	pop ar3,gr3;
	pop ar2,gr2;
	pop ar1,gr1;
	pop ar0,gr0;

	return;
