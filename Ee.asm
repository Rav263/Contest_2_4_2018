%include 'io.inc'

section .rodata
  input1 db "%c", 0
  input2 db "%d", 0
  output db "%d %d", 10, 0

section .bss
  root resd 1
  now resd 1
  a resb 1
  b resd 1

section .text
CEXTERN malloc
CEXTERN free
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    and esp, 0xFFFFFFF0
    sub esp, 16


    mov dword[root], 0


    .top1:
        mov dword[esp], input1
        mov dword[esp + 4], a
        call scanf
        movzx eax, byte[a]

        cmp eax, 'F'
        jnz .con1
            jmp .end
        .con1:

        cmp eax, 'A'
        jnz .con2
            mov dword[esp], input2
            mov dword[esp + 4], b
            call scanf
            mov ebx, dword[b]

            call scanf
            mov edi, dword[b]

            push dword[root]
            push edi
            push ebx
            call App
            pop ebx
            pop edi
            add esp, 4
      

            cmp dword[root], 0
            jnz .top1
            mov dword[root], eax
            jmp .top1
        .con2:

        cmp eax, 'S'
        jnz .con3
            mov dword[esp],  input2
            mov dword[esp + 4], b
            call scanf
            mov ebx, dword[b]
            
            push dword[root]
            push ebx
            call Search
            pop ebx
            add esp, 4

            jmp .top1
        .con3:

        cmp eax, 'D'
        jnz .top1
            mov dword[esp], input2
            mov dword[esp + 4], b
            call scanf
            mov ebx, dword[b]

            push dword[root]
            push ebx
            call Del
            pop ebx
            add esp, 4

            mov dword[root], eax
            jmp .top1
    .end:

    push dword[root]
    call Free
    add esp, 4

    leave
    xor eax, eax
    ret

App:
    push ebp
    mov ebp, esp
  
    push ebx
    push edi
    push esi

    mov ebx, dword[ebp + 8] ;ключ
    mov edi, dword[ebp + 12] ;данные
    mov esi, dword[ebp + 16] ;указатель на текущую вершину

    cmp esi, 0 ;если вершина пустая
    jz .newnode
    
    .top1:
    
    mov ecx, dword[esi]
    cmp ebx, ecx
    jl .lower
    je .equal
        ;Если ключ больше
        cmp  dword[esi + 8], 0
        mov edx, 8
        jz .newnode
        mov esi, dword[esi + 8]
        jmp .top1
    .lower:
        ;Если ключ меньше
        cmp dword[esi + 12], 0
        mov edx, 12
        jz .newnode
        mov esi, dword[esi + 12]
        jmp .top1
    .equal:
        ;Если вершина с таким же ключом
        mov dword[esi], ebx
        mov dword[esi + 4], edi
        mov eax, esi
        jmp .end
   .newnode:
        sub esp, 16 ; Выделение места под аргументы

        mov dword[b], edx
        mov dword[esp], 16
        call malloc
        mov edx, dword[b]

        mov dword[eax], ebx ;ключ
        mov dword[eax + 4], edi ;данные
        mov dword[eax + 8], 0 ;указатель на большую ветку
        mov dword[eax + 12], 0 ;указатель на меньшую ветку
        
        add esp, 16
       
        cmp esi, 0
        jz .end

        mov dword[esi + edx], eax 
        mov eax, esi
    .end:


    pop esi
    pop edi
    pop ebx

    leave
    ret

Search:
    push ebp
    mov ebp, esp

    push ebx
    push edi
    push esi

    sub esp, 4

    mov ebx, dword[ebp + 8] ;Ключ
    mov esi, dword[ebp + 12] ;Указатель


    cmp esi, 0
    jnz .con1
        jmp .end
    .con1:

    .top1:

    mov ecx, dword[esi]
    cmp ebx, ecx
    jl .lower
    je .equal
        cmp dword[esi + 8], 0
        jz .end
        mov esi, dword[esi + 8]
        jmp .top1
    .lower:
        cmp dword[esi + 12], 0
        jz .end
        mov esi, dword[esi + 12]
        jmp .top1
    .equal:
        sub esp, 16
        mov eax, dword[esi]
        mov ecx, dword[esi + 4]

        mov dword[esp], output
        mov dword[esp + 4], eax
        mov dword[esp + 8], ecx
        call printf

        add esp, 16

    .end:

    xor eax, eax
    add esp, 4
    pop esi
    pop edi
    pop ebx
    
    leave
    ret

Del:
    push ebp
    mov ebp, esp

    push ebx
    push edi
    push esi
    sub esp, 4


    mov ebx, dword[ebp + 8]
    mov esi, dword[ebp + 12]

    cmp esi, 0
    jnz .con1
        mov eax, 0
        jmp .end
    .con1:
    
    mov ecx, dword[esi]
    cmp ebx, ecx
    jl .lower
    je .equal
        push dword[esi + 8]
        push ebx
        call Del
        pop ebx
        add esp, 4

        mov dword[esi + 8], eax
        mov eax, esi
        jmp .end
    .lower:
        push dword[esi + 12]
        push ebx
        call Del
        pop ebx
        add esp, 4

        mov dword[esi + 12], eax
        mov eax, esi
        jmp .end
    .equal:
        cmp dword[esi + 8], 0
        jnz .con2
            sub esp, 16

            mov edi, dword[esi + 12]

            mov dword[esp], esi
            call free

            mov eax, edi
            add esp, 16
            jmp .end
        .con2:
        cmp dword[esi + 12], 0
        jnz .con3
            sub esp, 16

            mov edi, dword[esi + 8]
      
            mov dword[esp], esi
            call free

            mov eax, edi
            add esp, 16
            jmp .end
        .con3:
            push dword[esi + 8]
            call Find
            add esp, 4

            mov edi, eax

            mov eax, dword[edi]
            mov ecx, dword[edi + 4]
            mov dword[esi], eax
            mov dword[esi + 4], ecx

            push dword[esi + 8]
            push dword[edi]
            call Del
            add esp, 8

            mov dword[esi + 8], eax
            mov eax, esi

    .end:

    add esp, 4
    pop esi
    pop edi
    pop ebx
    
    leave
    ret


Find:
    push ebp
    mov ebp, esp

    push ebx
    push edi
    push esi

    mov esi, dword[ebp + 8]

    cmp dword[esi + 12], 0
    jnz .con1
        mov eax, esi
        jmp .end
    .con1:
        push dword[esi + 12]
        call Find
        add esp, 4
    .end:
    pop esi
    pop edi
    pop ebx

    leave 
    ret


Free:
    push ebp
    mov ebp, esp

    push ebx
    push edi
    push esi
    sub esp, 8

    mov esi, dword[ebp + 8]

    cmp esi, 0
    jz .end
        push dword[esi + 8]
        call Free
        add esp, 4
        
        push dword[esi + 12]
        call Free
        add esp, 4

    sub esp, 16
    mov dword[esp], esi
    call free
 
    add esp, 16
    .end:

    add esp, 8
    pop esi
    pop edi
    pop ebx

    xor eax, eax
    leave
    ret

