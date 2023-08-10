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
	gr7 = [--ar5];	// size

	gr7--;			// loop counter --
	ar5 = ar3;		// store dst address
	next_accmul:
		fpu 0 rep 1 vreg0 = [ar0++]; 
		fpu 0 rep 1 vreg1 = [ar1++]; 
		fpu 0 rep 1 vreg2 = [ar2++]; 
		fpu 0 .double vreg3 = vreg0*vreg1+vreg2;
		fpu 0 rep 1 [ar3++] = vreg3;
	if <>0 goto next_accmul with gr7--;
	
	
	pop ar3,gr3;
	pop ar2,gr2;
	pop ar1,gr1;
	pop ar0,gr0;

	return;
