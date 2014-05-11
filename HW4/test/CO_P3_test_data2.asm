
addi r4,zero,4
addi r9,zero,1
jal 5
j 30

fib:
addi sp,sp,-12
sw ra,0(sp)
sw s0,4(sp)
sw s1,8(sp)
add s0,a0,zero
beq s0,zero,re1
beq s0,t1,re1
addi a0,s0,-1
jal fib
add s0,zero,v0
addi a0,s0,-2
jal fib
add v0,v0,s1

exitfib:
lw ra,0(sp)
lw s0,4(sp)
lw s1,8(sp)
addi sp,sp,12
jr ra			//function callµ²§ô

re1:
addi v0,zero,1
j exitfib

final:
