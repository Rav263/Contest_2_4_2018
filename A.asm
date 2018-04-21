%include 'io.inc'


section .rodata
  input db "%1000s %1000s", 0
  output1 db "1 2", 10, 0
  output2 db "2 1", 10, 0
  output3 db "0", 10, 0



section .bss
  a resd 1010
  b resd 1010
  inp resd 1

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

  push ebx
  push edi
  push esi
  sub esp, 4

  call get_stdin
  mov dword[inp], eax


  mov edx, dword[inp]
  mov dword[esp], a
  mov dword[esp + 4], 1010
  mov dword[esp + 8], edx
  call fgets



  mov edx, dword[inp]
  mov dword[esp], b
  mov dword[esp + 4], 1010
  mov dword[esp + 8], edx
  call fgets

  mov ecx, 0

  .top1:
    inc ecx
    cmp byte[a + ecx], 0
  jnz .top1

  mov byte[a + ecx - 1], 0

  mov ecx, 0

  .top2:
    inc ecx
    cmp byte[b + ecx], 0
  jnz .top2

  mov byte[b + ecx - 1], 0

  mov dword[esp], a
  mov dword[esp + 4], b

  call strstr

  mov edi, eax

  mov dword[esp], b
  mov dword[esp + 4], a
 
  call strstr

  cmp eax, 0
  jz .a
    mov dword[esp], output1
    call printf
  jmp .end
  
  .a:
  cmp edi, 0
  jz .b
    mov dword[esp], output2
    call printf
  jmp .end

  .b:
    mov dword[esp], output3
    call printf
  .end:

  add esp, 4
  pop esi
  pop edi
  pop ebx

  mov esp, ebp
  pop ebp
  mov eax, 0
ret
