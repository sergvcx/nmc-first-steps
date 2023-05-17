.global _AddBias 	

.p2align 3            	  	// директива для выравнивания секции по  чётному адресу.		
.data	
	// веса для матрицы, единичная диагональ, данные проходят без изменений
	Weights: .quad   1, 1<<16, 1<<32, 1<<48
	

.macro SET reg,val
#if __NM4__== 0
	\reg = \val; 
#else
	sir = \val; 
	\reg = sir;   
#endif
.endm

.section .text.AAA
_AddBias:	
	ar5 = ar7 - 2;	
	push ar0, gr0;	
	push ar4, gr4;	
		
	gr4 = [--ar5];	  // адрес массива
	gr0 = [--ar5];	  // количество 16-разрядных слов в массиве
		
	//nb1 = 80008000h;  // 4 столбца
	//sb  = 00030003h;  // 4 строки
	SET nb1, 80008000h
	SET sb,  00030003h
		
	// gr0 преобразуется из кол-ва 16-разрядных слов в кол-во 64-разрядных векторов
	ar4 = Weights with gr0 >>= 2;
	
	// веса загружаются в рабочую матрицу
	rep 4 wfifo = [ar4++], ftw, wtw;
		
	vr = [--ar5];	  // в регистр vr загружается константный вектор  
		
	// gr0 будет определять количество циклов, где каждый цикл обрабатывает 
	// по 32 вектора
	ar0 = gr4 with gr0 >>= 5;
	ar4 = gr4 with gr0--;
Loop:
	if > delayed goto Loop with gr0--;
	// входные вектора, проходя через матричный умножитель, суммируются с vr
	rep 32 data = [ar0++] with vsum , data, vr;
	rep 32 [ar4++] = afifo;
	
	pop ar4, gr4;	
	pop ar0, gr0;	
	return;	

