TITLE ListSum

; Program Description:                ���ڿ��� �Է� �޾� ���� ������ �����Ͽ� �ϳ��� �迭�� �����ϰ� �̵��� ���� ���� ����Ѵ�.  
; Author(Student ID):                 nahyun kim(20191286)
; Creation Date:                      2021-05-27
; Input:                              ������ ���� ���ڿ�(input)�� �Է� �޾� �迭 output�� �����Ѵ�. 
; Output:                             ���ڿ��� �ִ� �������� �̾� ���ο� �迭�� �����ϰ�, ������ ���� ����Ѵ�.  
; Modification Date:                  2021-05-30

INCLUDE Irvine32.inc
 
makeArray PROTO val1: PTR DWORD, val2: DWORD, val3: PTR SDWORD               ;INVOKE directive�� ����Ͽ� ȣ���� ���̱� ������ prototype�� �����ؾ� ��. 

.data
BUF_SIZE EQU 255                                                             ;null character�� �����ϰ� �Է� ���� ������ �ִ� ���� 
input BYTE 256 DUP(?)                                                        ;�Է� ���� ���ڿ��� �����ϱ� ���� ����
inputN DWORD ?                                                               ;null character�� �����ϰ� �Է� ���� ������ ���� 
output SDWORD 125 DUP(?)                                                     ;�Է� ���� ���ڿ����� signed integer�� �����Ͽ� �����ϱ� ���� ���� 
enternumbers BYTE "Enter numbers(<ent> to exit): ", 0
bye BYTE "Bye!", 0

.code
main PROC
    startpoint: 
          mov edx, OFFSET enternumbers                                       ;prompt�� ������ �����.
          call WriteString
          call Crlf                                                          ;prompt�� new line�� �����. 

          mov edx, OFFSET input
          mov ecx, BUF_Size 
          call ReadString                                                    ;�Է� ���� ���ڿ��� input�� �����ϰ�, null character�� ������ ���ڿ��� ����(size of input string)�� eax�� �����Ͽ� ��ȯ��. 
          cmp eax, 0                          
          je endpoint                                                        ;�ƹ��͵� �Է����� �ʰ� enter key�� ���� ���, ���α׷��� ������. 
          
          mov inputN, eax                                                    ;inputN�� eax�� ������. 
          mov ecx, eax                                                       ;L1 loop�� ���� ���� ecx�� eax�� ������. 

          L1:                                                                ;edx = OFFSET input
               cmp BYTE PTR [edx], 32                                        ;' '(space)�� ASCII code�� 32��.    
               jne L1Out                                                     ;L1 loop�� ���鼭 ' '�� �ƴ� �ٸ� ���ڰ� �ϳ��� ���� ���, L1Out���� �̵���. 
               inc edx
               loop L1
          jmp startpoint                                                     ;��ĭ���� �Է��ϰ� enter�� ���� ���, startpoint�� ���ư� ���ڿ��� �ٽ� �Է� ����.  

          L1Out:
               INVOKE makeArray, ADDR input, inputN, ADDR output             ;input string�� OFFSET, input string�� ũ��, output �迭�� OFFSET �Է���.             

          mov eax, 0
          L2:                                                                ;�迭 output�� ����ִ� ������ ���� ���ϱ� ���� loop, ecx�� ���ڿ����� ������ sigend integer�� ����
             add eax, SDWORD PTR [edi]
             mov DWORD PTR [edi], 0
             add edi, 4
             loop L2
         
         cmp eax, 0
         jge L3
         call WriteInt                                                       ;eax�� ������ singed number�� �����(��ȣ�� �����). 
         call Crlf                                                           ;prompt�� new line�� �����. 
         jmp startpoint

         L3:  
            call WriteDec                                                    ;eax�� ����� 0�̸� unsigned number�� �����(��ȣ�� ������� ����). 
            call Crlf                                                        ;prompt�� new line�� �����. 
            jmp startpoint

    endpoint: 
          mov edx, OFFSET bye
          call WriteString                                                   ;Bye!�� ����ϰ� ���α׷��� ������. 
          exit
main ENDP

makeArray PROC val1: PTR DWORD, val2: DWORD, val3: PTR SDWORD               ;edx=OFFSET input, ecx=size of input string, edi=OFFSET output, ebx=number of signed integer extracted from input string
  
   mov edx, val1                                                             ;edx = val1 = ADDR input
   mov ecx, val2                                                             ;ecx = val2 = inputN(L1 loop�� inputN�� ���ƾ� �ϱ� ������) 
   mov edi, val3                                                             ;edi = val3 = ADDR output, �Լ��� ������ ������ ����.
   mov ebx, 0                                                                ;ebx = ���ڿ����� ������ ������ ����, makeArray �Լ��� ���� ��, ecx�� �����Ͽ� ��ȯ��. 

   mov eax, 0                                                                ;eax�� ' '(space)�� �ƴ� ���ڿ��� ũ�⸦ �ǹ���. 

   L1: 
      cmp BYTE PTR [edx], 32                                                 
      je L3
      cmp eax, 0
      jne L2
      mov esi, edx                                                           ;' '�� �ƴ� ���ڿ��� ó������ ���۵Ǵ� ���� �ּҸ� esi�� ������. 
      L2:   
         inc edx                                               
         inc eax                                                             ;���ڿ����� ' '�� �ƴ� ���ڰ� ���� ���, �� ������ eax�� ������. 
         cmp ecx, 1               
         je L4                                                               ;���ڿ��� �� �������� ��쿡�� ������ ���ڰ� ' '�� �ƴϾ �ش� ���ڸ� ���̶�� �����ϰ� ������ ã�Ƽ� �迭�� �����ؾ� ��. 
         jmp L5
      L3:                      
         inc edx 
         cmp eax, 0                                                          ;[edx]�� ' '�̰� eax�� 0�̸� ������ ' '�� �ƴ� ���ڰ� ���� ���� ���̹Ƿ� ' '�� �ƴ� ���ڸ� ã�� ������ loop�� �ݺ���.             
         je L5
      L4:
         push edx
         push ecx
         mov edx, esi                                                        ;���ڿ����� ' '�� �ƴ� ���ڰ� ó�� �����ϴ� �ּҸ� edx�� ������. 
         mov ecx, eax                                                        ;���ڿ����� ' '�� �ƴ� ���ڰ� ���޾� ������ Ƚ���� ecx�� ������. 
         call ParseInteger32                                                 ;edx�� ecx�� ��Ÿ���� �ش� ���ڿ��� signed integer�� �ٲ㼭 eax�� ��ȯ����.  
         mov [edi+ebx*4], eax                                                ;base register(edi)�� index register(ebx)�� �̿��Ͽ� signed integer�� output �迭�� ������. 
         add ebx, 1
         mov eax, 0                                                          ;eax�� �ٽ� 0���� ��������. 
         pop ecx
         pop edx
      L5:
         loop L1 

   mov ecx, ebx                                                              ;���ڿ����� ������ ������ ������ ecx�� �����Ͽ� ��ȯ��.
     ret 
makeArray ENDP

END main