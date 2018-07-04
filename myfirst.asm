	BITS 16

start:
	mov ax, 07C0h		; set up 4k stack space after bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax		; actually set ds from ax register.

	mov si, prompt_name	; put string pos into SI
	call print_string	; call string-print routine
	mov si, prompt_name
	call get_string
	mov si, prompt_location
	call print_string
	call get_string

	jmp $			; Jump here - infinite loop.



	text_string db 'New OS glory!', 0
	prompt_name db 'Hi, what is your name: ', 0
	prompt_location db 'Where are you from?', 0

;sinput: resb 100

print_string:			; Routine: output string in SI to screen
	xor ax, ax
	mov ah, 0Eh		; int 10h 'print char' function

.repeat:
	lodsb			; get character from string
	cmp al, 0
	je .done		; If char is 0, end of string.
	int 10h			; Otherwise print it
	jmp .repeat

.done:
	ret

get_string:
	push
.repeat:
	xor ax, ax
	int 16h
	mov ah, 0Eh
	cmp al, 0x0d
	je .done
	int 10h
	jmp .repeat
	
.done:
	mov al, 0x0a
	mov ah, 0Eh
	int 10h 
	mov al, 0x0d
	int 10h
	ret

	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; Standard PC boot signature.
