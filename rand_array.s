@ CSE 2312
@ RANDOM ARRAY SEARCH
@ PROGRAMMING HOMEWORK 3


.global main
.func main

main:
    BL _seedrand            @ seed random number generator with current time
    MOV R0, #0              @ initialze index variable

writeloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}               @ backup iterator before procedure call
    PUSH {R2}               @ backup element address before procedure call
    BL _getrand             @ get a random number
    POP {R2}                @ restore element address
    STR R0, [R2]            @ write the address of a[i] to a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration

writedone:
    MOV R0, #0              @ initialze index variable

readloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
    
readdone:
    MOV R0, #0              @ initialize the index for get_max
    LDR R1, =a              @ starting address of array
    LDR R3, [R1]            @ dereference the starting value of the array into R3
    BL get_max              @ branch to get_max

get_max:
    CMP R0, #10             @ check to see if done iterating through all the items
    MOVEQ R1, R3            @ if so, move the max (R3) to R1 for printf
    BEQ _print_max          @ branch to _print_max
    LDR R1, =a              @ load the starting address of the array
    LSL R2, R0, #2          @ this is the offset
    ADD R2, R1, R2          @ go to the offset
    LDR R1, [R2]            @ dereference the offset into R1
    CMP R1, R3              @ compare R1 and R3
    MOVHS R3, R1            @ if R1 > R3, move R1 to R3
    ADD R0, R0, #1          @ increment the index
    B get_max               @ loop back up
    
    
max_done:
    MOV R0, #0              @ initialize the index of the array
    LDR R1, =a              @ load the starting address of the array
    LDR R3, [R1]            @ dereference the starting address of the array to R3
    BL get_min              @ branch to get_min
    
    
get_min:
    CMP R0, #10             @ check to see if done iterating through the loop
    MOVEQ R1, R3            @ if so, prepare R1 for printf
    BEQ _print_min          @ branch to print_min
    LDR R1, =a              @ load the starting address of the array to R1
    LSL R2, R0, #2          @ get the offset
    ADD R2, R1, R2          @ go to the offset
    LDR R1, [R2]            @ dereference the offset into R1
    CMP R1, R3              @ compare R1 and R3
    MOVLS R3, R1            @ if R1 < R3, move R1 to R3
    ADD R0, R0, #1          @ increment the index
    B get_min               @ loop back up

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
    
_print_max:
    LDR R0, =print_max      @ load the print_max string to R0
    BL printf               @ call on printf
    B max_done              @ branch to max_done to initialize the min value computation
    
_print_min:
    LDR R0, =print_min      @ load the print_min string to R0
    BL printf               @ call on printf
    B _exit                 
    

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
    
_seedrand:
    PUSH {LR}               @ backup return address
    MOV R0, #0              @ pass 0 as argument to time call
    BL time                 @ get system time
    MOV R1, R0              @ pass sytem time as argument to srand
    BL srand                @ seed the random number generator
    POP {PC}                @ return 
    
_getrand:
    PUSH {LR}               @ backup return address
    BL rand                 @ get a random number
    MOV R1, R0              @ give R1 the random number
    MOV R2, #1000           @ give R2 1000 to mod with
    BL _mod_unsigned        @ branch to _mod_unsigned
    POP {PC}                @ return 
    

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
    MOV PC, LR 
   
.data

.balign 4
a:              .skip       40
printf_str:     .asciz      "a[%d] = %d\n"
exit_str:       .ascii      "Terminating program.\n"
print_max:      .asciz      "The max is %d. \n"
print_min:      .asciz      "The min is %d. \n"
get_search:     .asciz      "Enter search value: %d\n"

.end
