.text


main:	



# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	## Test code that calls procedure for part A
#	jal save_our_souls

	## morse_flash test for part B
#	 addi $a0, $zero, 0x42   # dot dot dash dot
#	 jal morse_flash
	
	## morse_flash test for part B
#	addi $a0, $zero, 0x37   # dash dash dash #0x37
#	jal morse_flash
		
	## morse_flash test for part B
#	addi $a0, $zero, 0x32  	# dot dash dot
#	jal morse_flash
			
	## morse_flash test for part B
#	 addi $a0, $zero, 0x11   # dash
#	 jal morse_flash	
	
	# flash_message test for part C
#	 la $a0, test_buffer
#	 jal flash_message
	
	# letter_to_code test for part D
	# the letter 'P' is properly encoded as 0x46.
#	 addi $a0, $zero, 'P'
#	 jal letter_to_code
	
	# letter_to_code test for part D
	# the letter 'A' is properly encoded as 0x21
#	 addi $a0, $zero, 'A'
#	 jal letter_to_code
	
	# letter_to_code test for part D
	# the space' is properly encoded as 0xff
#	 addi $a0, $zero, ' '
#	 jal letter_to_code
	
	# encode_message test for part E
	# The outcome of the procedure is here
	# immediately used by flash_message
	 la $a0, message01
	 la $a1, buffer01
	 jal encode_message
	 la $a0, buffer01
	 jal flash_message
	
	
	# Proper exit from the program.
	addi $v0, $zero, 10
	syscall

	
	
###########
# PROCEDURE
save_our_souls:
	addi, $sp, $s0, -4
	sw $ra, 0($sp)
	jal seven_segment_on                            #start dot 1
	jal delay_short
	jal seven_segment_off                           #end dot 1
	jal delay_long      
	jal seven_segment_on                            #start dot2
	jal delay_short
	jal seven_segment_off                           #end dot2
	jal delay_long
	jal seven_segment_on                            #start dot3
	jal delay_short
	jal seven_segment_off                           #end dot3
	jal delay_long
	jal seven_segment_on                            #start dash1
	jal delay_long
	jal seven_segment_off                           #end dash1
	jal delay_long
	jal seven_segment_on                            #start dash2
	jal delay_long
	jal seven_segment_off                           #end dash2
	jal delay_long
	jal seven_segment_on                            #start dash3
	jal delay_long
	jal seven_segment_off                           #end dash3
	jal delay_long
	jal seven_segment_on                            #start dot 1
	jal delay_short
	jal seven_segment_off                           #end dot 1
	jal delay_long
	jal seven_segment_on                            #start dot2
	jal delay_short
	jal seven_segment_off                           #end dot2
	jal delay_long
	jal seven_segment_on                            #start dot3
	jal delay_short
	jal seven_segment_off                           #end dot3
	                                                #dot,dot,dot,dash,dash,dash,dot,dot,dot as ordered chef
	lw $ra, 0($sp)
	addi, $sp, $s0, 4

	jr $ra

#dot procedure
dot:
	jal seven_segment_on                            #start dot 
	jal delay_short
	jal seven_segment_off                           #end dot 
	jal delay_long
	j dot_ret
	nop

#line procedure
dash:
	jal seven_segment_on                            #start dash
	jal delay_long
	jal seven_segment_off                           #end dash
	jal delay_long
	j dash_ret
	nop
	

#long wait procedure
big_delay:
	jal seven_segment_off                           #turns off for 3 longs
	jal delay_long
	jal delay_long
	jal delay_long
	j exit_flash_loop                               #becasue its a space character we move to end of procedure
	nop

# PROCEDURE (takes a0 for byte) converts single hex digit to ons and offs
morse_flash:
	addi, $sp, $sp -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	nop
	srl $s0, $a0 4                                  #s0 is now length of code or high nibble
	and $s1, $a0, 0x0f                              #s1 is now the last 4 digits or low nibble
	
