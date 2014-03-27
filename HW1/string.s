.text
.globl main
    main:
    PrintInput:
        li $v0, 4 # print string syscall
        la $a0, inprint1
        syscall

        li $v0, 8 # read string syscall
        la $a0, mainstr
        syscall

        li $v0, 4 # print string syscall
        la $a0, inprint2
        syscall

        li $v0, 8 # read string syscall
        la $a0, substr
        la $a1, 5 # limit string len as 4
        syscall

    StrLen:
        la $a0, mainstr
        addi $t0, $zero, 0 # t0: i = 0
    
        StrLenLoop:
            add $t1, $t0, $a0
            lb $t2, 0($t1) 
            beq $t2, $zero, PrintRevStr
            addi $t0, $t0, 1 # i = i + 1
            j StrLenLoop
            
        PrintRevStr:
            addi $t0, $t0, -1
            addi $s0, $t0, 0 # save string len
            addi $t0, $t0, -1
            addi $t1, $zero, 0 # j = 0
            la $a2, revstr

            PrintRevStrLoop:
                add $t2, $a2, $t1
                add $t3, $a0, $t0
                lbu $t4, 0($t3)
                sb $t4, 0($t2) # a2[j] = a0[i]
                beq $t0, $zero, StrLenExit
                addi $t0, $t0, -1
                addi $t1, $t1, 1
                j PrintRevStrLoop

    StrLenExit:

    SubStrLen:
        la $a0, substr
        addi $t0, $zero, 0 # t0: i = 0
    
        SubStrLenLoop:
            add $t1, $t0, $a0
            lb $t2, 0($t1) 
            beq $t2, $zero, SubStrLenExit
            addi $t0, $t0, 1 # i = i + 1
            j SubStrLenLoop

    SubStrLenExit:
        addi $t0, $t0, -1
        addi $s1, $t0, 0 # save substring len

    CalSubStr:
        la $a0, mainstr
        la $a2, substr
        sub $s0, $s0, $s1 # i = main str len - sub str len
        addi $s2, $zero, 0
        addi $t0, $zero, 0 # i = 0, for mainstr start

        CalSubStrLoop1:
            addi $t1, $zero, 0 # j = 0, for substr start
            add $t2, $a0, $t0 # t2 = a0[i]

            CalSubStrLoop2:
                beq $s1, $t1, Match
                add $t2, $t2, $t1 # t2 = a0[i+j]
                lbu $t3, 0($t2)
                add $t4, $a2, $t1 # t4 = a2[j]
                lbu $t5, 0($t4)
                addi, $t1, $t1, 1
                beq $t3, $t5, CalSubStrLoop2
                j CalSubStrLoop2Exit

            Match:
                addi $s2, $s2, 1

            CalSubStrLoop2Exit:
                beq $t0, $s0, CalSubStrLoop1Exit  # if i = main string len, exit
                addi $t0, $t0, 1
                j CalSubStrLoop1
                
        CalSubStrLoop1Exit:
            

    PrintOutput:
        li $v0, 4 # print string syscall
        la $a0, outprint1
        syscall
        la $a0, revstr
        syscall
        la $a0, outprint2
        syscall
        li $v0, 1
        move $a0, $s2
        syscall
        jr $ra
.data
    mainstr: .space 32 #offer a 32-byte space to store string
    substr: .space 32 #offer a 32-byte space to store string
    revstr: .space 32 #offer a 32-byte space to store string
    inprint1: .asciiz "Please enter main string:"
    inprint2: .asciiz "\nPlease enter pattern string:"
    outprint1: .asciiz "\nThe reversed main string:"
    outprint2: .asciiz "\n\nThe number of substrings to match pattern string:"
