	.text
	.global uart_init
	.global timer_init
	.global output_character
	.global read_character
	.global output_string
	.global display_prompt
	.global displayBoard
	.global start_game
	.global game_play
	.global stop_game
	.global int_to_string
	.global div_and_mod
	.global end_game
	.global restart_cursor
	.global library_lab_6

;------------------------- output character --------------------------------------------
; output_character transmits a character from the UART to PuTTy. The character is passed in r0.
output_character:
	STMFD SP!,{lr}

	MOV r2, #0xC018
    MOVT r2, #0x4000				; r2 = 0x4000C018 (Status Register address)
    MOV r3, #0xC000
    MOVT r3, #0x4000         		; r3 = 0x4000C000 (Data Register address)

oloop:
	LDR r5, [r2]					; Load contents of Status Register into r5
	AND r5, r5, #0x20				; Isolate bit TxFF for testing
	CMP r5, #0x20					; Is the TxFF bit = 1?
	BEQ oloop						; If yes, loop until TxFF = 0

	STRB r0, [r3]					; Store byte back into data register

	LDMFD sp!, {lr}
	mov pc, lr
;------------------------- read character ----------------------------------------------
; read_character reads a character which is received by the UART from PuTTy, returning the character in r0.
read_character:
	STMFD SP!,{lr}					; Store register lr on stack
	MOV r2, #0xC018          		; Holds 0xC018 in r2
    MOVT r2, #0x4000         		; r2 = 0x4000C018 (Status Register address)

rloop:
    LDR r1, [r2]       		 		; Load contents of Status Register into r1
	AND r1, r1, #0x10		 		; Isolate bit RxFE for testing
	CMP r1, #0x10			 		; Is the RxFE bit = 1?
    BEQ rloop       				; If yes, loop until RxFE = 0

    ; When RxFE is 0, read the byte from the recieve register
    MOV r3, #0xC000          		; r3 = 0xC000
    MOVT r3, #0x4000         		; r3 = 0x4000C000 (Data Register address)
    LDRB r0, [r3]              		; r0 = byte from data register (one character)

    LDMFD sp!, {lr}
	mov pc, lr

game_play:
	STMFD sp!, {lr}


	CMP r9, #0x77						; w?
	BEQ addTop
	CMP r9, #0x61						; a?
	BEQ addLeft
	CMP r9, #0x64						; d?
	BEQ addRight
	CMP r9, #0x73						; s?
	BEQ addBottom
	B clear

addTop:
	SUB r8, r8, #44
	LDRB r10, [r8]						; Check space user wants to go to
	ADD r7, r7, #1
	CMP r10, #0x20						; Empty space?
	BNE game_over						; No: branch to game over
	MOV r4, #0x2A						; Yes: move * to r4
	STRB r4, [r8]						; Store * at respective spot
	BL restart_cursor					; Reposition cursor at beginning of terminal
	BL displayBoard						; Redisplay the board
	B clear								; Branch back to loop

addLeft:
	SUB r8, r8, #1
	LDRB r10, [r8]
	ADD r7, r7, #1
	CMP r10, #0x20						; Space?
	BNE game_over
	MOV r4, #0x2A
	STRB r4, [r8]
	BL restart_cursor
	BL displayBoard
	B clear

addRight:
	ADD r8, r8, #1
	LDRB r10, [r8]
	ADD r7, r7, #1
	CMP r10, #0x20						; Space?
	BNE game_over
	MOV r4, #0x2A
	STRB r4, [r8]
	BL restart_cursor
	BL displayBoard
	B clear

