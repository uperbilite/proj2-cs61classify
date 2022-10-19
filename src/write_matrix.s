.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw ra, 16(sp)
    sw s0, 12(sp)       # file descriptor
    sw s1, 8(sp)        # number of rows' address in memory
    sw s2, 4(sp)        # number of columns' address in memory
    sw s3, 0(sp)        # number of element in matrix

    addi sp, sp, -16
    sw a0, 12(sp)
    sw a1, 8(sp)
    sw a2, 4(sp)
    sw a3, 0(sp)
    mv a0, a0
    li t0, 1
    mv a1, t0
    jal fopen
    li t0, -1
    beq a0, t0, fopen_exp
    mv s0, a0
    lw a3, 0(sp)
    lw a2, 4(sp)
    lw a1, 8(sp)
    lw a0, 12(sp)
    addi sp, sp, 16

    addi sp, sp, -16
    sw a0, 12(sp)
    sw a1, 8(sp)
    sw a2, 4(sp)
    sw a3, 0(sp)
    li a0, 4
    jal malloc
    mv s1, a0
    li a0, 4
    jal malloc
    mv s2, a0
    lw a3, 0(sp)
    lw a2, 4(sp)
    lw a1, 8(sp)
    lw a0, 12(sp)
    addi sp, sp, 16

    mv t1, a2
    mv t2, a3
    sw t1, 0(s1)        # write number of rows into memory
    sw t2, 0(s2)        # write number of column into memory

    addi sp, sp, -16
    sw a0, 12(sp)
    sw a1, 8(sp)
    sw a2, 4(sp)
    sw a3, 0(sp)
    mv a0, s0
    mv a1, s1
    li a2, 1
    li a3, 4
    jal fwrite
    li t0, 1
    bne a0, t0, fwrite_exp
    mv a0, s0
    mv a1, s2
    li a2, 1
    li a3, 4
    jal fwrite
    li t0, 1
    bne a0, t0, fwrite_exp
    lw a3, 0(sp)
    lw a2, 4(sp)
    lw a1, 8(sp)
    lw a0, 12(sp)
    addi sp, sp, 16

    addi sp, sp, -16
    sw a0, 12(sp)
    sw a1, 8(sp)
    sw a2, 4(sp)
    sw a3, 0(sp)
    mv a0, s0
    mv a1, a1
    mul s3, a2, a3
    mv a2, s3
    li a3, 4
    jal fwrite
    bne a0, s3, fwrite_exp
    lw a3, 0(sp)
    lw a2, 4(sp)
    lw a1, 8(sp)
    lw a0, 12(sp)
    addi sp, sp, 16

    addi sp, sp, -4
    sw a0, 0(sp)
    mv a0, s0
    jal fclose
    li t0, -1
    beq a0, t0, fclose_exp
    lw a0, 0(sp)
    addi sp, sp, 4

    # Epilogue
    lw s3, 0(sp)
    lw s2, 4(sp)
    lw s1, 8(sp)
    lw s0, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20

    jr ra


fopen_exp:
    li a0, 27
    j exit


fwrite_exp:
    li a0, 30
    j exit


fclose_exp:
    li a0, 28
    j exit
