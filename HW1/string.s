.text
.globl main
    main:
    PrintInput:
        li $v0, 4 # print string syscall
        la $a0, inprint1
        syscall

        li $v0, 8 # read string syscall
        la $a0, str
        syscall

        li $v0, 4 # print string syscall
        la $a0, inprint2
        syscall

        li $v0, 8 # read string syscall
        la $a0, str
        la $a1, 5 # limit string len as 4
        syscall

    PrintOutput:
        li $v0, 4 # print string syscall
        la $a0, outprint1
        syscall
        la $a0, outprint2
        syscall
        jr $ra
.data
    str: .space 32 #offer a 32-byte space to store string
    inprint1: .asciiz "Please enter main string:"
    inprint2: .asciiz "\nPlease enter pattern string:"
    outprint1: .asciiz "\nThe reversed main string:"
    outprint2: .asciiz "\nThe number of substrings to match pattern string:"
