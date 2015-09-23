global _Mask: label;  // ����������� ���������� ����� _Mask
	
data ".my_data"	
    Temp: long = 0l;
end ".my_data";	
begin ".text"	
<_Mask>	
    ar5 = ar7 - 2;    // ����������� ��������� �����
    push ar0, gr0;    // � ����� ����������� ����������� ����
    push ar1, gr1;	
    push ar2, gr2;	
		
    ar0 = [--ar5];    // � ar0 ����������� ����� �������
    gr0 = [--ar5];    // � gr0 ����������� �����:  00000044h
		
    ar2 = ar0;        // ����� �������� ������� ���������� � ar2
    gr1 = gr0 << 8;   // gr1 = 00004400
    gr0 = gr0 or gr1; // gr0 = 00004444
    gr1 = gr0 << 16;  // gr1 = 44440000
    gr1 = gr0 or gr1; // gr0 = 44444444
    ar1 = gr1;	
    // � ���������� Temp ������������ �������� �����: 4444444444444444h,
    // ��� ���� � ������� ar1 ��������� ����� ���� ����������.
    [ar1 = Temp] = ar1, gr1;
	
    nb1 = 80808080h;	
    wtw;	
    // ������� ���������� �������� ���������, ����� ��������� �������, ����������� 
    // �� ������� X ���������� ����������.
    f1cr = 80808080h;	
		
    rep 32 ram = [ar0++];
    rep 32 data = [ar1] with ram - data;
	
    // ���������� ���������� ������� ��������� � ����������� afifo.
    rep 32 with not activate afifo;
    // ���������� �������� ������������, ����� �������� � afifo, � ������� X �������� 
    // ������ � ���� ������, � ������� Y ������ �� ram.
    rep 32 data = [ar1] with mask afifo, data, ram;
    // ��������� �������� ����������� �� ������� ������.
    rep 32 [ar2++] = afifo;
	
    pop ar2, gr2;	  // �������������� ����������� ��� �� �����
    pop ar1, gr1;	
    pop ar0, gr0;	
    return;	
		
end ".text";	
