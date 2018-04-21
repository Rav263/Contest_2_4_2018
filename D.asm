%include 'io.inc'

section .rodata
  input db "%d", 0
  output db "%d ", 0
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
  now_tr resq 1

section .text
global CMAIN
CMAIN:
  ;стандартная инициализация ------
  push ebp
  mov ebp, esp

  and esp, -16
  sub esp, 16

  ;считывание количества матриц и инициализация памяти 

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

  ;считывание оставшихся матриц
  mov esi, 0

  .top1:
    mov dword[esp], input
    mov dword[esp + 4], m
    call scanf
   
    mov eax, dword[arr]
    mov ecx, dword[m]
    mov dword[eax + esi * 4], ecx

    mov edi, dword[m]
    imul edi, dword[m]
    mov eax, edi
    imul eax, 4
    mov dword[esp], eax
    call malloc

    mov dword[mat], eax

    mov ebx, 0

    mov dword[now_tr], 0
    mov dword[now_tr + 4], 0
    
    .top2:
      mov dword[esp], input
      mov dword[esp + 4], a
      call scanf

      mov eax, dword[a]
      mov ecx, dword[mat]
      mov dword[ecx + ebx * 4], eax
      
      mov ecx, eax

      ;вычисление следа считываемой матрицы

      mov eax, ebx
      mov edx, 0
      div dword[m]

      cmp edx, eax
      jnz .con
      
      cmp ecx, 0
      jl .t2a
      
      add dword[now_tr], ecx
      adc dword[now_tr + 4], 0
      jmp .con

      .t2a:
      neg ecx
      sub dword[now_tr], ecx
      sbb dword[now_tr + 4], 0
      
      .con:
      inc ebx
      cmp ebx, edi
    jnz .top2
    
    mov ecx, dword[armat]
    mov eax, dword[mat]
    mov dword[ecx + esi * 4], eax
    mov eax, dword[now_tr]
    mov ecx, dword[now_tr + 4]

    mov edx, dword[tr]
    mov dword[edx + esi * 8], eax
    mov dword[edx + esi * 8 + 4], ecx

    inc esi

    cmp esi, dword[n]
  jnz .top1


  mov edx, dword[tr]
  
  mov eax, dword[edx]
  mov ebx, dword[edx + 4]

  mov esi, 1

  mov dword[a], 0

  ;А вот тут ты должен написать поиск максимума
  .top3:
    cmp esi, dword[n]
    jz .end3
    mov edi, dword[edx + esi * 8]
    mov ecx, dword[edx + esi * 8 + 4]

    cmp ecx, ebx
    jg .3great
    jl .3low
    cmp edi, eax
    ja .3great
    jbe .3low
    .3great:

    mov eax, edi
    mov ebx, ecx
    mov dword[a], esi


    .3low:
    inc esi
    cmp esi, dword[n]
  jnz .top3
  .end3:
  ;А вот тут вывод максимальной матрицы

  mov esi, dword[armat]
  mov eax, dword[a]
  mov esi, dword[esi + eax * 4]

  mov ecx, dword[arr]
  mov eax, dword[ecx + eax * 4]
  mov dword[m], eax

  mov edi, 0

  .top4:
    mov ebx, 0
    .top5:
      mov eax, dword[m]
      imul eax, edi
      add eax, ebx
      
      mov eax, dword[esi + eax * 4]

      mov dword[esp], output
      mov dword[esp + 4], eax
      call printf

      inc ebx
      cmp ebx, dword[m]
    jnz .top5
    mov dword[esp], endl
    call printf

    inc edi

    cmp edi, dword[m]
  jnz .top4

  mov eax, 0
  leave
ret

