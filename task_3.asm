#this file is made by Jeyvan Viriya (29802245) for task_4 in FIT 1008
			.data
size_prompt:	.asciiz "Enter list size: "
element_prompt:	.asciiz "Enter element "
colon_str:	.asciiz ": "
newline_str:	.asciiz "\n"
my_list:	.word	0

			.text
jal read_list #call the function read_list
sw $v0, my_list #store the value from the function into my_list
addi $sp, $sp, -4 #set space in the stack for my_list (1 block below $sp)
lw $t0, my_list #load my_list into $t0
sw $t0, ($sp) #store it back into $sp

jal get_minimum

addi $a0, $v0, 0
addi $v0, $0, 1
syscall
			
addi $v0, $0, 10
syscall
									
read_list:
#in the beginning of the function, we first have to save the old $fp and $ra for function return
addi $sp, $sp, -8
sw $fp, 0($sp)		# saves $fp into 0($sp)
sw $ra, 4($sp)		# saves $ra into 4($sp)
#now copy $sp into $fp
addi $fp, $sp, 0
#allocate local variables, in read_list there are 3 local variables
addi $sp, $sp, -12
#size 	  = 	-12($fp)
#the_list = 	-8($fp)
#i 	  = 	-4($fp)
la $a0, size_prompt
addi $v0, $0, 4
syscall

addi $v0, $0, 5
syscall
sw $v0, -12($fp)	# here, we store the user input size into -12($fp)

#next we do the_list
addi $v0, $0, 9
lw $t0, -12($fp)
sll $t0, $t0, 2
addi $a0, $t0, 4
syscall
sw $v0, -8($fp)		# here, we store the_list into -8($fp)
lw $t0,  -12($fp)	# we take the size of the list into $t0
sw $t0, ($v0)		# we store it into the first item in the list

#i = 0
sw $0, -4($fp)		# we store 0 into -4($fp) for the loop

#starts the loop
#while i < size:
while_loop:
lw $t0, -4($fp)
lw $t1, -12($fp)
slt $t2, $t0, $t1	
beq $t2, $0, return_the_list

#the we do the input of the elements required
la $a0, element_prompt
addi $v0, $0, 4
syscall

lw $a0, -4($fp)
addi $v0, $0, 1
syscall

la $a0, colon_str
addi $v0, $0, 4
syscall

addi $v0, $0, 5
syscall

#because we have to put the input into the list, we have to get the address of the list first.
lw $t0, -8($fp)
lw $t1, -4($fp)
sll $t1, $t1, 2
addi $t1, $t1, 4
add $t0, $t0, $t1
#now we have the address inside $t0
#then we store the value of the input into the address marked by $t0
sw $v0, ($t0)

#now we have to keep incrementing i so that the loop wont last forever
lw $t0, -4($fp)
addi $t0, $t0, 1
sw $t0, -4($fp)

#jummps back to the beginning of the loop
j while_loop

return_the_list:
#to return, we first put the_list into $v0
lw $v0, -8($fp)
#then remove the 3 local variables
addi $sp, $sp, 12
#next we load the old $ra and $fp
lw $ra, 4($fp)
lw $fp, ($fp)
#we normalise the stack by removing the $ra and $fp
addi $sp, $sp, 8
#now we jump back up
jr $ra

get_minimum:
#this is to allocate the memory for the results of the function
addi $sp, $sp, -8
sw $fp, ($sp)
sw $ra, 4($sp)
add $fp, $0, $sp

#this is to allocate the memory for the local variables
addi $sp, $sp, -16
#-4($fp) = size
#-8($fp) = min
#-12($fp) = i
#-16($fp) = item

#size = len ( the list )
lw $t0, 8($fp) #get the_list
lw $t1, ($t0) #get the first value of the_list
sw $t1, -4($fp) #store the value into the stack

#if size>0:
lw $t0, -4($fp) 
slt $t1, $0, $t0
beq $t1, $0, else

#min = the_list [ 0 ]
continue:

lw $t0, 8($fp)
addi $t1, $0, 0
addi $t2, $0, 4
mult $t1, $t2
mflo $t3
add $t4, $t3, $t0
lw $t5, 4($t4)

sw $t5, -8($fp)

#i = 1
addi $t0, $0, 1
sw $t0, -12($fp)

#while i < size:
loop2:
lw $t0, -12($fp)
lw $t1, -4($fp)
slt $t2, $t0, $t1
beq $t2, $0, endloop2

#item = the_list [ i ]
lw $t0, -12($fp)
lw $t1, 8($fp)
addi $t2, $0, 4
mult $t2, $t0
mflo $t3
add $t4, $t1, $t3
lw $t5 4($t4)
sw $t5, -16($fp)

#if min > item:
lw $t0, -8($fp)
lw $t1, -16($fp)
slt $t2, $t0, $t1
beq $t2, $0, correct
j increment

#min = item
correct:
lw $t0, -16($fp)
sw $t0, -8($fp)

increment:
#i = i+1
lw $t0, -12($fp)
addi $t0, $t0, 1
sw $t0, -12($fp)

j loop2
endloop2:

#exit the progam
end:
#return min
lw $v0, -8($fp)
#normalize the stack
addi $sp, $sp, 16
lw $ra, 4($fp)
lw $fp, ($fp)
addi $sp, $sp, 8
jr $ra

else:
#return min
addi $v0, $0,0
#normalize the stack
addi $sp, $sp, 16
lw $ra, 4($fp)
lw $fp, ($fp)
addi $sp, $sp, 8
jr $ra


