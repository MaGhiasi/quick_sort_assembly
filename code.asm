%include "asm_io.inc"

segment .data
arr1:
len1: dd 0

arr0: dd 32.9, 85.8, -10.2 , 26.4, 71.2, 32.9, -15.7, 34.5, 96.3, 61.1
len0: dd 10 

arr2: dd 10.2, 80.3, 30.4, 90.6, 40.5, 50.6, 70.7
len2: dd 7

arr3: dd 32.9, 85.8, 45.6, 26.4, 71.2, 32.9, 15.7, 34.5, 96.3, 61.1
len3: dd 10 
zero:   dd  0

temp1: dd 0.0

segment .text
        global  _asm_main
_asm_main:
        enter   0,0
        pusha
        ;enter length and array
        rea



        mov     ebx,[len1]
        dec     ebx
        mov     [len1],ebx
        
        push    dword [len1]
        push    dword [zero]
        push    arr1
        call    quicksort        

        mov     ebx,[len1]
        inc     ebx
        push    ebx
        push    arr1
        call    printArray


        popa
        mov     eax, 0
        leave                     
        ret



quicksort:
        enter 0,0
        pusha
        mov     ebx,[ebp+12]     ;ebx=low
        mov     edi,[ebp+16]     ;edi=high
        mov     edx,[ebp+8]      ;edx =array

        cmp     ebx,edi
        jge      sort_end        ;end calling

        lea      ecx,[ebx-1]     ;ecx=i,ebx=j
loopx1:
        cmp     ebx,edi           
        jge      loopx1_end      ;if j >= high break loop 

        fld    dword [edx+edi*4]
        fld    dword [edx+ebx*4]
        fcomip   st1
        fstp    dword [temp1]
        ja      loopx1_rest      ;if arr[j] < pivot => continue rest
        inc     ecx
        fld dword [edx+ecx*4]    ;exchang arr[i],arr[j]
	fld dword [edx+ebx*4]
	fstp dword [edx+ecx*4]
	fstp dword [edx+ebx*4]

loopx1_rest:
        inc     ebx            
        jmp     loopx1

loopx1_end:
        inc     ecx             
        fld dword [edx+edi*4]   ;exchang pivot , arr[i+1]
	fld dword [edx+ecx*4]
	fstp dword [edx+edi*4]
	fstp dword [edx+ecx*4]
        dec     ecx            

left_part:
        push    ecx             ;ecx = i = high
        push    dword[ebp+12]   ;low = low
        push    edx
        call    quicksort
        
right_part:
        add     ecx,2           ;i=i+2
        push    dword [ebp+16]  ;high = high
        push    ecx             ;ecx = i+2 = low
        push    edx
        call    quicksort
                        
sort_end:
        popa
        leave
        ret  12   


printArray:
        enter 0,0
        pusha
        mov     ebx,[ebp+8]
        mov     ecx,[ebp+12]
loop1:
        mov     eax,[ebx]
        call    print_float

        mov     al,' '
        call    print_char

        mov     al,'|'
        call    print_char
        
        mov     al,' '
        call    print_char

        add     ebx,4
        loop    loop1

        mov     al,10
        call    print_char

        popa
        leave
        ret     8


extern _scanf
read_float:
        enter 4,0
        pusha
        pushf
        lea eax, [ebp-4]
        push eax
        push dword float_format
        call _scanf
        pop eax
        pop eax
        popf
        popa
        mov eax, [ebp-4]
        leave
        ret