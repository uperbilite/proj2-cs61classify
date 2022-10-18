.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -24
    sw ra, 20(sp)
    sw s0, 16(sp)
    sw s1, 12(sp)
    sw s2, 8(sp)
    sw s3, 4(sp)
    sw s4, 0(sp)


loop_start:
    li t0, 1
    blt a1, t0, argmax_exp

    li t0, 0
    li s3, 0        # result index
    lw s4, 0(a0)    # max element


loop_continue:
    beq t0, a1, loop_end
    slli s0, t0, 2
    add s1, a0, s0
    lw s2, 0(s1)

    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw t0, 0(sp)

    mv a0, s3
    mv a1, s4
    mv a2, t0
    mv a3, s2

    jal update_index
    mv s3, a0       # update index
    mv s4, a1       # update max element

    lw t0, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi t0, t0, 1
    j loop_continue


loop_end:
    mv a0, s3       # get return value
    # Epilogue
    lw s4, 0(sp)
    lw s3, 4(sp)
    lw s2, 8(sp)
    lw s1, 12(sp)
    lw s0, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    jr ra

update_index:
    addi sp, sp, -4
    sw ra, 0(sp)

    bge a1, a3, update_index_end
    mv a0, a2
    mv a1, a3

update_index_end:
    lw ra, 0(sp)
    addi sp, sp, 4

    jr ra

argmax_exp:
    li a0, 36
    j exit