addBottom:
	LDRB r10, [r8, #44]!
	ADD r7, r7, #1
	CMP r10, #0x20						; Space?
	BNE game_over
	MOV r4, #0x2A
	STRB r4, [r8]
	BL restart_cursor
	BL displayBoard
	B clear

game_over:
	BL stop_game

clear:
	LDMFD sp!, {lr}
	mov pc, lr

;--------------------------- stop the game ----------------------------------------------
; Game is stopped when player loses. Disables timer and what not.
stop_game:
	STMFD SP!,{lr}

	MOV r2, #0x000C				; Disable the timer
    MOVT r2, #0x4003			; r2 = 0x4003000C
    LDRB r1, [r2]
    BIC r1, r1, #0x1			; Clear bit 0
    STRB r1, [r2]

    MOV r2, #0x0004				; put timer into periodic mode
    MOVT r2, #0x4003
    LDRB r1, [r2]
    AND r1, r1, #0x0
    STRB r1, [r2]

    MOV r2, #0x0018				; set timer to interrupt when top limit reached
    MOVT r2, #0x4003			; r2 = 0x40030018
    LDRB r1, [r2]
    BIC r1, r1, #0x1			; Clear bit 0
    STRB r1, [r2]

    MOV r2, #0xE100
	MOVT r2, #0xE000
	LDR r1, [r2]
	AND r1, r1, #0x0
	STR r1, [r2]

	BL output_string			; Ends the game & displays score
	BL restart_cursor

	LDMFD sp!, {lr}
	mov pc, lr

;------------------------- output string -----------------------------------------------
; output_string transmits a null-terminated string for display in PuTTy.
; The base address of the string should be passed into the routine in r4.
output_string:
	STMFD SP!,{lr} 				; Store register lr on stack

	MOV r4, #0x0907
	MOVT r4, #0x2000			; r4 = 0x20009020 (base address)
	MOV r8, #0					; counter for # of digits the answer contains

div:
	BL int_to_string			; Branch to int_to_string
	STRB r3, [r4], #-1			; Store num into memory backwards (b/c answer comes out backwards)
	ADD r8, r8, #1				; increment counter
	CMP r7, #0					; Is quotient = 0?
	BNE div						; No: branch back to div again
	MOV r5, r4					; copy base address to r5 b/c r4 will get overwritten

loop6:
	BL restart_cursor
	BL end_game
	SUB r8, r8, #1				; decrement counter
	CMP r8, #0					; is counter = 0?
	BNE loop6					; no: loop till counter = 0 (answer has been fully outputted)

	LDMFD sp!, {lr}
	mov pc, lr
;---------------------- int to string -------------------------------------
; Converts an integer back into a string for output (display)
int_to_string:
	STMFD SP!,{lr} 			; Store register lr on stack

	MOV r12, #10			; 10 needed as divisor
	BL div_and_mod			; branch to div_and_mod for conversion purposes
	ADD r3, r10, #48		; r3 = remainder + 48 (ascii value of a digit)

	LDMFD sp!, {lr}
	mov pc, lr

div_and_mod:
	STMFD SP!,{lr}

	; Clear the registers & copy needed variables to new registers
    MOV r6, #0          	; r6 = counter
    MOV r5, #0          	; r5 = remainder
	MOV r3, #0

    ADD r6, r6, #15     	; initialize r6 (counter) to 15
    MOV r2, #0          	; r2 = quotient, initialize quotient to 0
    LSL r12, r12, #15     	; Logical Left Shift Divisor 15 places
    MOV r5, r7          	; Initialize Remainder to Dividend
    B LOOP5              	; Branch to LOOP5

SUBTRACT:
	SUB r6, r6, #1			; Decrement counter
    B LOOP5              	; Branch to LOOP5

LOOP5:
    SUB r5, r5, r12      	; Remainder:= Remainder (r5) - Divisor (r0)
    CMP r5, #0          	; Is remainder < 0 ?
    BLT YES             	; If true, branch to YES
    LSL r2, r2, #1      	; If false, Left Shift Quotient
    ADD r2, r2, #1      	; LSB = 1
    B CHECK             	; Branch to CHECK

YES:
    ADD r5, r5, r12      	; Remainder:= Remainder (r5) + Divisor (r0)
    LSL r2, r2, #1      	; Left Shift Quotient

CHECK:
	LSR r12, r12, #1      	; Right Shift Divisor
    CMP r6, #0         		; Is counter > 0 ?
    BGT SUBTRACT

	MOV r7, r2				; copy quotient to r7

END:
	MOV r10, r5				; copy remainder to r10

	LDMFD sp!, {lr}
	mov pc, lr


;------------------------- restart cursor ----------------------------------------------
; Resets the terminal cursor to position 0,0 (top left corner)
restart_cursor:
	STMFD SP!,{lr}

	MOV r0, #0x1B
	BL output_character
	MOV r0, #0x5B
	BL output_character
	MOV r0, #0x30
	BL output_character
	MOV r0, #0x3B
	BL output_character
	MOV r0, #0x30
	BL output_character
	MOV r0, #0x48
	BL output_character


	LDMFD sp!, {lr}
	mov pc, lr
;--------------------------- uart init ----------------------------------------------
uart_init:
	STMFD SP!,{lr} 				; Store register lr on stack

	MOV r2, #0xE608
	MOVT r2, #0x400F
	LDR r1, [r2]
	MOV r1, #0x2B				; Enable clock for GPIO PORT A, B, D, & F
	STR r1, [r2]

	MOV r2, #0xE618
    MOVT r2, #0x400F			; r2 = 0x400FE618
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    ORR r1, r1, #1					; Changes r1 to #1
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0xE608
    MOVT r2, #0x400F			; r2 = 0x400FE608
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    ORR r1, r1, #1					; Changes r1 to #1
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0xC030
    MOVT r2, #0x4000			; r2 = 0x4000C030
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    MOV r1, #0					; Changes r1 to #0
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0xC024				; Baud Integer
    MOVT r2, #0x4000			; r2 = 0x4000C024
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    MOV r1, #8					; Changes r1 to #104
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0xC028				; Baud Fractional
    MOVT r2, #0x4000			; r2 = 0x4000C028
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    MOV r1, #44					; Changes r1 to #11
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0xCFC8
    MOVT r2, #0x4000			; r2 = 0x4000CFC8
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    MOV r1, #0					; Changes r1 to #0
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0xC02C
    MOVT r2, #0x4000			; r2 = 0x4000C02C
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    MOV r1, #0x60				; Changes r1 to #0x60
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0xC030
    MOVT r2, #0x4000			; r2 = 0x4000C030
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    MOV r1, #0x301				; Changes r1 to #0x301
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0x451C
    MOVT r2, #0x4000			; r2 = 0x4000451C
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    ORR r1, r1, #0x03			; Changes r1 to #0x03
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0x4420
    MOVT r2, #0x4000			; r2 = 0x40004420
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    ORR r1, r1, #0x03			; Changes r1 to #0x03
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0x452C
    MOVT r2, #0x4000			; r2 = 0x4000452C
    LDR r1, [r2]				; Loads in the value in address r2 into r1
    ORR r1, r1, #0x11			; Changes r1 to #0x11
    STR r1, [r2]				; Stores back into the address

    MOV r2, #0xC038
	MOVT r2, #0x4000
	LDRB r1, [r2]
	ORR r1, r1, #0x10
	STRB r1, [r2]				; Enable UART Recieve in UART0 Interrupt Mask Register Interrupt Mask

	MOV r2, #0xE100
	MOVT r2, #0xE000
	LDRB r1, [r2]
	ORR r1, r1, #0x20
	STRB r1, [r2] 				; Set Bit 5 of EN0

	LDMFD sp!, {lr}
	mov pc, lr

;--------------------------- timer init ------------------------------------------------
timer_init:
	STMFD SP!,{lr}

	MOV r2, #0xE604				; Connect clock to timer
    MOVT r2, #0x400F			; r2 = 0x400FE604
    LDRB r1, [r2]
    ORR r1, r1, #0x1			; Set bit 0 to 1
    STRB r1, [r2]

	MOV r2, #0x000C				; Disable timer for setup & configuration
    MOVT r2, #0x4003			; r2 = 0x4003000C
    LDRB r1, [r2]
    BIC r1, r1, #0x0			; Clear bit 0
    STRB r1, [r2]


	MOV r2, #0x0000				; setup timer for 32-bit mode
    MOVT r2, #0x4003
    LDR r1, [r2]
    BIC r1, #0x0				; Clear bit 0
    STR r1, [r2]


	MOV r2, #0x0004				; put timer into periodic mode
    MOVT r2, #0x4003
    LDRB r1, [r2]
    ORR r1, r1, #0x02
    STRB r1, [r2]


	MOV r2, #0x0028				; set interrupt interval
    MOVT r2, #0x4003			; r2 = 0x40030028
    LDR r1, [r2]
    MOV r1, #0x0900				; .25 Seconds
    MOVT r1, #0x003D
    STR r1, [r2]

	MOV r2, #0x0018				; set timer to interrupt when top limit reached
    MOVT r2, #0x4003			; r2 = 0x40030018
    LDR r1, [r2]
    ORR r1, r1, #0x1			; Set bit 0 to 1
    STR r1, [r2]

	MOV r2, #0xE100				; Enable interrupts
    MOVT r2, #0xE000			; r2 = 0xE000E100
    LDR r1, [r2]
    ORR r1, #0x80000			; Set bit 19
    STR r1, [r2]

    MOV r2, #0x000C				; Enable timer
    MOVT r2, #0x4003			; r2 = 0x4003000C
    LDR r1, [r2]
    ORR r1, r1, #0x1			; Set bit 0 to 1
    STR r1, [r2]

	LDMFD sp!, {lr}
	mov pc, lr

;------------------------- display prompt ---------------------------------------------------
; Displays the prompt for the user to enter an expression on PuTTy
display_prompt:
	STMFD SP!,{lr} 				; Store register lr on stack

	MOV r3, #0xC000          	; r3 = 0xC000
   	MOVT r3, #0x4000         	; r3 = 0x4000C000 (Data Register address)

displayLoop:
	LDRB r0, [r4, r7]			; load first char of prompt into r0
	ADD r7, r7, #1				; Increment to next char
	BL output_character			; Output char onto PuTTy
	CMP r0, #0x0				; Did we reach end of string? (null)
	BNE displayLoop				; No: loop until null is reached
	MOV r7, #0					; Clear counter for additional prompts

	LDMFD sp!, {lr}
	mov pc, lr


