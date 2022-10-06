TITLE Redirection

; Program Description:                �Է� �����̳� standard input���� ���� ���ڿ��� �� ���ڸ� k���� �ݺ��Ͽ� ��� �����̳� standard output���� �����.
; Author(Student ID):                 nahyun kim(20191286)
; Creation Date:                      2021-06-05
; Input:                              �Է� ���ϸ� �Ǵ� ��� ���ϸ�, �ƹ��� �Է��� ���� �� stdin�� stdout���� ���ڿ��� �Է� �ް� �����.  
; Output:                             ���ڿ��� ��� ���ڰ� k���� �ݺ��� ���ڿ��� stdout�̳� ��� ���Ͽ� �����. 
; Modification Date:                  2021-06-06

INCLUDE Irvine32.inc

.data
   stdin_SIZE EQU 50
   stringStdin BYTE stdin_SIZE+1 DUP (?)
   inputfile BYTE 10 DUP (?)
   outputfile BYTE 10 DUP (?)
   inputhandle HANDLE ?
   outputhandle HANDLE ?

   BUF_SIZE EQU 20
   inBuf BYTE BUF_SIZE DUP(?)
   bytesRead DWORD ?
   outBuf BYTE 9 DUP(?)
   bytesWrite DWORD ?

   CR EQU 13
   LF EQU 10
   single_Buf__ BYTE ?
   byte_Read__ DWORD ? 

