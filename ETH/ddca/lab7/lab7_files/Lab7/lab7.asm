#
# Calculate sum from A to B.
#
# Authors: 
#	X Y, Z Q 
#
# Group: ...
#

.text
main:
	#
	# Your code goes here...
	#
	addi $t0, $zero, 0
	addi $t1, $zero, 100
	addi $t7, $zero, 1
	addi $t1, $t1 , 1
	
loop_a:
	add $t2, $t0, $t2
	add $t0, $t0, $t7
	slt $t6, $t0, $t1
	beq $t6, $t7, loop_a
	
	# Put your sum S into register $t2
end:	
	j	end	# Infinite loop at the end of the program. 
