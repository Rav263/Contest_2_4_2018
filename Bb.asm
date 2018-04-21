%include 'io.inc'


section .rodata
  input db "%d", 0
  output db "%d", 10, 0
  file db "data.in", 0
  read db "r", 0


section .bss
  a resd 1
  inp resd 1
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

  push ebx
  push edi
  push esi
  sub esp, 4


  mov dword[esp], file
  mov dword[esp + 4], read
  call fopen
  mov dword[inp], eax
  
  mov edi, 0

  .top:
    mov edx, dword[inp]
    mov dword[esp], edx
    mov dword[esp + 4], input
    mov dword[esp + 8], a
    call fscanf
    inc edi

    cmp eax, 0
  jg .top

  mov edx, dword[inp]
  mov dword[esp], edx
  call fclose


  dec edi
  mov dword[esp], output
  mov dword[esp + 4], edi

  call printf

  add esp, 4
  pop esi
  pop edi
  pop ebx

  mov eax, 0

  mov esp, ebp
  pop ebp
ret
