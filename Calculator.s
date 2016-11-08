.global main
.func main

main:
	BL get_int			@get the int
	MOV R10, R0			@back up the int
	BL get_char			@get the char
	MOV R11, R0			@back up the char
	BL get_int			@get the last int
	MOV R1, R10			@move all the inputs to R1, R2, R3 to prepare for execute_calc
	MOV R2, R11
	MOV R3, R0
	BL execute_calc			@run execute_calc
	BL main				@loop back to main


get_int:
		MOV R7, #3
		MOV R0, #1
		MOV R2, #1
		LDR R1, = read_int
		SWI 0
		LDR R0, [R1]
		AND R0, #0xFFFF
		MOV PC, LR


get_char:	
		MOV R7, #3
		MOV R0, #1
		MOV R2, #1
		LDR R1, = read_char
		SWI 0
		LDR R0, [R1]
		AND R0, #0xFF
		MOV PC, LR


execute_calc:
		MOV R6, LR
		CMP R2, #'+'
		BEQ _ADD
		CMP R2, #'-'
		BEQ _SUB
		CMP R2, #'*'
		BEQ _MUL
		CMP R2, #'M'
		BEQ _MAX
		MOV PC, R6

_ADD:
	ADD R0, R1, R3
	MOV R1, LR
	BL _print_calc
	MOV PC, R1

_SUB:
	SUB R0, R1, R3
	MOV R1, LR
	BL _print_calc
	MOV PC, R1

_MUL:
	MUL R1O, R1, R3
	MOV R0, R10
	MOV R1, LR
	BL _print_calc
	MOV PC, R1

_MAX:
	MOV R0, R1
	MOV R1, LR
	CMP R0, R3
	BGT _print_calc
	MOV R0, R3
	BLT _print_calc
	MOV PC, R1


_print_calc:
		MOV R5, LR
		LDR R0, =out_str
		BL printf
		MOV PC, R5


.data

read_int:	asciz		"%d"
read_char:	asciz		" "
out_str:	asciz		"Output: %d"

.end
