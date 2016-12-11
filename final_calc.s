@ CSE 2312
@ Final Calculator
@ Final Progamming Assignment


.global main
.func main

main:
    BL _scanf
    @MOV R1, R0
    PUSH {R0}
    BL get_char
    @POP {R1}
    MOV R2, R0
    @BL _iprint
    BL execute_calc
    

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
	CMP R2, #'a'
	BEQ _abs
	CMP R2, #'s'
	BEQ _sqr_root
	CMP R2, #'p'
	@BEQ _power
	CMP R2, #'i'
	@BEQ _inverse

_abs:
    LDR R0, =abs_str
    BL printf
    POP {R1}
    VMOV S0, R1             @ move return value R0 to FPU register S0
    VABS.F32 S0, S0
    VCVT.F64.F32 D1, S0     @ covert the result to double precision for printing
    VMOV R1, R2, D1         @ split the double VFP register into two ARM registers
    @VMOV R1, S0
    BL _printf
    B main
    
_sqr_root:
	POP {R1}
	VMOV S0, R1
	VSQRT.F32 S0, S0
	VCVT.F64.F32 D1, S0     @ covert the result to double precision for printing
    	VMOV R1, R2, D1         @ split the double VFP register into two ARM registers
	BL _printf
	B main
	
    
_printf:
    PUSH {LR}               @ push LR to stack
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return

@_iprint:
@	PUSH {LR}
@	LDR R0, =output_str
@	VMOV S0, R1             @ move return value R0 to FPU register S0
 @   VCVT.F64.F32 D1, S0     @ covert the result to double precision for printing
  @  VMOV R1, R2, D1         @ split the double VFP register into two ARM registers
@	BL printf
@	POP {PC}

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
output_str:   .asciz  "%f\n"
printf_str:     .asciz      " %f\n"

.end
