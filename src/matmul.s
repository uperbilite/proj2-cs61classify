.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Error checks
    li t0, 1
    blt a1, t0, matmul_exp
    blt a2, t0, matmul_exp
    blt a4, t0, matmul_exp
    blt a5, t0, matmul_exp
    bne a2, a4, matmul_exp

    # Prologue
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    li t0, 0        # outer loop counter
    li t1, 0        # inner loop counter
    li t2, 0        # offset for m0 and m1


outer_loop_start:
    beq t0, a1, outer_loop_end
    mul t2, t0, a2
    slli t2, t2, 2
    add s0, a0, t2


inner_loop_start:
    beq t1, a5, inner_loop_end
    slli t2, t1, 2
    add s1, a3, t2

    addi sp, sp, -40
    sw t0, 36(sp)
    sw t1, 32(sp)
    sw t2, 28(sp)
    sw a0, 24(sp)
    sw a1, 20(sp)
    sw a2, 16(sp)
    sw a3, 12(sp)
    sw a4, 8(sp)
    sw a5, 4(sp)
    sw a6, 0(sp)

    mv a0, s0
    mv a1, s1
    mv a2, a4
    li a3, 1
    mv a4, a5

    jal dot

    mv s2, a0

    lw a6, 0(sp)
    lw a5, 4(sp)
    lw a4, 8(sp)
    lw a3, 12(sp)
    lw a2, 16(sp)
    lw a1, 20(sp)
    lw a0, 24(sp)
    lw t2, 28(sp)
    lw t1, 32(sp)
    lw t0, 36(sp)
    addi sp, sp, 40

    sw s2, 0(a6)
    addi a6, a6, 4

    addi t1, t1, 1
    j inner_loop_start


inner_loop_end:
    li t1, 0
    addi t0, t0, 1
    j outer_loop_start


outer_loop_end:
    # Epilogue
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    jr ra


matmul_exp:
    li a0, 38
    j exit