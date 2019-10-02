		.data
a:		.word		0
be:		.word		0
result:		.word		0
endline:	.asciiz		"\n"

		.text
test:
    # test a = 11, b = 50, result should be 4 (b//a)
    addi $t0, $0, 11   # $t0 = 11
    sw $t0, a          # a = 11
    addi $t0, $0, 50   # $t0 = 50
    sw $t0, be          # b = 50
    jal if              # execute the if and come back
    
    # test a = -1, b = -1, result should be 1 (a*b)
    addi $t0, $0, -1   # $t0 = -1
    sw $t0, a          # a = -1
    sw $t0, be         # b = -1
    jal if              # execute the if and come back
    
    # test a = 20, b = 13, result should be 6 (b//2)
    addi $t0, $0, 20   # $t0 = 20
    sw $t0, a          # a = 20
    addi $t0, $0, 13   # $t0 = 13
    sw $t0, be          # b = 13
    jal if             # execute the if and come back
    
    addi $t0, $0, 4
    addi $t1, $0, 5
    sw $t0, a
    sw $t1, be
    jal if
    
    j exit             # finish the program
    
if: 
lw $t0, a
slt $t1, $t0, $0
beq $t1, $0, check_and
j elif		#refers to elif

check_and:
lw $t0,a
lw $t1,be
slt $t2, $t1, $t0
beq $t2, $0, calculate_first_result
beq $t0, $t1, calculate_first_result
j elif

calculate_first_result:
lw $t0, a
lw $t1, be
div $t1, $t0
mflo $t1
sw $t1, result
j print_result

elif:
lw $t0, a
lw $t1, be
beq $t0, $t1, calculate_second_result
slt $t2, $0, $t1
beq $t2, $0, calculate_second_result
j else

calculate_second_result:
lw $t0, a
lw $t1, be
mult $t0, $t1
mflo $t0
sw $t0, result

j print_result

else:
lw $t0, be
srl $t0, $t0, 1
sw $t0, result

j print_result

print_result:
lw $a0, result
addi $v0, $0, 1
syscall
la $a0, endline
addi $v0, $0, 4
syscall

jr $ra

exit:
addi $v0, $0, 10
syscall








