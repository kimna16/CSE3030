TITLE Calculate Equation by substituting variables

; Program Description:                calculate equation 90(x1)-30(x2)+19(x3) and return result of the equation
; Author(Student ID):                 nahyun kim(20191286)
; Creation Date:                      2021-04-18
; Input:                              values substituting variables x1, x2, x3
; Output:                             result of the solved equation which is stored in EAX 
; Modification Date:                  2021-04-25

INCLUDE Irvine32.inc
INCLUDE CSE3030_PHW02.inc

.code
main PROC
  mov  eax,  x1                        ; eax <- x1
  add  eax,  eax                       ; eax <- 2(x1)
  add  eax,  x1                        ; eax <- 3(x1)
  sub  eax,  x2                        ; eax <- 3(x1)-(x2)
  add  eax,  eax                       ; eax <- 6(x1)-2(x2)
  mov  ebx,  eax                       ; ebx <- 6(x1)-2(x2)
  add  eax,  eax                       ; eax <- 12(x1)-4(x2)
  add  eax,  eax                       ; eax <- 24(x1)-8(x2)
  add  eax,  eax                       ; eax <- 48(x1)-16(x2)
  add  eax,  eax                       ; eax <- 96(x1)-32(x2)
  sub  ebx,  eax                       ; ebx <- -90(x1)+30(x2)

  mov  eax,  x3                        ; eax <- x3
  sub  ebx,  eax                       ; ebx <- ebx - eax = {-90(x1)+30(x2)} - (x3) = -90(x1)+30(x2)-(x3)
  add  eax,  eax                       ; eax <- 2(x3)
  sub  ebx,  eax                       ; ebx <- ebx - eax = {-90(x1)+30(x2)-(x3)} - 2(x3) = -90(x1)+30(x2)-3(x3)
  add  eax,  eax                       ; eax <- 4(x3)
  add  eax,  eax                       ; eax <- 8(x3)
  add  eax,  eax                       ; eax <- 16(x3)
  sub  eax,  ebx                       ; eax <- eax - ebx = 16(x3) - {-90(x1)+30(x2)-3(x3)} = 90(x1)-30(x2)+19(x3)

  call WriteInt                        ; call EAX argument
    exit
main ENDP
END main