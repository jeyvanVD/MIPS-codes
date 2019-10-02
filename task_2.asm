    		.data
size_prompt:	.asciiz "Enter list size: "
element_prompt:	.asciiz "Enter element "
min_str:	.asciiz "The minimum element in this list is "
colon_str:	.asciiz ": "
newline_str:	.asciiz "\n"
size:		.word 0
the_list:	.word 0
i:		.word 0
min:		.word 0
item:		.word 0

    		.text

la $ra, test

#size = int (input("Enter list size : "))
addi $v0, $0, 4		# puts in the call code 4 for printing a string
la $a0, size_prompt	
syscall
addi $v0, $0, 5
syscall
sw $v0, size

# the_list = [0] * size
addi $v0, $0, 9
lw $t0, size
addi $t1, $0, 4
mult $t0, $t1
mflo $t2
add $a0, $t2, $t1
syscall
sw $v0, the_list
lw $t0, size
sw $t0, ($v0)

#i = 0
sw $0, i

#while i < size:
loop:
lw $t0, i
lw $t1, size
slt $t2, $t0, $t1
beq $t2, $0, compute_min

#int ( input ( "Enter element "+ str ( i ) + " : " ) )
addi $v0, $0, 4
la $a0, element_prompt
syscall

addi $v0, $0, 1
lw $a0, i
syscall

addi $v0, $0, 4
la $a0, colon_str
syscall

addi $v0, $0, 5
syscall

#the_list[i] = int ( input ( "Enter element "+ str ( i ) + " : " ) )
lw $t0, the_list
lw $t1, i
addi $t2, $0, 4
mult $t1, $t2
mflo $t3
add $t3, $t3, $t2
add $t0, $t0, $t3
sw $v0, ($t0)

#i = i+1
lw $t0, i
addi $t0, $t0, 1
sw $t0, i

j loop

compute_min:

#if size>0:
lw $t0, size
slt $t1, $0, $t0
bne $t1, $0, continue
j exit

#min = the_list [ 0 ]
continue:
lw $t0, the_list
addi $t1, $0, 0
addi $t2, $0, 4
mult $t1, $t2
mflo $t3
add $t4, $t3, $t0
lw $t5, 4($t4)
sw $t5, min

#i = 1
addi $t0, $0,1
sw $t0, i

#while i < size:
loop2:
lw $t0, i
lw $t1, size
slt $t2, $t0, $t1
beq $t2, $0, endloop2

#item = the_list [ i ]
lw $t0, i
lw $t1, the_list
addi $t2, $0, 4
mult $t2, $t0
mflo $t3
add $t4, $t1, $t3
lw $t5 4($t4)
sw $t5, item

#if min > item:
lw $t0, min
lw $t1, item
slt $t2, $t0, $t1
beq $t2, $0, correct
j increment

#min = item
correct:
lw $t0, item
sw $t0, min

increment:
#i = i+1
lw $t0, i
addi $t0, $t0, 1
sw $t0, i

j loop2
endloop2:

#print ( "The minimum element in this_list is " + str (min) + "\n" )
addi $v0, $0, 4
la $a0, min_str
syscall

addi $v0, $0, 1
lw $a0, min
syscall

addi $v0, $0, 4
la $a0, newline_str
syscall

jr $ra
test:   
    # the_list = [2,4,-1] 
    # Allocate the required bytes on the heap via syscall and put the address in the_list
    addi $a0, $t0, 16  # 3 elements plus size = 16 bytes
    addi $v0, $0, 9    # allocate the bytes
    syscall
    sw $v0, the_list   # put start address in the_list
    # set global variable size to 3
    addi $t0, $0, 3    # $t0 = 3
    sw $t0, ($v0)      # start of the_list has correct size (3)
    sw $t0, size       # set the global variable size to the correct value so that the rest works
    # write the value of the elements 2, 4, -1
    addi $t0, $0, 2    # $t0 = 2
    sw $t0, 4($v0)     # the_list[0] = 2
    addi $t0, $0, 4    # $t0 = 4
    sw $t0, 8($v0)     # the_list[1] = 4
    addi $t0, $0, -1   # $t0 = -1
    sw $t0, 12($v0)    # the_list[2] = -1

    # go to compute the minimum of the_list = [2,4,-1] and come back
    jal compute_min    # should print -1

    # the_list = [2] 
    # Allocate the required bytes on the heap via syscall and put the address in the_list
    addi $a0, $t0, 8   # 1 elements plus size = 8 bytes
    addi $v0, $0, 9    # allocate the bytes
    syscall
    sw $v0, the_list   # put start address in the_list
    # set global variable size to 1
    addi $t0, $0, 1    # $t0 = 1
    sw $t0, ($v0)      # start of the_list has correct size (1)
    sw $t0, size       # set the global variable size to the correct value so that the rest works
    # write the value of the element 2
    addi $t0, $0, 2    # $t0 = 2
    sw $t0, 4($v0)     # the_list[0] = 2
    
    # go to compute the minimum of the_list = [2] and come back
    jal compute_min    # should print 2
    
    # the_list = [0,5] 
    # Allocate the required bytes on the heap via syscall and put the address in the_list
    addi $a0, $t0, 12  # 2 elements plus size = 12 bytes
    addi $v0, $0, 9    # allocate the bytes
    syscall
    sw $v0, the_list   # put start address in the_list
    # set global variable size to 2
    addi $t0, $0, 2    # $t0 = 2
    sw $t0, ($v0)      # start of the_list has correct size (2)
    sw $t0, size       # set the global variable size to the correct value so that the rest works
    # write the value of the elements  0,5
    sw $0, 4($v0)      # the_list[0] = 0
    addi $t0, $0, 5    # $t0 = 5
    sw $t0, 8($v0)     # the_list[1] = 5

    # go to compute the minimum of the_list = [0,5] and come back
    jal compute_min    # should print 0

    # the_list = [] 
    # Allocate the required bytes on the heap via syscall and put the address in the_list
    addi $a0, $t0, 4   # 0 elements plus size = 4 bytes 
    addi $v0, $0, 9    # allocate the bytes
    syscall
    sw $v0, the_list   # put start address in the_list
    # set global variable size to 0
    sw $0, ($v0)       # start of the_list has correct size (0)
    sw $0, size        # set the global variable size to the correct value so that the rest works
    
    # go to compute the minimum of the_list = [] and come back
    jal compute_min    # should print nothing

exit:
    # Exit the program
    addi $v0, $0, 10
    syscall
