.global main
.func main


main:
    BL _scanf			@ get the int
	MOV R1, R0			@ move to R1
    BL _scanf			@ get the second int
	MOV R2, R0			@ move to R2
    PUSH {R1}           @ back up R1 to stack
    PUSH {R2}           @ back up R2 to stack
    BL _cont_mod        @ branch to _cont_mod
    
    
    
_cont_mod:
    CMP R2, R1              @ check to see if R1 < R2
    MOVHS R0, R1            @ if R2 > R1 swap R1 & R2
    MOVHS R1, R2            @ still swapping R1 & R2
    MOVHS R2, R0            @ still swapping R1 & R2
    MOV R0, #0
    BL _sub_loop_check      @ branch to _sub_loop_check


_sub_loop_check:
    CMP R1, R2
    BLT _sub_loop
    BEQ _its_equal
    MOVHS R0, R1
    MOVHS R1, R2
    MOVHS R2, R0
    CMP R1, R2
    BLT _sub_loop
    
    
_sub_loop:
    SUB R1, R1, R2
    BL _sub_loop_check
    
    
_its_equal:
    MOV R3, R1
    POP {R2}
    POP {R1}
    BL _print_gcd
    

_print_gcd:
    LDR R0, = print_gcd
    BL printf
    B main
    

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

print_gcd:	.asciii		"GCD of %d and %d is %d"
format_str:     .asciz      "%d"

.end
