.global main
.func main

main:
  BL _scanf
  MOV R1, R0
  BL _scanf
  MOV R2, R0
  
  PUSH {R1}
  PUSH {R2}
  
 @BL _mod_unsigned
  
  BL _gcd
  @BL _print
  @B main
  
_gcd:
    CMP R1, R2
    SUBGT R1, R1, R2
    SUBLE R2, R2, R1
    BNE _gcd
    MOVEQ R3, R2
    POPEQ {R2}
    POPEQ {R1}
  
    
    @MOVEQ R1, R8
    @MOVEQ R2, R9
    BEQ _print

_mod_unsigned:
    cmp R9, R8          @ check to see if R1 >= R2
    MOVHS R0, R8        @ swap R1 and R2 if R2 > R1
    MOVHS R8, R9        @ swap R1 and R2 if R2 > R1
    MOVHS R9, R0        @ swap R1 and R2 if R2 > R1
    MOV R0, #0          @ initialize return value
    B _modloopcheck     @ check to see if
    _modloop:
        ADD R0, R0, #1  @ increment R0
        SUB R8, R8, R9  @ subtract R2 from R1
    _modloopcheck:
        CMP R8, R9      @ check for loop termination
        BHS _modloop    @ continue loop if R1 >= R2
    MOV R0, R8          @ move remainder to R0
    MOV PC, LR          @ return
 
_print:
    @MOV R7, LR          @ store LR since printf call overwrites
    
    LDR R0,=print_str   @ R0 contains formatted string address
    BL printf           @ call printf
    @MOV PC, R7          @ return
    
    
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
print_str:  .asciz  "The GCD of %d and %d is %d \n"

.end
