/*
Finding GDC
Programming Assignment #2

*/

main:
	bl _scanf
	mov R4,R0
	
	bl _scanf
	mov R5,R0

	push {R4}
	push {R5}
	
	bl _mod_unsigned

	pop {R5}
	pop {R4}
	
	mov R3,R0
	mov R1,R4
	mov R2,R5

	bl _print
	bl _exit

_scanf:
	PUSH {LR}                @ store LR since scanf call overwrites
    	SUB SP, SP, #4          @ make room on stack
    	LDR R0, =format_str     @ R0 contains address of format string
    	MOV R1, SP              @ move SP to R1 to store entry on stack
    	BL scanf                @ call scanf
    	LDR R0, [SP]            @ load value at SP into R0
    	ADD SP, SP, #4          @ restore the stack pointer
    	POP {PC} 


_mod_unsigned:
    cmp R5, R4          @ check to see if R1 >= R2
    MOVHS R0, R4        @ swap R1 and R2 if R2 > R1
    MOVHS R4, R5        @ swap R1 and R2 if R2 > R1
    MOVHS R5, R0        @ swap R1 and R2 if R2 > R1
    MOV R0, #0          @ initialize return value
    B _modloopcheck     @ check to see if
    _modloop:
        ADD R0, R0, #1  @ increment R0
        SUB R4, R4, R5  @ subtract R2 from R1
    _modloopcheck:
        CMP R4, R5      @ check for loop termination
        BHS _modloop    @ continue loop if R1 >= R2
    MOV R0, R4          @ move remainder to R0
    MOV PC, LR          @ return

_print:
    MOV R6, LR          @ store LR since printf call overwrites
    LDR R0,=print_str   @ R0 contains formatted string address
    BL printf           @ call printf
    MOV PC, R6          @ return

_exit:  
    MOV R7, #4          @ write syscall, 4
    MOV R0, #1          @ output stream to monitor, 1
    MOV R2, #21         @ print string length
    LDR R1,=exit_str    @ string at label exit_str:
    SWI 0               @ execute syscall
    MOV R7, #1          @ terminate syscall, 1
    SWI 0               @ execute syscall

.data

format_str	.ascii	"%d"
print_str:
.ascii"%d mode %d = %d\n"
exit_str:
.ascii" Terminating!!!!!".\n"
