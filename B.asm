%include 'io.inc'


section .rodata
  input db "%d", 0
  output db "%d", 10, 0
  file db "data.in", 0
  read db "r", 0


section .bss
  a resd 1

CEXTERN fopen
CEXTERN fclose
CEXTERN fscanf
CEXTERN printf


section .text
global CMAIN
CMAIN:
  push ebp
  mov ebp, esp

  and esp, -16
  sub esp, 16

  mov dword[esp], file
  mov dword[esp + 4], read
  call fopen

  ;; PRINT_HEX 4, eax
  mov edx, eax

  mov ecx, 0

  .top1:
    mov dword[esp], edx
    mov dword[esp + 4], input
    mov dword[esp + 8], a
    call fscanf

    inc ecx
    PRINT_DEC 4, ecx

    cmp eax, 0
    jnz .top1

  dec ecx
  mov dword[esp], edx
  call fclose

  mov dword[esp], output
  mov dword[esp + 4], ecx
  call printf

  mov eax, 0

  mov esp, ebp
  pop ebp
ret
