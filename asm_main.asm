;
; file: asm_main.asm

%include "asm_io.inc"
%define DOUBLEWORD 4							; Defines variable to space DWORDS in array
;
; initialized data is put in the .data segment
;
segment .data
        syswrite: equ 4
        stdout: equ 1
        exit: equ 1
        SUCCESS: equ 0
        kernelcall: equ 80h
a1: dd 2,5,4,7,1							; Dword array used in the program
scalar: dd 2								; Variable to scale arary values by
size: dd 5								; Size of array

; uninitialized data is put in the .bss segment
;
segment .bss

;
; code is put in the .text segment
;
segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
; *********** Start  Assignment Code *******************
	mov eax, 0							; EAX = 0, EBX = scalar, ECX = size, edx = a1
	mov ebx, [scalar]
	mov ecx, [size]
	mov edx, a1
	push edx							; Pushes EAX, EBX, ECX, and EDX to the stack
	push ecx
	push ebx
	push eax
	call changeArray						; Calls changeArray function
	call printArray							; Calls printArray function w/ params passed from the stack values from changeArray
; *********** End Assignment Code **********************

        popa
        mov     eax, SUCCESS       ; return back to the C program
        leave                     
        ret
changeArray:								; changeArray Prologue Code
	pop ebp								; Pops return address to ebp
	pop eax								; Pops other stack values into respective regs
	pop ebx
	pop ecx
	pop edx
changeArrayLoop:							; changeArray Body. Starts at last value of array
	mov eax, [edx + ecx*DOUBLEWORD - 4]				; Moves the current array value into eax
	imul eax, ebx							; Multiplies EAX by EBX
	mov [edx + ecx*DOUBLEWORD - 4], eax				; Replaces old array value with new value
	xor eax, eax							; Sets EAX to 0
	loop changeArrayLoop						; Loops through changeArrayLoop
	xor ebx, ebx							; Sets EBX to 0
changeArrayEnd:								; changeArray Epilogue Code
	push edx							; Pushes EAX, ECX, EDX, and EBP to the stack
	push ecx
	push eax
	push ebp
	ret								; Returns to asm_main
printArray:								; printArray Prologue Code
	pop ebp								; Pops return address to EBP
	pop eax								; Pops other stack values into respective regs
	pop ecx
	pop edx
printArrayLoop:								; printArray Body. Starts at first value of array
	cmp ecx, [size]							; Compares ECX with size. JE Epilogue Code
	je printArrayEnd
	mov eax, [edx + ecx*DOUBLEWORD]					; Moves current array value to EAX and prints
	call print_int
	call print_nl
	inc ecx								; Increments ECX
	xor eax, eax							; Sets EAX to 0
	jmp printArrayLoop						; Jumps to printArrayLoop
printArrayEnd:								; printArray Epilogue Code
	push ebp							; Pushes EBP to stack
	ret								; Return to asm_main
