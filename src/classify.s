.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:

    li t0, 5
    blt a0, t0, bad_arg_num

    addi sp, sp, -52
    sw ra, 48(sp)
    sw s0, 44(sp)           # pointer to m0 in memory
    sw s1, 40(sp)           # pointer to rows of m0 in memory
    sw s2, 36(sp)           # pointer to columns of m0 in memory
    sw s3, 32(sp)           # pointer to m1 in memory
    sw s4, 28(sp)           # pointer to rows of m1 in memory
    sw s5, 24(sp)           # pointer to columns of m1 in memory
    sw s6, 20(sp)           # pointer to input in memory
    sw s7, 16(sp)           # pointer to rows of input in memory
    sw s8, 12(sp)           # pointer to columns of input in memory
    sw s9, 8(sp)            # pointer to h in memory
    sw s10, 4(sp)           # pointer to o in memory
    sw s11, 0(sp)           # return value of argmax(o)


    # Read pretrained m0
    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    li a0, 4
    jal malloc
    beq a0, zero, malloc_exp
    mv s1, a0
    li a0, 4
    jal malloc
    beq a0, zero, malloc_exp
    mv s2, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    lw a0, 4(a1)
    mv a1, s1
    mv a2, s2
    jal read_matrix
    mv s0, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12


    # Read pretrained m1
    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    li a0, 4
    jal malloc
    beq a0, zero, malloc_exp
    mv s4, a0
    li a0, 4
    jal malloc
    beq a0, zero, malloc_exp
    mv s5, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    lw a0, 8(a1)
    mv a1, s4
    mv a2, s5
    jal read_matrix
    mv s3, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12


    # Read input matrix
    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    li a0, 4
    jal malloc
    beq a0, zero, malloc_exp
    mv s7, a0
    li a0, 4
    jal malloc
    beq a0, zero, malloc_exp
    mv s8, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    lw a0, 12(a1)
    mv a1, s7
    mv a2, s8
    jal read_matrix
    mv s6, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12


    # Compute h = matmul(m0, input)
    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    lw t1, 0(s1)            # the height of m0, also the height of h
    lw t2, 0(s8)            # the width of input, also the width of h
    mul t0, t1, t2
    slli t0, t0, 2          # the bytes number to malloc
    mv a0, t0
    jal malloc
    beq a0, zero, malloc_exp
    mv s9, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    mv a0, s0
    lw a1, 0(s1)
    lw a2, 0(s2)
    mv a3, s6
    lw a4, 0(s7)
    lw a5, 0(s8)
    mv a6, s9
    jal matmul
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12


    # Compute h = relu(h)
    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    mv a0, s9
    lw t0, 0(s1)
    lw t1, 0(s8)
    mul a1, t0, t1
    jal relu
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12


    # Compute o = matmul(m1, h)
    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    lw t1, 0(s4)            # the height of m1, also the height of o
    lw t2, 0(s8)            # the width of h, also the width of o
    mul t0, t1, t2
    slli t0, t0, 2          # the bytes number to malloc
    mv a0, t0
    jal malloc
    beq a0, zero, malloc_exp
    mv s10, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    mv a0, s3
    lw a1, 0(s4)
    lw a2, 0(s5)
    mv a3, s9
    lw a4, 0(s1)
    lw a5, 0(s8)
    mv a6, s10
    jal matmul
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12


    # Write output matrix o
    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    lw a0, 16(a1)
    mv a1, s10
    lw a2, 0(s4)
    lw a3, 0(s8)
    jal write_matrix
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12


    # Compute and return argmax(o)
    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    mv a0, s10
    lw t0, 0(s4)
    lw t1, 0(s8)
    mul a1, t0, t1
    jal argmax
    mv s11, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12


    # If enabled, print argmax(o) and newline
    bne a2, zero, print_exit
    addi sp, sp, -8
    sw ra, 4(sp)
    sw a0, 0(sp)
    mv a0, s11
    jal print_int
    li a0, '\n'
    jal print_char
    lw a0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

print_exit:

    jal classify_free

    mv a0, s11

    lw s11, 0(sp)
    lw s10, 4(sp)
    lw s9, 8(sp)
    lw s8, 12(sp)
    lw s7, 16(sp)
    lw s6, 20(sp)
    lw s5, 24(sp)
    lw s4, 28(sp)
    lw s3, 32(sp)
    lw s2, 36(sp)
    lw s1, 40(sp)
    lw s0, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52

    jr ra


bad_arg_num:
    li a0, 31
    j exit

malloc_exp:
    li a0, 26
    j exit


classify_free:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw a0, 0(sp)

    mv a0, s0
    jal free
    mv a0, s1
    jal free
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free
    mv a0, s10
    jal free

    lw a0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    jr ra
