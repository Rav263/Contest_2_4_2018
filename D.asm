%include 'io.inc'

section .rodata
  input db "%d", 0
  output db "%d", 0
  endl db 10, 0

CEXTERN malloc
CEXTERN scanf
CEXTERN printf
CEXTERN clear


section .bss
  arr resd 1
  n resd 1
  armat resd 1
  tr resd 1
  m resd 1
  a resd 1
  mat resd 1

section .text
global CMAIN
CMAIN:
  push ebp
  mov ebp, esp

  and esp, -16
  sub esp, 16

  mov dword[esp], input
  mov dword[esp + 4], n
  call scanf

  mov eax, dword[n]
  imul eax, 4
  mov dword[esp], eax
  call malloc

  mov dword[arr], eax

  mov eax, dword[n]
  imul eax, 4
  mov dword[esp], eax
  call malloc

  mov dword[armat], eax

  mov eax, dword[n]
  imul eax, 8
  mov dword[esp], eax
  call malloc

  mov dword[tr], eax

  mov esi, 0

  .top1:
    mov dword[esp], input
    mov dword[esp + 4], m
    call scanf

    mov edi, dword[m]
    imul dword[m]
    mov eax, edi
    imul eax, 4
    mov dword[esp], eax
    call malloc

    mov dword[mat], eax

    mov ebx, 0

    .top2:
      mov dword[esp], input
      mov dword[esp + 4], a
      call scanf

      mov eax, dword[a]
      mov dword[mat + ebx * 4], eax
      ;вот тут, пидр, ты должен написать вычисление следа
      inc ebx
      cmp ebx, edi
    jnz .top2

    mov dword[armat + esi * 4], mat

    inc esi

    cmp esi, dword[n]
  jnz .top1

  ;А вот тут ты должен написать поиск максимума
  ;А вот тут вывод максимальной матрицы

  mov eax, 0
  leave
ret

