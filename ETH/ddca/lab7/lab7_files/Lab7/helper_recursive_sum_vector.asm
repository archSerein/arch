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


# TODO2: Implement the abs_diff rotuine here, or use the one provided


# TODO3: Implement the recursive_sum rotuine here, or use the one provided

recursive_sum:    
	addi $sp, $sp, -8       # Adjust sp
        addi $t0, $a1, -1       # Compute size - 1
        sw   $t0, 0($sp)        # Save size - 1 to stack
        sw   $ra, 4($sp)        # Save return address
        bne  $a1, $zero, else   # size == 0 ?
        addi  $v0, $0, 0        # If size == 0, set return value to 0
        addi $sp, $sp, 8        # Adjust sp
        jr $ra                  # Return

else:     
	add  $a1, $t0, $0		#update the second argument
        jal   recursive_sum 
        lw    $t0, 0($sp)       # Restore size - 1 from stack
        sll  $t1, $t0, 2        # Multiply size by 4
        add   $t1, $t1, $a0     # Compute & arr[ size - 1 ]
        lw    $t2, 0($t1)       # t2 = arr[ size - 1 ]
        add   $v0, $v0, $t2     # retval = $v0 + arr[size - 1]
        lw    $ra, 4($sp)       # restore return address from stack         
        addi $sp, $sp, 8        # Adjust sp
        jr $ra                  # Return