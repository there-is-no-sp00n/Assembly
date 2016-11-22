.global main
.func main


main:


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
