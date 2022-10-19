.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)        # file descriptor
    sw s1, 4(sp)        # matrix pointer
    sw s2, 0(sp)        # matrix element num


    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    mv a0, a0
    mv a1, zero
    jal fopen
    li t0, -1
    beq a0, t0, fopen_exp
    mv s0, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    mv a0, s0
    mv a1, a1
    li a2, 4
    jal fread           # read row
    li t0, 4
    bne a0, t0, fread_exp
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    mv a0, s0
    mv a1, a2
    li a2, 4
    jal fread           # read column
    li t0, 4
    bne a0, t0, fread_exp
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    lw t0, 0(a1)
    lw t1, 0(a2)
    mul s2, t0, t1
    slli s2, s2, 2
    mv a0, s2
    jal malloc
    beq a0, zero, malloc_exp
    mv s1, a0
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)
    mv a0, s0
    mv a1, s1
    mv a2, s2
    jal fread
    bne a0, s2, fread_exp
    lw a2, 0(sp)
    lw a1, 4(sp)
    lw a0, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -4
    sw a0, 0(sp)
    mv a0, s0
    jal fclose
    li t0, -1
    beq a0, t0, fclose_exp
    lw a0, 0(sp)
    addi sp, sp, 4

    mv a0, s1

    # Epilogue
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    jr ra


fopen_exp:
    li a0, 27
    j exit


fread_exp:
    li a0, 29
    j exit


malloc_exp:
    li a0, 26
    j exit


fclose_exp:
    li a0, 28
    j exit
