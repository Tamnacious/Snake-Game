; Names: Carmen Tam (50194532) & Dee Gao (50244179)
; Note: Make sure terminal screen size is the same size as the game board or it will print out funny.
; ALSO NOTE: YOU MUST RUN THIS ON 115200 BAUD RATE
	.data
top:			.string " ---------------------------------------- ", 0xD,0xA
Border1:		.string "|                                        |", 0xD,0xA
Border2:		.string "|                                        |", 0xD,0xA
Border3:		.string "|                                        |", 0xD,0xA
Border4:		.string "|                                        |", 0xD,0xA
Border5:		.string "|                                        |", 0xD,0xA
Border6:		.string "|                                        |", 0xD,0xA
Border7:		.string "|                                        |", 0xD,0xA
Border8:		.string "|                                        |", 0xD,0xA
starter:		.string "|                      *                 |", 0xD,0xA
Border9:		.string "|                                        |", 0xD,0xA
Border10:		.string "|                                        |", 0xD,0xA
Border11:		.string "|                                        |", 0xD,0xA
Border12:		.string "|                                        |", 0xD,0xA
Border13:		.string "|                                        |", 0xD,0xA
Border14:		.string "|                                        |", 0xD,0xA
Border15:		.string "|                                        |", 0xD,0xA
Border16:		.string "|                                        |", 0xD,0xA
bottom:			.string " ---------------------------------------- ", 0, 0xD,0xA

prompt:			.string " ---------------------------------------- ", 0xD,0xA
Border17:		.string "|                                        |", 0xD,0xA
Border18:		.string "|                                        |", 0xD,0xA
Border19:		.string "|   ||||| ||    ||  |||||  ||  || |||||  |", 0xD,0xA
Border20:		.string "|  ||     ||||  || ||   || || ||  ||     |", 0xD,0xA
Border21:		.string "|  |||||| || || || ||||||| ||||   |||||  |", 0xD,0xA
Border22:		.string "|      || ||  |||| ||   || || ||  ||     |", 0xD,0xA
Border23:		.string "|  |||||  ||    || ||   || ||  || |||||  |", 0xD,0xA
Border24:		.string "|                                        |", 0xD,0xA
starter2:		.string "|                      *                 |", 0xD,0xA
Border25:		.string "|                                        |", 0xD,0xA
Border26:		.string "|      Press w, a, s, or d to start.     |", 0xD,0xA
Border27:		.string "|      Do not press any other keys.      |", 0xD,0xA
Border28:		.string "|        It will pause the game.         |", 0xD,0xA
Border29:		.string "|                                        |", 0xD,0xA
Border30:		.string "|                                        |", 0xD,0xA
Border31:		.string "|                                        |", 0xD,0xA
Border32:		.string "|                                        |", 0xD,0xA
bottom2:		.string " ---------------------------------------- ", 0

top2:			.string " ---------------------------------------- ", 0xD,0xA
Border33:		.string "|                                        |", 0xD,0xA
Border34:		.string "|     ||||||  |||||  |\     /| ||||||    |", 0xD,0xA
Border35:		.string "|    ||      ||   || ||\\ //|| ||        |", 0xD,0xA
Border36:		.string "|    ||  ||| ||||||| || \/  || ||||||    |", 0xD,0xA
Border37:		.string "|    ||   || ||   || ||     || ||        |", 0xD,0xA
Border38:		.string "|     |||||| ||   || ||     || ||||||    |", 0xD,0xA
Border39:		.string "|                                        |", 0xD,0xA
Border40:		.string "|     ||||| \\       // |||||| |||||     |", 0xD,0xA
starter3:		.string "|    ||   || \\     //  ||     |   ||    |", 0xD,0xA
Border41:		.string "|    ||   ||  \\   //   |||||| |||||     |", 0xD,0xA
Border42:		.string "|    ||   ||   \\ //    ||     || \\     |", 0xD,0xA
Border43:		.string "|     |||||     \_/     |||||| ||  \\    |", 0xD,0xA
Border44:		.string "|                                        |", 0xD,0xA
Border45:		.string "|              Score:                    |", 0xD,0xA
Border46:		.string "|                                        |", 0xD,0xA
Border47:		.string "|       Press p to restart the game!     |", 0xD,0xA
Border48:		.string "|                                        |", 0xD,0xA
bottom3:		.string " ---------------------------------------- ", 0, 0xD,0xA

