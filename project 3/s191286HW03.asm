TITLE CAESAR CIPHER

; Program Description:                By using Caesar Cipher method, decipher ciphered texts whose number is Num_Str and write them on 0s191286_out.txt file.
; Author(Student ID):                 nahyun kim(20191286)
; Creation Date:                      2021-05-08
; Input:                              Num_Str(number of the cipher texts), Cipher_Str(ciphered texts), List1 and List2
; Output:                             0s191286_out.txt file written on deciphered texts 
; Modification Date:                  2021-05-09

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW03.inc

.data
List1       BYTE   'Q','R','S','T','U','V','W','X','Y','Z'
List2       BYTE   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P'      ;we are going to use OFFSET List2
filename    BYTE   "0s191286_out.txt", 0
buffer      BYTE  1 DUP(?)
newline     BYTE  13, 10
filehandle  DWORD  ?

.code
main PROC
    mov   edx, OFFSET filename
    call CreateOutputFile
    mov   filehandle,eax

    mov   ecx, Num_Str                      ;For repeating L1 loop Num_Str times
    mov   esi, 0                            ;esi means Cipher_Str's index

    L1: 
       push  ecx                          
       mov   ecx, 10                        ;For repeating L2 loop 10 times

       L2:
          mov   edx, OFFSET buffer

          push  eax
          sub   Cipher_Str[esi], 65         ;'A'->0, 'B'->1,...
          movsx eax, Cipher_Str[esi]        ;If Cipher_Str[esi]='A', eax=0 
          sub   eax, 10                     ;h+k (In this case, k=-10)  If Cipher_Str[esi]='A', then eax=-10
          movsx eax, List2[eax]             ;If Cipher_Str[esi]='A', then eax=List2[-10]=List1[0]='Q'
          mov   BYTE PTR [edx], al          ;buffer[0]=eax
          pop   eax

          push  ecx
          mov   ecx, TYPE buffer 
          call  WriteToFile                 ;print buffer[0] on the file
          add   eax, filehandle
          pop   ecx

          inc esi                           ;To increase Cipher_Str index 
          loop  L2
       
       mov   edx, OFFSET newline            ;print new line on the file
       mov   ecx, 2
       call  WriteToFile
       add   eax, filehandle  

       inc esi                              ;To ignore EOS in Cipher texts(Due to Cipher_Str[10]=Cipher_Str[21]=...=EOS)
       pop   ecx
       loop  L1                          

    mov   filehandle, eax
    call CloseFile

    exit
main ENDP
END main