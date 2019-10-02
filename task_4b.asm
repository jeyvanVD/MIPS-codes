#this file is made by Jeyvan Viriya (29802245) for task_4 in FIT 1008
			.data
the_list: .word 5, 6, 5, 9, 2, -1
			.text
la $t0, the_list
addi $sp, $sp, -4
sw $t0,	($sp)
jal bubbleSort

addi $v0, $0, 10
syscall


bubbleSort:
#this is to allocate the memory for the results of the function
addi $sp, $sp, -8
sw $fp, ($sp)
sw $ra, 4($sp)
add $fp, $0, $sp

#this is to allocate the memory for the local variables
addi $sp, $sp, -16
#we initialize 0 in -4(fp) for listLength
#we initialize 0 in -8(fp) for i
#we initialize 0 in -12(fp) for x
#we initialize 0 in -16(fp) for temp

#listLength = len(the_list)
lw $t0,8($fp)
lw $t1,($t0)
sw $t1, -4($fp)


#i = 0
sw $0, -8($fp)

#x = -1
addi $t0, $0, -1
sw $t0, -12($fp)

#while i<listLength:
whileloop:

lw $t0, -8($fp)
lw $t1, -4($fp)
slt $t2, $t0, $t1
beq $t2, $0, endloop	

#while x < i:
whileloop2:

lw $t0, -12($fp)
lw $t1, -8($fp)
slt $t2, $t0, $t1
beq $t2, $0, endloop2


#if the_list[x] > the_list[x+1]:
lw $t0, 8($fp) #this is the_list
lw $t1, -12($fp) #this is x

addi $t3, $0, 4
mult $t3, $t1
mflo $t4
add $t5, $t0, $t4
lw $t6, 4($t5)#the_list[x] is in $t6

lw $t0, 8($fp) #this is the_list
lw $t1, -12($fp) #this is x
addi $t2, $t1, 1 #this is x+1
addi $t3, $0, 4
mult $t3, $t2
mflo $t7
add $t8, $t0, $t7
lw $t9, 4($t8)#the_list[x+1] is in $t9

slt $t0, $t9, $t6
beq $t0, $0, incrementx

ifcondition:

lw $t0, 8($fp) #this is the_list
lw $t1, -12($fp) #this is x

addi $t3, $0, 4
mult $t3, $t1
mflo $t4
add $t5, $t0, $t4
lw $t6, 4($t5)#the_list[x] is in $t6

lw $t0, 8($fp) #this is the_list
lw $t1, -12($fp) #this is x
addi $t2, $t1, 1 #this is x+1
addi $t3, $0, 4
mult $t3, $t2
mflo $t7
add $t8, $t0, $t7
lw $t9, 4($t8)#the_list[x+1] is in $t9

#temp = the_list[x]
sw $t6, -16($fp)
#the_list[x]=the_list[x+1]
sw $t9, 4($t5)
#the_list[x+1] = temp
lw $t0, -16($fp)
sw $t0, 4($t8)

#x = x-1
lw $t0, -12($fp)
addi $t0, $0, -1
sw $t0, -12($fp)

incrementx:
#x = x+1
lw $t0, -12($fp)
addi $t0, $t0, 1
sw $t0, -12($fp)

j whileloop2
endloop2: 

incrementi:
#i = i+1
lw $t0, -8($fp)
addi $t0, $t0, 1
sw $t0, -8($fp)

j whileloop

endloop:
sw	$0,	-8($fp)

printloop:
lw	$t0,	-8($fp)
lw	$t1,	-4($fp)
slt	$t2,	$t0,	$t1
beq	$t2,	$0,	endfunction

lw	$t0,	8($fp)	#the_list
lw	$t1,	-8($fp)	#i
addi $t2, $0, 4
mult $t2, $t1
mflo $t3
add $t4, $t0, $t3
lw $t5, 4($t4)#the_list[i] is in $t6

addi	$a0,	$t5,	0
addi	$v0,	$0,	1
syscall

lw	$t0,	-8($fp)
addi	$t0,	$t0,	1
sw	$t0,	-8($fp)

j printloop

endfunction:
addi $sp, $sp, 16
lw $ra, 4($fp)
lw $fp, ($fp)
addi $sp, $sp, 8
jr $ra