top3:			.string " ---------------------------------------- ", 0xD,0xA
Border49:		.string "|                                        |", 0xD,0xA
Border50:		.string "|                                        |", 0xD,0xA
Border51:		.string "|                                        |", 0xD,0xA
Border52:		.string "|                                        |", 0xD,0xA
Border53:		.string "|                                        |", 0xD,0xA
Border54:		.string "|                                        |", 0xD,0xA
Border55:		.string "|                                        |", 0xD,0xA
Border56:		.string "|                                        |", 0xD,0xA
starter4:		.string "|                      *                 |", 0xD,0xA
Border58:		.string "|                                        |", 0xD,0xA
Border59:		.string "|                                        |", 0xD,0xA
Border60:		.string "|                                        |", 0xD,0xA
Border61:		.string "|                                        |", 0xD,0xA
Border62:		.string "|                                        |", 0xD,0xA
Border63:		.string "|                                        |", 0xD,0xA
Border64:		.string "|                                        |", 0xD,0xA
Border65:		.string "|                                        |", 0xD,0xA
bottom4:		.string " ---------------------------------------- ", 0, 0xD,0xA

	.text
	.global uart_init
	.global timer_init
	.global output_character
	.global read_character
	.global display_prompt
	.global displayBoard
	.global game_play
	.global end_game
	.global UART0Handler
	.global Timer0Handler
	.global lab6
	.global library_lab_6

start_scr: .word prompt
game_ptr: .word top
game_ptr2: .word Border1
game_ptr3: .word bottom
end_scr: .word top2
new_scr: .word top3
head: .word 0x200001A3


lab6:
	STMFD sp!, {lr}

	BL uart_init				; initialize the UART
	BL timer_init				; initialize timer setup & config

	BL start_game
	LDR r8, head


	LDMFD sp!, {lr}
	mov pc, lr

;--------------------------- interrupts ----------------------------------------------
; Handles interrupt when user presses keys on keyboard
UART0Handler:
	STMFD r13!, {r0-r7, r11-r12, lr}

	BL read_character
	MOV r9, r0
	CMP r0, #0x70				; Did user press 'p'?
	BEQ restart					; Yes: restart game
	B exit_interrupt			; No: exit interrupt

restart:
	BL new_game					; restore clean board
	BL start_game				; display starting screen
	LDR r8, head				; point back at head
	MOV r9, #0					; reset r9
	BL timer_init				; reinitialize the timer

exit_interrupt:
	MOV r2, #0xC044
	MOVT r2, #0x4000
	LDRB r1, [r2]
	ORR r1, r1, #0x10				; Clears UART interrupt
	STRB r1, [r2]					; Write '1' to UARTIM RXIM Bit

	LDMFD r13!, {r0-r7, r11-r12, lr}
	BX lr

Timer0Handler:
	STMFD r13!, {lr}

	;clear this interrupt first
	MOV r2, #0x0024
    MOVT r2, #0x4003			; r2 = 0x40030000
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    ORR r1, r1, #0x1			; Changes r1 to #1
    STR r1, [r2]				; Stores back into the address

	BL game_play

	LDMFD r13!, {lr}
	BX lr

;------------------------- display board --------------------------------------------
; Display the game board onto PuTTy.
displayBoard:
	STMFD SP!,{lr}

	LDR r4, game_ptr

keepDisplaying:
	LDRB r0, [r4], #1			; load byte of game board
	CMP r0, #0x0				; did we reach null terminating string?
	BEQ boardDone				; yes: done displaying entire board
	BL output_character			; no: output game board byte
	B keepDisplaying			; loop until done displaying entire board

boardDone:
	LDMFD sp!, {lr}
	mov pc, lr

;--------------------------- start game ----------------------------------------------
; Display the game's starting screen
start_game:
	STMFD SP!,{lr}

	LDR r4, start_scr

continue:
	LDRB r0, [r4], #1			; load byte of game board
	CMP r0, #0x0				; did we reach null terminating string?
	BEQ complete				; yes: done displaying entire board
	BL output_character			; no: output game board byte
	B continue					; loop until done displaying entire board

complete:
	LDMFD sp!, {lr}
	mov pc, lr

;--------------------------- end game ----------------------------------------------
; Display the game's ending screen
end_game:
	STMFD SP!,{lr}

	LDR r4, end_scr

continue2:
	LDRB r0, [r4], #1			; load byte of game board
	CMP r0, #0x0				; did we reach null terminating string?
	BEQ complete2				; yes: done displaying entire board
	BL output_character			; no: output game board byte
	B continue2					; loop until done displaying entire board

complete2:
	LDMFD sp!, {lr}
	mov pc, lr

;--------------------------- new game ----------------------------------------------
; Restore empty game screen
new_game:
	STMFD SP!,{r5,lr}

	LDR r4, new_scr
	LDR r5, game_ptr

continue3:
	LDRB r0, [r4], #1			; load byte of game board
	CMP r0, #0x0				; did we reach null terminating string?
	BEQ complete3				; yes: done storing entire board
	STRB r0, [r5], #1			; no: store byte
	B continue3					; loop until done storing entire board

complete3:
	MOV r4, #0x0907
	MOVT r4, #0x2000			; r4 = 0x20000907 (base address for score)
	MOV r0, #0x20				; 0x20 = ASCII SPACE
	STRB r0, [r4], #-1			; Store spaces to cover the old score
	STRB r0, [r4], #-1
	STRB r0, [r4], #-1

	LDMFD sp!, {r5,lr}
	mov pc, lr

	.end