morse_flash_loop:
	beq $s1, 0x0f, big_delay                        #but it works here. why???
	beq $s0 ,$zero, exit_flash_loop                 #count = 0 done
	addi $s0, $s0, -1                               #subtract 1 from length
	srlv $s2, $s1, $s0                              #shifts last 4 digits right by length
	and $s2, 1
	beq $s2, 0, dot			                 #checks if final digit is 0. that means a dot
dot_ret:
	nop                                             #checks if final didgit is 1. that means its a dash 
	beq $s2, 1, dash
dash_ret:
	nop
	j morse_flash_loop                              #loop until count down to zero
	nop
	
exit_flash_loop:

	nop
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	
	jr $ra

###########
# PROCEDURE converts a series of hex codes into ons and offs
flash_message:

	addi, $sp, $sp -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	move $s0, $a0                                   #save the bytes into s0
	lb $a0, 0($s0)                                  #load first byte into a0
	
flash_message_loop:

	jal morse_flash                                 # makes dots or lines
	nop
	addi $s0, $s0, 1                                # increment to next byte in the list
	lb $a0, 0($s0)                                  #load new byte into a0
	beq $a0, 0x00 flash_message_loop_exit           #if the current byte it 0x00 exit
	j flash_message_loop                            #go until null character is reached
	nop
		
flash_message_loop_exit:
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
		
	jr $ra
	
###########
# PROCEDURE
#long wait procedure
letter_big_delay:
	addi $s4, $zero, 0xff
	j letter_match_exit                             #becasue its a space character we move on
	nop
	
#dot procedure
letter_dot:
	sll $s4, $s4, 1                                 # shifts left so 0 is in leftmost position
	j letter_dot_ret

#line procedure seen these before but have to redo for different procedures
letter_dash:
	sll $s4, $s4, 1                                 #shifts left and adds 1 so 1 is in leftmost position
	addi $s4, $s4, 1
	j letter_dash_ret
#MAIN PROCEDURE FOR LETTER_TO_CODE #converts given letter to hexcode
letter_to_code:

	addi, $sp, $sp -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	la $s0, codes                                   #load up array
	li $s2, 0                                       # counter for out of bounds of array
	li $s3, 0                                       # dash+ dots counter and storage of most signifigant 4 bits
	li $s4, 0                                       # stores least signifigant 4 bits
	
letter_match_check:

	addi $s2, $s2, 1                                #increment counter
	beq $s2, 27, letter_match_exit                  #out of bounds of array so exit
	lb $s1, 0($s0)
	beq $a0, ' ' letter_big_delay  
	beq $a0, $s1 letter_length_finder               #compare given letter to letter in array if match, go find length of dots and dashes
	addi $s0, $s0, 8                                #letter didnt match so move to next letter
	j letter_match_check
	
letter_length_finder: #find the number of dots and dashes or length 0
	addi $s0, $s0, 1
	lb $s1, 0($s0)                                  # check byte, and counts up if its a dot or dash, ecits on zero
	beq $s1, $zero, letter_match
	addi $s3, $s3, 1 
	nop
	j letter_length_finder	
	
letter_match: #letters match and found length so go here
	nop
	sub $s0, $s0, $s3				 # puts the array pointer back at first position after letter
	mul $s3, $s3, 16                                #creates the first digit in the hexcode by multiplying 16 by length
	
letter_match_loop:
	
	lb $s1, 0($s0)                                  # loads single byte and checks if its zero '.' or '-' and changes binary code accordingly
	beq $s1, $zero, letter_match_exit
	beq $s1, '.' letter_dot
letter_dot_ret:
	beq $s1, '-' letter_dash
letter_dash_ret:
	addi $s0, $s0, 1
	j letter_match_loop
	
	
letter_match_exit:

	add $v0, $s3, $s4                               #adds most signifigant bits and least signifigant to ->
			                                ##create hexdigit and store at v0 as ordered by A2 readme
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
 
	addi $sp, $sp, 24
	
	jr $ra	


###########
# PROCEDURE
encode_message:

	addi, $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)
	
	move $s0, $a0                                   #changing address of array to s0 so i can pass a0 with single bytes
	li $a0, 0                                       #annnnd set to 0
