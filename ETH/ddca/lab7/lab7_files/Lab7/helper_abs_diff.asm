#
# Sum of Absolute Differences Algorithm
#
# Authors: 
#	X Y, Z Q 
#
# Group: ...
#

.text
main:


# Initializing data in memory... 
# Store in $s0 the address of the first element in memory
	lui     $s0, 0x0000 # Address of first element in the vector
	ori     $s0, 0x0000
	addi   $t0, $0, 5	# left_image[0]	
	sw      $t0, 0($s0)
	addi   $t0, $0, 16	# left_image[1]		
	sw      $t0, 4($s0)
	# TODO1: initilize the rest of the memory.
	# .....
	     
	     
	# TODO4: Loop over the elements of left_image and right_image
	addi $s1, $0, 0 # $s1 = i = 0
	addi $s2, $0, 9	# $s2 = image_size = 9

loop:

	# Check if we have traverse all the elements 
	# of the loop. If so, jump to end_loop:
	
	
	# ....
	
	
	# Load left_image{i} and put the value in the corresponding register
	# before doing the function call
	# ....
	
	
	# Load right_image{i} and put the value in the corresponding register
	
	# ....
	
	# Call abs_diff
	
	# ....
	
	#Store the returned value in sad_array[i]
	
	# ....
	
	
	# Increment variable i and repeat loop:
	
	# ...
	

	
end_loop:

	#TODO5: Call recursive_sum and store the result in $t2
	#Calculate the base address of sad_array (first argument
	#of the function call)and store in the corresponding register   
	
	# ...
	
	# Prepare the second argument of the function call: the size of the array
	
	#..... 
	
	# Call to funtion
	
	# ....
	  
	
	#Store the returned value in $t2
	
	# .....
	

end:	
	j	end	# Infinite loop at the end of the program. 


abs_diff:
	sub $t1, $a0, $a1
	sra $t2,$t1,31   
	xor $t1,$t1,$t2   
	sub $v0,$t1,$t2    

	jr $ra


# TODO3: Implement the recursive_sum rotuine here, or use the one provided
