%include 'io.inc'

section .rodata
  input1 db "%11s", 0
  input2 db "%d", 0
  output db "%d", 10, 0

section .bss
  arr resb 5500
  a resd 1
  b resd 1
  sum resd 1

CEXTERN scanf
CEXTERN printf
CEXTERN strcmp


section .text
global CMAIN
CMAIN:
  push ebp
  mov ebp, esp
  
  and esp, -16
  sub esp, 16

  mov dword[esp], input2
  mov dword[esp + 4], a
  call scanf

  cmp dword[a], 0
  jz .end
  
  .s:
  mov ebx, 0

  .top1:
    mov dword[esp], input1
    mov eax, ebx
    imul eax, 11
    add eax, arr 
    mov dword[esp + 4], eax
    call scanf

    inc ebx
    cmp ebx, dword[a]
  jnz .top1

  mov dword[sum], 0

  mov ebx, 0
  .top2:
    mov edi, ebx
    inc edi
    
    cmp edi, dword[a]
    jz .end
    
    mov esi, ebx
    imul esi, 11
    add esi, arr

    .top3:
      mov eax, edi
      imul eax, 11
      add eax, arr

      mov dword[esp], eax
      mov dword[esp + 4], esi
      call strcmp

      cmp eax, 0
      jz .end2
      inc edi

      cmp edi, dword[a]
    jnz .top3
    
    inc dword[sum]
    
    .end2:
    
    inc ebx
    cmp ebx, dword[a] 
  jnz .top2
 
  .end:

  mov eax, dword[sum]

  inc eax

  mov dword[esp], output
  mov dword[esp + 4], eax
  call printf

  mov esp, ebp
  pop ebp

  mov eax, 0
ret
