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
	push ar4,gr4;
	push ar5,gr5;

	
	fpu 0 rep 1 vreg0 = [--ar5]; 
	fpu 0 rep 1 vreg1 = [--ar5]; 
	fpu 0 rep 1 vreg2 = [--ar5]; 
	
	fpu 0 .double vreg3 = vreg0*vreg1+vreg2;
	
	ar5 = result;
	
	fpu 0 rep 1 [ar5] = vreg3;
	
	
	ar0,gr0 = [ar5];
	
	gr7 = [result];
	gr6 = [result+1];
	
	pop ar5,gr5;
	pop ar4,gr4;
	pop ar3,gr3;
	pop ar2,gr2;
	pop ar1,gr1;
	pop ar0,gr0;

	return;

