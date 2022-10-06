TITLE ListSum

; Program Description:                문자열을 입력 받아 정수 값들을 추출하여 하나씩 배열에 저장하고 이들을 더한 값을 출력한다.  
; Author(Student ID):                 nahyun kim(20191286)
; Creation Date:                      2021-05-27
; Input:                              정수가 적힌 문자열(input)을 입력 받아 배열 output에 저장한다. 
; Output:                             문자열에 있는 정수만을 뽑아 새로운 배열에 저장하고, 정수의 합을 출력한다.  
; Modification Date:                  2021-05-30

INCLUDE Irvine32.inc
 
makeArray PROTO val1: PTR DWORD, val2: DWORD, val3: PTR SDWORD               ;INVOKE directive를 사용하여 호출할 것이기 때문에 prototype을 선언해야 함. 

.data
BUF_SIZE EQU 255                                                             ;null character을 제외하고 입력 받을 문자의 최대 개수 
input BYTE 256 DUP(?)                                                        ;입력 받은 문자열을 저장하기 위한 공간
inputN DWORD ?                                                               ;null character을 제외하고 입력 받은 문자의 개수 
output SDWORD 125 DUP(?)                                                     ;입력 받은 문자열에서 signed integer을 추출하여 저장하기 위한 공간 
enternumbers BYTE "Enter numbers(<ent> to exit): ", 0
bye BYTE "Bye!", 0

.code
main PROC
    startpoint: 
          mov edx, OFFSET enternumbers                                       ;prompt에 문구를 출력함.
          call WriteString
          call Crlf                                                          ;prompt에 new line을 출력함. 

          mov edx, OFFSET input
          mov ecx, BUF_Size 
          call ReadString                                                    ;입력 받은 문자열을 input에 저장하고, null character을 제외한 문자열의 길이(size of input string)를 eax에 대입하여 반환함. 
          cmp eax, 0                          
          je endpoint                                                        ;아무것도 입력하지 않고 enter key를 누른 경우, 프로그램을 종료함. 
          
          mov inputN, eax                                                    ;inputN에 eax을 대입함. 
          mov ecx, eax                                                       ;L1 loop를 돌기 위해 ecx에 eax를 대입함. 

          L1:                                                                ;edx = OFFSET input
               cmp BYTE PTR [edx], 32                                        ;' '(space)의 ASCII code는 32임.    
               jne L1Out                                                     ;L1 loop를 돌면서 ' '가 아닌 다른 문자가 하나라도 있을 경우, L1Out으로 이동함. 
               inc edx
               loop L1
          jmp startpoint                                                     ;빈칸만을 입력하고 enter을 누른 경우, startpoint로 돌아가 문자열을 다시 입력 받음.  

          L1Out:
               INVOKE makeArray, ADDR input, inputN, ADDR output             ;input string의 OFFSET, input string의 크기, output 배열의 OFFSET 입력함.             

          mov eax, 0
          L2:                                                                ;배열 output에 들어있는 정수의 합을 구하기 위한 loop, ecx는 문자열에서 추출한 sigend integer의 개수
             add eax, SDWORD PTR [edi]
             mov DWORD PTR [edi], 0
             add edi, 4
             loop L2
         
         cmp eax, 0
         jge L3
         call WriteInt                                                       ;eax가 음수면 singed number을 출력함(부호를 출력함). 
         call Crlf                                                           ;prompt에 new line을 출력함. 
         jmp startpoint

         L3:  
            call WriteDec                                                    ;eax가 양수나 0이면 unsigned number을 출력함(부호는 출력하지 않음). 
            call Crlf                                                        ;prompt에 new line을 출력함. 
            jmp startpoint

    endpoint: 
          mov edx, OFFSET bye
          call WriteString                                                   ;Bye!를 출력하고 프로그램을 종료함. 
          exit
main ENDP

makeArray PROC val1: PTR DWORD, val2: DWORD, val3: PTR SDWORD               ;edx=OFFSET input, ecx=size of input string, edi=OFFSET output, ebx=number of signed integer extracted from input string
  
   mov edx, val1                                                             ;edx = val1 = ADDR input
   mov ecx, val2                                                             ;ecx = val2 = inputN(L1 loop를 inputN번 돌아야 하기 때문에) 
   mov edi, val3                                                             ;edi = val3 = ADDR output, 함수가 끝나도 변하지 않음.
   mov ebx, 0                                                                ;ebx = 문자열에서 추출한 정수의 개수, makeArray 함수가 끝날 때, ecx에 대입하여 반환함. 

   mov eax, 0                                                                ;eax는 ' '(space)가 아닌 문자열의 크기를 의미함. 

   L1: 
      cmp BYTE PTR [edx], 32                                                 
      je L3
      cmp eax, 0
      jne L2
      mov esi, edx                                                           ;' '가 아닌 문자열이 처음으로 시작되는 시작 주소를 esi에 저장함. 
      L2:   
         inc edx                                               
         inc eax                                                             ;문자열에서 ' '이 아닌 문자가 나올 경우, 그 개수를 eax에 저장함. 
         cmp ecx, 1               
         je L4                                                               ;문자열의 맨 마지막인 경우에는 마지막 문자가 ' '이 아니어도 해당 문자를 끝이라고 가정하고 정수를 찾아서 배열에 저장해야 함. 
         jmp L5
      L3:                      
         inc edx 
         cmp eax, 0                                                          ;[edx]가 ' '이고 eax가 0이면 이전에 ' '이 아닌 문자가 오지 않은 것이므로 ' '이 아닌 문자를 찾을 때까지 loop를 반복함.             
         je L5
      L4:
         push edx
         push ecx
         mov edx, esi                                                        ;문자열에서 ' '이 아닌 문자가 처음 시작하는 주소를 edx에 저장함. 
         mov ecx, eax                                                        ;문자열에서 ' '이 아닌 문자가 연달아 나오는 횟수를 ecx에 저장함. 
         call ParseInteger32                                                 ;edx와 ecx가 나타내는 해당 문자열을 signed integer로 바꿔서 eax로 반환해줌.  
         mov [edi+ebx*4], eax                                                ;base register(edi)와 index register(ebx)를 이용하여 signed integer을 output 배열에 저장함. 
         add ebx, 1
         mov eax, 0                                                          ;eax를 다시 0으로 세팅해줌. 
         pop ecx
         pop edx
      L5:
         loop L1 

   mov ecx, ebx                                                              ;문자열에서 추출한 정수의 개수를 ecx에 대입하여 반환함.
     ret 
makeArray ENDP

END main