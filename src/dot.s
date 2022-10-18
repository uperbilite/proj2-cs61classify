.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    addi sp, sp, -20
    sw ra, 16(sp)
    sw s0, 12(sp)
    sw s1, 8(sp)
    sw s2, 4(sp)
    sw s3, 0(sp)


loop_start:
    li t0, 1
    blt a2, t0, dot_exp1
    blt a3, t0, dot_exp2
    blt a4, t0, dot_exp2

    li t0, 0
    li t1, 0        # arr0 index
    li t2, 0        # arr1 index
    li s0, 0        # sum


loop_continue:
    beq t0, a2, loop_end

    slli t3, t1, 2
    add t4, a0, t3
    lw s1, 0(t4)
    slli t5, t2, 2
    add t6, a1, t5
    lw s2, 0(t6)

    mul s3, s1, s2
    add s0, s0, s3

    add t1, t1, a3
    add t2, t2, a4
    addi t0, t0, 1
    j loop_continue


loop_end:
    mv a0, s0
    # Epilogue
    lw s3, 0(sp)
    lw s2, 4(sp)
    lw s1, 8(sp)
    lw s0, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20

    jr ra


dot_exp1:
    li a0, 36
    j exit


dot_exp2:
    li a0, 37
    j exit