encode_message_loop:
	nop
	lb $a0, 0($s0)                                  # other procedures need a0 with a byte so here it is
	jal letter_to_code
	nop
	sb $v0, 0($a1)                                  #stores returned byte in a1
	addi $s0, $s0, 1                                #increment the array
	lb $a0, 0($s0)                                  # load new byte
	beq $a0, 0, flash_encoded_message               # check if we reached the end of the message and exits if yes
	
	addi $a1, $a1, 1				 # set new spot in hexcode array
	j encode_message_loop                     
	
flash_encoded_message:
	nop
	move $a0, $a1                                   #move hexcode array into a0 so next procedure can use it
							 # super trouper is the best ABBA song fight me about it!
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)	
	addi, $sp, $sp, 16
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

#############################################
# DO NOT MODIFY ANY OF THE CODE / LINES BELOW

###########
# PROCEDURE
seven_segment_on:
	la $t1, 0xffff0010     # location of bits for right digit
	addi $t2, $zero, 0xff  # All bits in byte are set, turning on all segments
	sb $t2, 0($t1)         # "Make it so!"
	jr $31


###########
# PROCEDURE
seven_segment_off:
	la $t1, 0xffff0010	# location of bits for right digit
	sb $zero, 0($t1)	# All bits in byte are unset, turning off all segments
	jr $31			# "Make it so!"
	

###########
# PROCEDURE
delay_long:
	add $sp, $sp, -4	# Reserve 
	sw $a0, 0($sp)
	addi $a0, $zero, 600
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31

	
###########
# PROCEDURE			
delay_short:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	addi $a0, $zero, 200
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31




#############
# DATA MEMORY
.data
codes:
	.byte 'A', '.', '-', 0, 0, 0, 0, 0
	.byte 'B', '-', '.', '.', '.', 0, 0, 0
	.byte 'C', '-', '.', '-', '.', 0, 0, 0
	.byte 'D', '-', '.', '.', 0, 0, 0, 0
	.byte 'E', '.', 0, 0, 0, 0, 0, 0
	.byte 'F', '.', '.', '-', '.', 0, 0, 0
	.byte 'G', '-', '-', '.', 0, 0, 0, 0
	.byte 'H', '.', '.', '.', '.', 0, 0, 0
	.byte 'I', '.', '.', 0, 0, 0, 0, 0
	.byte 'J', '.', '-', '-', '-', 0, 0, 0
	.byte 'K', '-', '.', '-', 0, 0, 0, 0
	.byte 'L', '.', '-', '.', '.', 0, 0, 0
	.byte 'M', '-', '-', 0, 0, 0, 0, 0
	.byte 'N', '-', '.', 0, 0, 0, 0, 0
	.byte 'O', '-', '-', '-', 0, 0, 0, 0
	.byte 'P', '.', '-', '-', '.', 0, 0, 0
	.byte 'Q', '-', '-', '.', '-', 0, 0, 0
	.byte 'R', '.', '-', '.', 0, 0, 0, 0
	.byte 'S', '.', '.', '.', 0, 0, 0, 0
	.byte 'T', '-', 0, 0, 0, 0, 0, 0
	.byte 'U', '.', '.', '-', 0, 0, 0, 0
	.byte 'V', '.', '.', '.', '-', 0, 0, 0
	.byte 'W', '.', '-', '-', 0, 0, 0, 0
	.byte 'X', '-', '.', '.', '-', 0, 0, 0
	.byte 'Y', '-', '.', '-', '-', 0, 0, 0
	.byte 'Z', '-', '-', '.', '.', 0, 0, 0
	
message01:	.asciiz "A A A"
message02:	.asciiz "SOS"
message03:	.asciiz "WATERLOO"
message04:	.asciiz "DANCING QUEEN"
message05:	.asciiz "CHIQUITITA"
message06:	.asciiz "THE WINNER TAKES IT ALL"
message07:	.asciiz "MAMMA MIA"
message08:	.asciiz "TAKE A CHANCE ON ME"
message09:	.asciiz "KNOWING ME KNOWING YOU"
message10:	.asciiz "FERNANDO"

buffer01:	.space 128
buffer02:	.space 128
test_buffer:	.byte 0x30 0x37 0x30 0x00    # This is SOS
