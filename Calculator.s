.global main
.func main

main:
	BL _scanf			@get the int
	MOV R9, R0			@back up the int
	BL get_char			@get the char
	MOV R10, R0			@back up the char
	BL _scanf			@get the last int
	MOV R11, R0			@move all the inputs to R0, R1, R2 to prepare for execute_calc
	
	MOV R0, R9			@R0 for first int
	MOV R2, R10			@R2 for char
	MOV R1, R11			@R1 for last int
	BL execute_calc			@run execute_calc
	B main				@loop back to main


@get_int:
@	MOV R7, #3
@	MOV R0, #0
@	MOV R2, #1
@	LDR R1, = read_int
@	SWI 0
@	LDR R0, [R1]
@	AND R0, #0xFFFF
@	MOV PC, LR


get_char:	
	MOV R7, #3
	MOV R0, #0
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
	ADD R0, R0, R1
	MOV R1, LR
	BL _print_calc
	MOV PC, R1

_SUB:
	SUB R0, R0, R1
	MOV R1, LR
	BL _print_calc
	MOV PC, R1

_MUL:
	MUL R0, R0, R1
	MOV R1, LR
	BL _print_calc
	MOV PC, R1

_MAX:
	@MOV R0, R1
	MOV R3, LR
	CMP R0, R1
	BGT _print_calc
	MOV R0, R1
	BLT _print_calc
	MOV PC, R3


_print_calc:
	MOV R5, LR
	LDR R0, =out_str
	BL printf
	MOV PC, R5

_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return


.data
format_str:     .asciz	"%d"
read_int:	.ascii	"%d"
read_char:	.ascii	" "
out_str:	.ascii	"Output: %d"

.end
