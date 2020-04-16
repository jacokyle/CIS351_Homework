.text

#Kyle Jacobson
#Professor Bowman
#CIS 351-02
#20 November 2019

main:
	#arguments for the main method
	addi $a0, $0, 3 #immediate for a
	addi $a1, $0, 7 #immediate for b
	addi $a2, $0, 2 #immediate for c
	
	#variables for the wackySums method
	add $a3, $0, $a0 #i = a
	addi $s0, $0, 0 #sum = 0
	
	#storing the initial return address
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal wackySum
	
	#restore from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
		
	jr $ra #end of the program
	
wackySum:
	#check if i > b initially to finish
	bgt $a3, $a1, done 
	
	#store on the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal combineFour
	
	#restore from the stack.
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra #return to caller (main)
	
combineFour:
	#initializes the stack before combineFour
	addi $sp, $sp, -16
	sw $ra, 0($sp) 
	sw $a1, 4($sp) 
	sw $a2, 8($sp) 
	sw $a3, 12($sp) 

	#values in the print statements in wackySum
	addi $a0, $a3, 0 #i
	addi $a1, $a3, 1
	div $a1, $a1, 2 #(i + 1) / 2
	addi $a2, $a3, 2
	div $a2, $a2, 2 #(i + 2) / 2
	addi $a3, $a3, 3 #i + 3

	#values in the combineFour method
	addi $t0, $0, 2 #value to divide by later

	add $t1, $a0, $a1 #a + b
	add $t1, $t1, $a2 #(a + b) + c
	add $t1, $t1, $a3 #sum of arguments
	div $t1, $t0 #sum of arguments / 2
	mfhi $t2 #remainder of sum / 2
	beq $t2, 0, resume #if remainder = 0
	div $t1, $t1, 2 #else sum / 2

	j resume

resume:
	addi $v0, $t1, 0 

	#restores the stack after combineFour
	lw $ra, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp) 
	lw $a3, 12($sp) 
	addi $sp, $sp, 16

	add $a3, $a3, $a2 #incrementing i by c
	add $s0, $s0, $v0 #adding returned value to sum
	bgt $a3, $a1, done #check if i > b to finish
	blt $a3, $a1, combineFour #check if i < b to loop
	beq $a3, $a1, combineFour #check if i = b to loop
	jr $ra #return to caller (wackysum)

done: 
	addi $v0, $s0, 0 #total sum to return register
	jr $ra #return to caller (main)
