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
            addi $t0, $t0, -2
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

    PrintOutput:
        li $v0, 4 # print string syscall
        la $a0, outprint1
        syscall
        la $a0, revstr
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
    outprint2: .asciiz "\n\nThe number of substrings to match pattern string:"
