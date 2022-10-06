TITLE Redirection

; Program Description:                입력 파일이나 standard input에서 얻은 문자열을 각 문자를 k번씩 반복하여 출력 파일이나 standard output으로 출력함.
; Author(Student ID):                 nahyun kim(20191286)
; Creation Date:                      2021-06-05
; Input:                              입력 파일명 또는 출력 파일명, 아무런 입력이 없을 시 stdin과 stdout에서 문자열을 입력 받고 출력함.  
; Output:                             문자열의 모든 문자가 k번씩 반복된 문자열을 stdout이나 출력 파일에 출력함. 
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
      call ReadString                                ;input 파일과 output 파일명에 대한 정보를 얻어 stringStdin에 저장함. 문자열의 크기, 즉 문자의 개수를 eax에 넣어 반환함.
 
      cmp eax, 0                                     ;eax = 0이면 파일에 대한 정보가 없다는 뜻이므로 stdin, stdout을 사용함. 
      je Noinput

      mov edx, OFFSET stringStdin                    ;edx = OFFSET stringStdin 
      mov ecx, eax                                   ;ecx = eax, 문자열의 개수만큼 loop를 반복하며 입력, 출력 파일명을 각각 저장함. 

      check:     
            mov bl, BYTE PTR [edx]
            cmp bl, '<'
            je input                                 ;'<'을 만나면 input 파일명을 저장하기 위한 point로 이동함. 
            inc edx
            dec ecx
            jmp check

            input:
                  add edx, 2                         ;'<'와 ' '을 무시하기 위함. 
                  sub ecx, 2                         ;마찬가지로, '<'와 ' '을 무시하기 위함. 
                  mov eax, OFFSET inputfile          ;input 파일명을 inputfile에 넣기 위해 eax = OFFSET [inputfile] 
                  L1: 
                      mov bl, BYTE PTR [edx]        
                      cmp bl, ' '                    ;stringStdin 문자열에 ' '가 있으면 output 파일명 또한 입력한 것이므로 output 파일명을 저장하기 위한 point로 이동함.  
                      je output                     
                      mov [eax], bl                  ;[eax] = bl
                      inc eax 
                      inc edx
                      loop L1
                  xor ebx, ebx 
                  mov [eax], ebx                     ;inputfile 마지막에 0을 넣어 문자열이 끝남을 표시함. 
                  jmp existsonlyinputfile

           output: 
                  sub ecx, 3                         ;'>'과 ' '을 무시하기 위함. 
                  add edx, 3                         ;마찬가지로, '>'과 ' '을 무시하기 위함. 
                  mov eax, OFFSET outputfile         ;output 파일명을 outputfile에 넣기 위해 eax = OFFSET [outputfile] 
                  L2:
                      mov bl, BYTE PTR [edx]
                      mov [eax], bl                  ;[eax] = bl
                      inc eax
                      inc edx
                      loop L2
                  xor ebx, ebx 
                  mov [eax], ebx                     ;outputfile 마지막에 0을 넣어 문자열이 끝남을 표시함. 
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
                                   call WriteChar                ;[edx]을 k번 stdout에 출력함. 
                                   loop L5
                                inc edx                          ;edx = edx + 1
                                pop ecx          
                                loop L4
                             call Crlf                           ;한 줄 출력이 끝나면 new line을 출력함. 
                             pop eax
                             jmp L3                              ;Read_a_Line 함수를 호출한 후, ecx가 0이 될 때까지 L3 loop를 반복함. 

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
                             jc finish                           ;k가 ' '일 때 프로그램을 끝냄.

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