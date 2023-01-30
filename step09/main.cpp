// функция Mask объявлена как внешняя с —и-связыванием
extern "C" void Mask ( long *A, int msk );

long A[32];	       // объявление массива из 32 64-разрядных векторов
	
int main()
{
	for ( int i=0; i< 32; i++)
	{
	// массив заполняется на чальными значениями
	A[i] = 0x0102030405060708*i;
	}
	Mask(A, 0x44); // вызов функции Mask, первый параметр - адрес массива 
                   // значений, второй - маска.
	return 0;
}
