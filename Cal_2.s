.global main
.func main

main:
	BL _scanf			@ get the int
	MOV R9, R0			@ back up the int
	BL get_char			@ get the char
	MOV R10, R0			@ back up the char
	BL _scanf			@ get the last int
	@MOV R11, R0			@ move all the inputs to R1, R2, R3 to prepare for execute_calc
	
	MOV R1, R9			@ R1 for first int
	MOV R2, R10			@ R2 for char
	MOV R3, R0			@ R3 for last int
	BL execute_calc			@ run execute_calc


get_char:	
	MOV R7, #3			@ set the mode to 3
	MOV R0, #0			@ input stream is 0, the monitor
	MOV R2, #1			@ read a single char
	LDR R1, = read_char		@ store the character in data memory
	SWI 0				@ execute the system call
	LDR R0, [R1]			@ move the character to the return register
	AND R0, #0xFF			@ mask out everything but the right 8 bits
	MOV PC, LR			@ return


execute_calc:
	CMP R2, #'+'			@ if the char is '+' run _ADD
	BEQ _ADD
	CMP R2, #'-'			@ if the char is '-' run _SUB
	BEQ _SUB
	CMP R2, #'*'			@ if the char is '*' run _MUL
	BEQ _MUL
	CMP R2, #'M'			@ if the char is 'M' run _MAX
	BEQ _MAX

_ADD:
	ADD R1, R1, R3			@ do the addition
	BL _print_calc			@ run _print_calc

_SUB:
	SUB R1, R1, R3			@ do the subtraction
	BL _print_calc			@ run _print_calc

_MUL:
	MUL R1, R1, R3			@ do the multiplication
	BL _print_calc			@ run _print_calc

_MAX:
	CMP R1, R3			@ compare R1 and R3
	BGT _print_calc			@ if R1 is larger, run _print_calc
	MOV R1, R3			@ this line wont execute if R1 is larger... meaning if here, R3 is larger
	BLT _print_calc			@ R3 is moved to R1 (previous line), run _print_calc


_print_calc:
	LDR R0, =out_str		@ R0 gets the preset string
	BL printf			@ call printf
	B main				@ loop back to main (makes it run in a loop)

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return


.data

format_str:     .asciz	"%d"
read_char:	.ascii	" "
out_str:	.ascii	"Output: %d\n"

.end
