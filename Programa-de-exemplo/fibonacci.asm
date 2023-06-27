main:
    addi $1, $0, 10
    addi $2, $0, 0
    addi $3, $0, 1
loop:
    beq $1, $0, out
    dsp $2
    add $2, $2, $3

    beq $1, $0, out
    dsp $3
    add $3, $2, $3
    addi $1, $0, -1
    beq $0, $0, loop
out:
    beq $0, $0, main
