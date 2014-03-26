.text
.globl main
    main:
    PrintInput:
        li $v0, 4 # print string syscall
        la $a0, inprint1
        syscall

        li $v0, 8 # read string syscall
        la $a0, mainstr
        
        # s0: for input string
        move $s0, $a0
        syscall

        li $v0, 4 # print string syscall
        la $a0, inprint2
        syscall

        li $v0, 8 # read string syscall
        la $a0, substr
        la $a1, 5 # limit string len as 4
        
        # s1: for input substring
        move $s1, $a0
        syscall

    StrLen:
        addi $t0, $zero, 0 # t0: i = 0
    
        StrLenLoop:
            lb $t1, 0($s0) 
            beq $t1, $zero, TEST
#beq $t1, $zero, PrintRevStr
            addi $t0, $t0, 1 # i = i + 1
            addi $s0, $s0, 1 # addr = addr + 1
            j StrLenLoop

        TEST:
            li $v0, 1
            move $a0, $t0
            syscall
            
        PrintRevStr:
            addi $t0, $t0, -1
            addi $s0, $s0, -1
            sw $s2, 0($sp)
            add $s2, $zero, $zero

            PrintRevStrLoop:
                beq $t0, $zero, StrLenExit
                sb $s2, 0($s0)
                addi $s2, $s2, 1
                addi $t0, $t0, -1
                addi $s0, $s0, -1

        StrLenExit:
            lw $s2, 0($sp)
            li $v0, 4 # print string syscall
            move $a0, $s0
            la $a0, revstr
            syscall
            jr $ra
                   
                

    PrintOutput:
        li $v0, 4 # print string syscall
        la $a0, outprint1
        syscall
        la $a0, outprint2
        syscall

        jr $ra
.data
    mainstr: .space 32 #offer a 32-byte space to store string
    substr: .space 32 #offer a 32-byte space to store string
    revstr: .space 32 #offer a 32-byte space to store string
    inprint1: .asciiz "Please enter main string:"
    inprint2: .asciiz "\nPlease enter pattern string:"
    outprint1: .asciiz "\nThe reversed main string:"
    outprint2: .asciiz "\nThe number of substrings to match pattern string:"
