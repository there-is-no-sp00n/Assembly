@ CSE 2312
@ Final Calculator
@ Final Progamming Assignment


.global main
.func main

main:
    BL _scanf				@ get the first number as a float
    PUSH {R0}				@ back it up
    BL get_char				@ get the char for calculator operation
    MOV R2, R0				@ move it to R2
    BL execute_calc			@ branch to execute_calc
    

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
	CMP R2, #'a'			@ if 'a' branch to _abs
	BEQ _abs
	CMP R2, #'s'			@ if 's' branch to _sqr_root
	BEQ _sqr_root
	CMP R2, #'p'			@ if 'p' branch to _pow
	BEQ _pow
	CMP R2, #'i'			@ if 'i' branch to _inverse
	BEQ _inverse

_abs:
    LDR R0, =abs_str			@ load the string
    BL printf				@ print it
    
    POP {R1}				@ restore R1
    VMOV S0, R1             		@ move R1 to FPU register S0
    VABS.F32 S0, S0			@ use the VABS instruction
    VCVT.F64.F32 D1, S0     		@ covert the result to double precision for printing
    VMOV R1, R2, D1         		@ split the double VFP register into two ARM registers
    BL _printf				@ branch to _printf
    B main				@ loop back up to main
    
_sqr_root:
	LDR R0, =sqrt_str		@ load the string
	BL printf			@ print it
	
	POP {R1}			@ restore R1
	VMOV S0, R1			@ move R1 to FPU register S0
	VSQRT.F32 S0, S0		@ use the VSQRT instruction
	VCVT.F64.F32 D1, S0     	@ covert the result to double precision for printing
    	VMOV R1, R2, D1        		@ split the double VFP register into two ARM registers
	BL _printf
	B main
	
_pow:
	BL _scanf			@ get the exponent
	@MOV R3, R0			@ move it to R3
	POP {R1}			@ restore R1
	
	VMOV S0, R0			@ move the iterator to S0
	VCVT.U32.F32 S0, S0		@ convert the iterator to int
	VMOV R0, S0			@ put it back into R0
	
	VMOV S0, R1			@ move R1 to S0
	VMOV S1, R1			@ move R1 to S1
	
	pow_it:
		CMP R0, #1		@ check to see if done iterating
		BEQ pow_done		@ if so branch to pow_done
		VMUL.F32 S1, S1, S0	@ use the VMUL instruction
		SUB R0, R0, #1		@ subtract from the iterator
		BHS pow_it		@ loop back up to pow_it
	
	
pow_done:
	LDR R0, =pow_str		@ load the string
	BL printf			@ print it
	VCVT.F64.F32 D1, S1     	@ covert the result to double precision for printing
    	VMOV R1, R2, D1         	@ split the double VFP register into two ARM registers
	BL _printf			@ branch to _printf
	B main				@ loop back up to main
	

_inverse:
	LDR R0, =inv_str		@ load the string
	BL printf			@ print it
	
	POP {R1}			@ restore R1
	VMOV S0, R1			@ move it to FPU register S0
	MOV R5, #1			@ move 1 to R5
	VMOV S1, R5			@ move R5 to FPU register S1
	
    	VCVT.F32.U32 S1, S1     	@ convert unsigned bit representation to single float
	
	VDIV.F32 S2, S1, S0     	@ compute S2 = S0 * S1
    
    	VCVT.F64.F32 D4, S2     	@ covert the result to double precision for printing
    	VMOV R1, R2, D4         	@ split the double VFP register into two ARM registers
	BL _printf			@ branch to _printf
	B main				@ loop back up to main
	
    
_printf:
    PUSH {LR}               @ push LR to stack
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return



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

read_char:    .asciz  " "
format_str:   .asciz  "%f"
abs_str:	.asciz	"Absolute is: " 
sqrt_str:	.asciz	"Sqaure Root is: "
pow_str:	.asciz	"Power output is: "
inv_str:	.asciz	"Inverse is: "
output_str:   .asciz  "%f\n"
printf_str:     .asciz      "%f\n"

.end
