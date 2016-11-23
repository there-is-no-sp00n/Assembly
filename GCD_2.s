.global main
.func main

main:
  BL _scanf
  MOV R1, R0
  BL _scanf
  MOV R2, R0
  
  PUSH {R1}
  PUSH {R2}
  
  BL _mod_unsigned
  POP {R2}
  POP {R1}
  MOV R3, R0
  
  BL _print

_mod_unsigned:
    cmp R2, R1          @ check to see if R1 >= R2
    MOVHS R0, R1        @ swap R1 and R2 if R2 > R1
    MOVHS R1, R2        @ swap R1 and R2 if R2 > R1
    MOVHS R2, R0        @ swap R1 and R2 if R2 > R1
    MOV R0, #0          @ initialize return value
    B _modloopcheck     @ check to see if
    _modloop:
        ADD R0, R0, #1  @ increment R0
        SUB R1, R1, R2  @ subtract R2 from R1
    _modloopcheck:
        CMP R1, R2      @ check for loop termination
        BHS _modloop    @ continue loop if R1 >= R2
    MOV R0, R1          @ move remainder to R0
    MOV PC, LR          @ return
 
_print:
    MOV R4, LR          @ store LR since printf call overwrites
    LDR R0,=print_str   @ R0 contains formatted string address
    BL printf           @ call printf
    MOV PC, R4          @ return
    
    
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
print_str:  .asciz  "%d mod %d = %d \n"

.end