.code
main PROC
      
      mov edx, OFFSET stringStdin
      mov ecx, stdin_SIZE
      call ReadString                                ;input ���ϰ� output ���ϸ� ���� ������ ��� stringStdin�� ������. ���ڿ��� ũ��, �� ������ ������ eax�� �־� ��ȯ��.
 
      cmp eax, 0                                     ;eax = 0�̸� ���Ͽ� ���� ������ ���ٴ� ���̹Ƿ� stdin, stdout�� �����. 
      je Noinput

      mov edx, OFFSET stringStdin                    ;edx = OFFSET stringStdin 
      mov ecx, eax                                   ;ecx = eax, ���ڿ��� ������ŭ loop�� �ݺ��ϸ� �Է�, ��� ���ϸ��� ���� ������. 

      check:     
            mov bl, BYTE PTR [edx]
            cmp bl, '<'
            je input                                 ;'<'�� ������ input ���ϸ��� �����ϱ� ���� point�� �̵���. 
            inc edx
            dec ecx
            jmp check

            input:
                  add edx, 2                         ;'<'�� ' '�� �����ϱ� ����. 
                  sub ecx, 2                         ;����������, '<'�� ' '�� �����ϱ� ����. 
                  mov eax, OFFSET inputfile          ;input ���ϸ��� inputfile�� �ֱ� ���� eax = OFFSET [inputfile] 
                  L1: 
                      mov bl, BYTE PTR [edx]        
                      cmp bl, ' '                    ;stringStdin ���ڿ��� ' '�� ������ output ���ϸ� ���� �Է��� ���̹Ƿ� output ���ϸ��� �����ϱ� ���� point�� �̵���.  
                      je output                     
                      mov [eax], bl                  ;[eax] = bl
                      inc eax 
                      inc edx
                      loop L1
                  xor ebx, ebx 
                  mov [eax], ebx                     ;inputfile �������� 0�� �־� ���ڿ��� ������ ǥ����. 
                  jmp existsonlyinputfile

           output: 
                  sub ecx, 3                         ;'>'�� ' '�� �����ϱ� ����. 
                  add edx, 3                         ;����������, '>'�� ' '�� �����ϱ� ����. 
                  mov eax, OFFSET outputfile         ;output ���ϸ��� outputfile�� �ֱ� ���� eax = OFFSET [outputfile] 
                  L2:
                      mov bl, BYTE PTR [edx]
                      mov [eax], bl                  ;[eax] = bl
                      inc eax
                      inc edx
                      loop L2
                  xor ebx, ebx 
                  mov [eax], ebx                     ;outputfile �������� 0�� �־� ���ڿ��� ������ ǥ����. 
                  jmp existsbothfiles

        
      existsonlyinputfile: 

                          mov edx, OFFSET inputfile
                          call OpenInputFile
                          mov inputhandle, eax                   ;eax = inputhandle 
                         
                          L3:
                             mov edx, OFFSET inBuf               ;edx = OFFSET inBuf
                             call Read_a_Line         
                             cmp ecx, 0                          
                             je finish

                             mov edx, OFFSET inBuf               ;edx = OFFSET inBuf
                             mov edx, OFFSET inBuf
                             add eax, ecx                        ;eax = eax + ecx + 2
                             add eax, 2 
                             push eax                          
                             movsx eax, BYTE PTR [edx]           ;eax = BYTE PTR [edx] = k + 30h 
                             sub eax, 30h                        ;eax = k

                             add edx, 2                          ;edx = edx(OFFSET inBuf) + 2
                             sub ecx, 2                          ;ecx = ecx - 2
                             L4: 
                                push ecx
                                mov ecx, eax                     ;ecx = eax = k
                                mov al, [edx]                    ;al = [edx]
                                L5:
                                   call WriteChar                ;[edx]�� k�� stdout�� �����. 
                                   loop L5
                                inc edx                          ;edx = edx + 1
                                pop ecx          
                                loop L4
                             call Crlf                           ;�� �� ����� ������ new line�� �����. 
                             pop eax
                             jmp L3                              ;Read_a_Line �Լ��� ȣ���� ��, ecx�� 0�� �� ������ L3 loop�� �ݺ���. 

          existsbothfiles: 
           
                          mov edx, OFFSET outputfile
                          call OpenInputFile
                          mov outputhandle, eax                

                          mov edx, OFFSET inputfile
                          call OpenInputFile
                          mov inputhandle, eax

                          L6: 
                             mov edx, OFFSET inBuf
                             call Read_a_Line
                             mov esi, OFFSET outBuf              ;esi = OFFSET outBuf
                             cmp ecx, 0
                             je finish 

                             mov edx, OFFSET inBuf
                             add eax, ecx                        ;eax = ecx + 2
                             add eax, 2
                             push eax
                             movsx eax, BYTE PTR [edx]           ;eax = BYTE PTR [edx] = k + 30h
                             sub eax, 30h                        ;eax = k
                             jc finish                           ;k�� ' '�� �� ���α׷��� ����.

                             add edx, 2                          ;edx = edx(OFFSET inBuf) + 2
                             sub ecx, 2                          ;ecx = ecx - 2
                             L7: 
                                push ecx
                                mov ecx, eax
                                mov al, [edx]
                                mov [esi], al
                                inc esi
                                mov eax, eax
                                mov [esi], eax
                                L8: 
                                   INVOKE WriteFile, outputhandle, ADDR outBuf, 1, ADDR bytesWrite, 0
                                   add outputhandle, 1
                                   loop L8
                                inc edx
                                pop ecx
                                loop L7
                                mov esi, OFFSET outBuf
                                mov al, CR
                                mov [esi], al
                                inc esi
                                mov al, LF
                                mov [esi], al
                                inc esi
                                xor al, al
                                mov [esi], al
                              
                                INVOKE WriteFile, outputhandle, ADDR outBuf, 3, ADDR bytesWrite, 0
                                mov eax, bytesWrite
                                add outputhandle, eax
                              pop eax
                              jmp L6
         
    
      Noinput: 
              L9:
                  INVOKE GetStdHandle, STD_INPUT_HANDLE
                  mov inputHandle, eax
                  mov edx, OFFSET inBuf
                  call Read_a_Line
                  cmp ecx, 0
                  je finish 
                  sub ecx, 2
                  mov edx, OFFSET inBuf
                  movsx ebx, BYTE PTR [edx] 
                  sub ebx, 30h
                  add edx, 2
                  L10:
                     push ecx
                     mov ecx, ebx
                     mov al, [edx]
                     L11: 
                        call WriteChar
                        loop L11
                     inc edx  
                     pop ecx
                     loop L10 
                  call Crlf
                  jmp L9 

      finish: 
             INVOKE ExitProcess, 0
main ENDP

Read_a_Line PROC
 ; Input:    EAX = inputFile Handle (inputhandle or stdinHandle) 
 ;           EDX = Buffer offset to store the string (OFFSET inBuf) 
 ; Outpuf:   ECX = number of characters read (0 if none)
 ; Function: Read a line from a ~.txt file until CR, LF.
 ;           CR, LF are ignored and 0 is appended at the end.
 ;           ECX only counts valid characters just before CR.


    xor ecx, ecx                                                                     ;reset counter
    Read_Loop:                                                                       
              push eax
              push ecx
              push edx

              INVOKE ReadFile, eax, ADDR single_Buf__ , 1, ADDR byte_Read__ , 0      ;read a single character

              pop edx
              pop ecx
              pop eax

              cmp DWORD PTR byte_Read__, 0                                           ;check the number of characters read
              je Read_END 

              mov bl, single_Buf__
              cmp bl, CR
              je Read_Loop
              cmp bl, LF
              je Read_End

              mov [edx], bl                                                           ;move the character to input buffer
              inc edx
              inc ecx             
              jmp Read_Loop                                                           ;go to start to read the next line
 
    Read_End:
              mov BYTE PTR [edx], 0                                                   ;append 0 at the end
              ret
Read_a_Line ENDP

END main