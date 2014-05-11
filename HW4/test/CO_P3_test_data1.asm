addi r1 r0 1
addi r2 r0 2
addi r3 r0 3
addi r4 r0 4
addi r5 r0 5
jump 8
addi r1 r0 31
addi r2 r0 63
sw r1 0(r0)
sw r2 4(r0)
lw r6 0(r0)
lw r7 0(r4)
add r8 r1 r3
lw r9 4(r1)
