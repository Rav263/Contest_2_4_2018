%include 'io.inc'


section .rodata
  input db "%1000s %1000s", 0
  output1 db "1 2", 10, 0
  output2 db "2 1", 10, 0
  output3 db "0", 10, 0



section .bss
  a resd 1002
  b resd 1002


section .text
global CMAIN

CEXTERN fgets
CEXTERN get_stdin
CEXTERN printf
CEXTERN strstr


CMAIN:
  push ebp
  mov ebp, esp

  and esp, -16
  sub esp, 16

  call get_stdin
  mov edx, eax


  mov dword[esp], a
  mov dword[esp + 4], 1001
  mov dword[esp + 8], edx
  call fgets

  PRINT_HEX 4, eax

  mov dword[esp], b
  mov dword[esp + 4], 1001
  mov dword[esp + 8], edx
  call fgets

  PRINT_STRING a
  NEWLINE
  PRINT_STRING b
  NEWLINE

  mov dword[esp], a
  mov dword[esp + 4], b

  call strstr

  mov ecx, eax

  mov dword[esp], b
  mov dword[esp + 4], a
 
  call strstr

  cmp eax, 0
  jz .a
    mov dword[esp], output1
    call printf
  jmp .end
  
  .a:
  cmp ecx, 0
  jz .b
    mov dword[esp], output2
    call printf
  jmp .end

  .b:
    mov dword[esp], output3
    call printf
  .end:

  mov esp, ebp
  pop ebp
  mov eax, 0
ret
