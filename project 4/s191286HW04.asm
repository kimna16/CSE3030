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
   mov ecx, TN                          ;L1 loop를 TN번 돌아야 하기 때문에 ecx에 TN을 저장함. 
   cmp ecx, 0
   je L9
   mov esi, OFFSET HEIGHT               ;Indirect operands를 사용하기 위해 esi에 HEIGHT의 OFFSET을 저장함.
   L1:
      cmp ecx, TN                       ;ecx와 TN을 비교하여 ecx가 TN과 같으면, 즉 L1 loop를 처음 도는 상황이면 L2로 점프함. 
      push ecx                          ;L1 loop를 TN번 돌고 L1 안에서 다른 loop를 돌기 위해 ecx를 stack에 push함.  
      je L2                             ;ecx = TN이면 L2로 점프함. 
      mov ecx, DWORD PTR [esi]          ;ecx가 TN과 같지 않으면, [esi]를 ecx에 저장함. 
      add esi, 4                        ;DWORD를 사용하고 있으므로 esi에 4씩 더해줌.  
      jmp L3

      L2:                               ;ecx = TN이면 ecx에 CASE를 저장함. 
        mov ecx, CASE
        
      L3:                               ;초기화 과정
        mov edx, 0                      ;edx = 0, edx는 고도의 차이를 구할 때 사용할 register임. 
        mov eax, DWORD PTR [esi]        ;eax = DWORD PTR [esi]
        add esi, 4                       
        cmp ecx, 1                      
        je L8                           ;ecx가 1이면 고도가 하나뿐이므로 loop를 돌 필요 없이 0을 출력하면 됨. 
        dec ecx                         ;첫 번째 고도는 eax에 저장하였으므로 L4 loop를 (ecx - 1)번 돌면서 고도를 확인하면 됨. 
        mov ebx, eax                    ;ebx = eax

      L4:
         push ecx                       ;ecx에 다른 값을 저장하여 사용하기 위해 stack에 push함. 
         mov ecx, DWORD PTR [esi]
         add esi, 4
         cmp ebx, ecx                   
         jae  L5                        ;ebx >= ecx이면, 즉 더 이상 오르막길이 아닌 경우, L5로 점프함. 
         jmp L6                    

         L5:                            ;ebx >= ecx이면 
            sub ebx, eax                ;ebx = ebx - eax, 즉 고도의 차이를 저장함. 
            mov eax, ecx                ;eax = ecx
            cmp edx, ebx                
            jae L6                      ;edx >= ebx이면 L6로 점프함. 
            mov edx, ebx                ;edx < ebx이면 edx에 ebx를 저장함.            

         L6:                            
           mov ebx, ecx                 ;ebx = ecx  
           pop ecx
           cmp ecx, 1                   
           jne L7                       ;ecx가 1이 아니면 L7로 점프함. 
           cmp eax, ebx                
           je L7                        ;eax와 ebx가 같으면 이미 위(L5)에서 고려한 것임. 
           sub ebx, eax                 ;eax와 ebx가 같지 않으면 두 값을 빼서 마지막 오르막길의 가장 높은 고도인 list의 맨 마지막 height에 대해서도 고려해줘야 함. 
           cmp edx, ebx                
           jae L7                       ;edx >= ebx이면 L7로 점프함. 
           mov edx, ebx                 ;edx < ebx이면 edx에 ebx를 저장하여 가장 큰 고도 차이를 저장해야 함. 

         L7:
           loop L4
     
      L8:   
        mov eax, edx
        call WriteDec                   ;eax를 출력함. 
        call Crlf                       ;new line을 출력함. 
        pop ecx                         ;L1 loop을 다시 돌 것인지 확인하기 위해 stack에 넣어놨던 ecx을 pop함. 
      loop L1

   L9:
    exit
main ENDP
END main