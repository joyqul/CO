.text
.globl main
    main:
    PrintInput:
        la $a0, inprint1
        syscall
        la $a0, newline
        syscall
        la $a0, inprint2
        syscall
        la $a0, newline
        syscall
    PrintOutput:
        la $a0, outprint1
        syscall
        la $a0, newline
        syscall
        la $a0, outprint2
        syscall
        la $a0, newline
        syscall
        jr $ra
.data
    str: .space 32 #offer a 32-byte space to store string
    newline: .asciiz "\n"
    inprint1: .asciiz "Please enter main string:"
    inprint2: .asciiz "Please enter pattern string"
    outprint1: .asciiz "The reversed main string:"
    outprint2: .asciiz "The number of substrings to match pattern string:"
