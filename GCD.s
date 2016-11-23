@ CSE 2312
@ GCD
@ Programming Assignment #2


.global main
.func main


main:
    BL _scanf			@ get the int
    MOV R1, R0			@ move to R1
    BL _scanf			@ get the second int
    MOV R2, R0			@ move to R2
    ADD R8, R1, #0
    ADD R9, R2, #0
    PUSH {R1}           	@ back up R1 to stack
    PUSH {R2}           	@ back up R2 to stack
    BL _cont_mod        	@ branch to _cont_mod
    
    
    
_cont_mod:
   @ LDR R0, =check_str
    CMP R2, R1              @ check to see if R1 < R2
    MOVHS R0, R1            @ if R2 > R1 swap R1 & R2
    MOVHS R1, R2            @ still swapping R1 & R2
    MOVHS R2, R0            @ still swapping R1 & R2

    BL _sub_loop_check      @ branch to _sub_loop_check



_sub_loop_check:
    @LDR R0, =check_str
    CMP R1, R2			@ see if R1 > R2
    BLT _sub_loop		@ branch to _sub_loop if R1 > R2
    BEQ _its_equal		@ branch to _its_equal if R1 == R2
    MOVHS R0, R1		@ if R2 > R1 swap
    MOVHS R1, R2		@ still swapping
    MOVHS R2, R0		@ still swapping
    CMP R1, R2			@ see if R1 > R2
    BLT _sub_loop		@ branch to _sub_loop if R1 > R2
    
    
_sub_loop:
    @LDR R0, =check_str
    SUB R1, R1, R2		@ subtract R2 from R1
    @BL _sub_loop_check		@ branch back to _sub_loop_check
    MOV PC, LR
    
    
_its_equal:
    @LDR R0, =check_str
    MOV R3, R1			@ move the GCD to R3
    POP {R2}			@ pop back R2 from stack
    POP {R1}			@ pop back R1 from stack
    BL _print_gcd		@ branch to _print_gcd
    

_print_gcd:	
    @LDR R0, =check_str
    LDR R0, = print_gcd		@ load the output string to R0
    BL printf			@ call on printf
    B main			@ unconditional branch back to main
    

_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4           @ make room on stack
    LDR R0, =format_str      @ R0 contains address of format string
    MOV R1, SP               @ move SP to R1 to store entry on stack
    BL scanf                 @ call scanf
    LDR R0, [SP]             @ load value at SP into R0
    ADD SP, SP, #4           @ restore the stack pointer
    POP {PC}                 @ return

.data

print_gcd:	.ascii		"GCD of %d and %d is %d \n"
format_str:     .asciz      "%d"
check_str: .ascii       "OKAY\n"

.end
