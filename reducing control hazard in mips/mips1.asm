.data
    prompt_N: .asciiz "Enter the number of elements (N) for array A (1-10): "
    prompt_Y: .asciiz "Enter the number of elements (Y) for array B (1-10): "
    input_number: .asciiz "Enter a number: "
    count_odd: .asciiz "Count of odd numbers in A = "
    smallest: .asciiz "Smallest value = "
    largest: .asciiz "Largest value = "
    array_C: .asciiz "Array C = "
    done_msg: .asciiz "Done, Your Name, ID\n"
    newline: .asciiz "\n"
    
    array_A: .space 40   # Reserve space for 10 integers
    array_B: .space 40   # Reserve space for 10 integers
    array_C: .space 40   # Reserve space for 10 integers
    size_A: .word 0
    size_B: .word 0

.text
main:
    # Step 1: Read N
    la $a0, prompt_N
    li $v0, 4
    syscall
read_N:
    li $v0, 5           # Read integer
    syscall
    move $t0, $v0       # Store N in $t0
    blez $t0, invalid_N
    bgt $t0, 10, invalid_N
    sw $t0, size_A
    j read_array_A
invalid_N:
    la $a0, prompt_N
    li $v0, 4
    syscall
    j read_N

# Step 2: Read elements for array A
read_array_A:
    la $t1, array_A     # Load base address of array A
    lw $t2, size_A      # Load size of array A (N)
    li $t3, 0           # Counter for array A
read_A_loop:
    beq $t3, $t2, read_Y_prompt
    la $a0, input_number
    li $v0, 4
    syscall
    li $v0, 5           # Read integer
    syscall
    sw $v0, 0($t1)      # Store input in array A
    addi $t1, $t1, 4    # Move to next position in array
    addi $t3, $t3, 1    # Increment counter
    j read_A_loop

# Step 3: Read Y
read_Y_prompt:
    la $a0, prompt_Y
    li $v0, 4
    syscall
read_Y:
    li $v0, 5           # Read integer
    syscall
    move $t0, $v0       # Store Y in $t0
    blez $t0, invalid_Y
    bgt $t0, 10, invalid_Y
    sw $t0, size_B
    j read_array_B
invalid_Y:
    la $a0, prompt_Y
    li $v0, 4
    syscall
    j read_Y

# Step 4: Read elements for array B
read_array_B:
    la $t1, array_B     # Load base address of array B
    lw $t2, size_B      # Load size of array B (Y)
    li $t3, 0           # Counter for array B
read_B_loop:
    beq $t3, $t2, count_odds
    la $a0, input_number
    li $v0, 4
    syscall
    li $v0, 5           # Read integer
    syscall
    sw $v0, 0($t1)      # Store input in array B
    addi $t1, $t1, 4    # Move to next position in array
    addi $t3, $t3, 1    # Increment counter
    j read_B_loop

# Step 5: Count odd numbers in array A
count_odds:
    la $t1, array_A     # Base address of array A
    lw $t2, size_A      # Size of array A
    li $t3, 0           # Counter for odd numbers
    li $t4, 0           # Index
count_odds_loop:
    beq $t4, $t2, find_min_max
    lw $t5, 0($t1)      # Load current element
    andi $t6, $t5, 1    # Check if odd
    beq $t6, 0, not_odd
    addi $t3, $t3, 1    # Increment odd counter
not_odd:
    addi $t1, $t1, 4    # Move to next element
    addi $t4, $t4, 1    # Increment index
    j count_odds_loop

print_odd_count:
    la $a0, count_odd
    li $v0, 4
    syscall
    move $a0, $t3
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall

# Step 6: Find smallest and largest values in arrays A and B
find_min_max:
    # Initialize smallest and largest with the first element of A
    la $t1, array_A
    lw $t2, 0($t1)
    move $t7, $t2        # Smallest
    move $t8, $t2        # Largest
    # Check all elements of A
    lw $t3, size_A
    li $t4, 0
find_min_A:
    beq $t4, $t3, find_min_B
    lw $t2, 0($t1)
    blt $t2, $t7, update_smallest_A
    bgt $t2, $t8, update_largest_A
    j next_A
update_smallest_A:
    move $t7, $t2
    j next_A
update_largest_A:
    move $t8, $t2
next_A:
    addi $t1, $t1, 4
    addi $t4, $t4, 1
    j find_min_A

# Check all elements of B
find_min_B:
    la $t1, array_B
    lw $t3, size_B
    li $t4, 0
find_min_B_loop:
    beq $t4, $t3, print_min_max
    lw $t2, 0($t1)
    blt $t2, $t7, update_smallest_B
    bgt $t2, $t8, update_largest_B
    j next_B
update_smallest_B:
    move $t7, $t2
    j next_B
update_largest_B:
    move $t8, $t2
next_B:
    addi $t1, $t1, 4
    addi $t4, $t4, 1
    j find_min_B_loop

print_min_max:
    la $a0, smallest
    li $v0, 4
    syscall
    move $a0, $t7
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall

    la $a0, largest
    li $v0, 4
    syscall
    move $a0, $t8
    li $v0, 1
    syscall
    la $a0, newline
    li $v0, 4
    syscall

# Step 7: Copy unique common elements to C and sort
find_common:
    # TODO: Implement logic for finding common elements, storing in C, and sorting

# Print "Done" message
exit_program:
    la $a0, done_msg
    li $v0, 4
    syscall
    li $v0, 10
    syscall
