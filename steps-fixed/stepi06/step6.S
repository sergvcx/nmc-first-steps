.global __main        // объявление глобальной метки.
	
.p2align 3            // директива для выравнивания секции по  чётному адресу.	
.section .data.MyData // секция инициализированных данных
    // исходный вектор
	A: .quad 0x8877665544332211
    // место для хранения результата вычислений
	B: .quad 0x0
    // массив Matr содержит значения 
	// для заполнения матрицы весовых коэффициентов
    Matr: .quad     0x0100000000000000, \
                    0x0001000000000000, \
                    0x0000010000000000, \
                    0x0000000100000000, \
                    0x0000000001000000, \
                    0x0000000000010000, \
                    0x0000000000000100, \
                    0x0000000000000001 
	
.macro SET reg,val
#if __NM4__== 0
	\reg = \val; 
#else
	sir = \val; 
	\reg = sir;   
#endif
.endm
	
.section .text.AAA    // начало секции кода.
__main:	
    ar1 = Matr;	
	
	SET nb1, 80808080h  // разбиение матрицы на 8 столбцов по 8 бит
	SET sb,  03030303h  // матрица делится на 8 строк
    

    // весовые коэффициенты загружаются в буфер wfifo
    rep 8 wfifo = [ar1++];
    ftw;              // весовые коэффициенты пересылаются в теневую матрицу 
                      // с перекодировкой. Эта инструкция всегда выполняется 32 
                      // такта. 
    wtw;              // весовые коэф.копируются  из теневой матрицы в рабочую 
    ar2 = A;	
    ar4 = B;	

    // операция взвешенного суммирования, переставляющая местами байты вектора.
    rep 1 data = [ar2] with vsum , data, 0;
    // результат операции выгружается из afifo в память
    rep 1 [ar4] = afifo;

    return;	

