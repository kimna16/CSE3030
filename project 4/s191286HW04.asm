TITLE UPHILLS

; Program Description:                Find the biggest gaps of uphills given by tester and print them on screen
; Author(Student ID):                 nahyun kim(20191286)
; Creation Date:                      2021-05-22
; Input:                              number of the tests, list sizes, heights 
; Output:                             the biggest gaps of uphills 
; Modification Date:                  2021-05-23

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW04.inc

.code
main PROC
   mov ecx, TN                          ;L1 loop�� TN�� ���ƾ� �ϱ� ������ ecx�� TN�� ������. 
   cmp ecx, 0
   je L9
   mov esi, OFFSET HEIGHT               ;Indirect operands�� ����ϱ� ���� esi�� HEIGHT�� OFFSET�� ������.
   L1:
      cmp ecx, TN                       ;ecx�� TN�� ���Ͽ� ecx�� TN�� ������, �� L1 loop�� ó�� ���� ��Ȳ�̸� L2�� ������. 
      push ecx                          ;L1 loop�� TN�� ���� L1 �ȿ��� �ٸ� loop�� ���� ���� ecx�� stack�� push��.  
      je L2                             ;ecx = TN�̸� L2�� ������. 
      mov ecx, DWORD PTR [esi]          ;ecx�� TN�� ���� ������, [esi]�� ecx�� ������. 
      add esi, 4                        ;DWORD�� ����ϰ� �����Ƿ� esi�� 4�� ������.  
      jmp L3

      L2:                               ;ecx = TN�̸� ecx�� CASE�� ������. 
        mov ecx, CASE
        
      L3:                               ;�ʱ�ȭ ����
        mov edx, 0                      ;edx = 0, edx�� ���� ���̸� ���� �� ����� register��. 
        mov eax, DWORD PTR [esi]        ;eax = DWORD PTR [esi]
        add esi, 4                       
        cmp ecx, 1                      
        je L8                           ;ecx�� 1�̸� ���� �ϳ����̹Ƿ� loop�� �� �ʿ� ���� 0�� ����ϸ� ��. 
        dec ecx                         ;ù ��° ���� eax�� �����Ͽ����Ƿ� L4 loop�� (ecx - 1)�� ���鼭 ���� Ȯ���ϸ� ��. 
        mov ebx, eax                    ;ebx = eax

      L4:
         push ecx                       ;ecx�� �ٸ� ���� �����Ͽ� ����ϱ� ���� stack�� push��. 
         mov ecx, DWORD PTR [esi]
         add esi, 4
         cmp ebx, ecx                   
         jae  L5                        ;ebx >= ecx�̸�, �� �� �̻� ���������� �ƴ� ���, L5�� ������. 
         jmp L6                    

         L5:                            ;ebx >= ecx�̸� 
            sub ebx, eax                ;ebx = ebx - eax, �� ���� ���̸� ������. 
            mov eax, ecx                ;eax = ecx
            cmp edx, ebx                
            jae L6                      ;edx >= ebx�̸� L6�� ������. 
            mov edx, ebx                ;edx < ebx�̸� edx�� ebx�� ������.            

         L6:                            
           mov ebx, ecx                 ;ebx = ecx  
           pop ecx
           cmp ecx, 1                   
           jne L7                       ;ecx�� 1�� �ƴϸ� L7�� ������. 
           cmp eax, ebx                
           je L7                        ;eax�� ebx�� ������ �̹� ��(L5)���� ����� ����. 
           sub ebx, eax                 ;eax�� ebx�� ���� ������ �� ���� ���� ������ ���������� ���� ���� ���� list�� �� ������ height�� ���ؼ��� �������� ��. 
           cmp edx, ebx                
           jae L7                       ;edx >= ebx�̸� L7�� ������. 
           mov edx, ebx                 ;edx < ebx�̸� edx�� ebx�� �����Ͽ� ���� ū �� ���̸� �����ؾ� ��. 

         L7:
           loop L4
     
      L8:   
        mov eax, edx
        call WriteDec                   ;eax�� �����. 
        call Crlf                       ;new line�� �����. 
        pop ecx                         ;L1 loop�� �ٽ� �� ������ Ȯ���ϱ� ���� stack�� �־���� ecx�� pop��. 
      loop L1

   L9:
    exit
main ENDP
END main