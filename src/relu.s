.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -12
    sw ra, 8(sp)
    sw s0, 4(sp)
    sw s1, 0(sp)

loop_start:
    li t0, 1
    blt a1, t0, relu_exp

    li t0, 0

loop_continue:
    beq t0, a1, loop_end
    slli s0, t0, 2
    add s1, a0, s0

    addi sp, sp, -8
    sw a0, 4(sp)
    sw t0, 0(sp)

    mv a0, s1
    jal set_max

    lw t0, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8

    addi t0, t0, 1
    j loop_continue

loop_end:
    # Epilogue
    lw s1, 0(sp)
    lw s0, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    jr ra

set_max:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw s0, 0(sp)

    lw s0, 0(a0)
    bge s0, zero, set_max_exit
    sw zero, 0(a0)

set_max_exit:
    lw s0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    jr ra

relu_exp:
    li a0, 36
    j exit
