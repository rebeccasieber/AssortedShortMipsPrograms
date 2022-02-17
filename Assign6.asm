#####################################################################
# Assignment #5: Finding Determinate		Programmer: Rebecca Sieber
# Due Date: 4/25/21				Course: CSC 225 800
# Last Modified: 4/21/21
#####################################################################
# Functional Description:
# This function/program will compute the determinate of a two-by-two
# matrix (array) containing integers.
#####################################################################
# Pseudocode:
# MAIN FUNCTION:
# int matrixArray[2][2] = { 8, 10, 2, 5 }; 			//declaring 2x2 array with provided elements
# cout << "Deteriminate is: " << findDeterminate(matrixArray);  //calling determinate function and printing result
# return 0;							//exiting program successfully
# DETERMINATE FUNCTION:
# int elementA = some2x2Array[0][0];				//extracting matrix element a from array
# int elementB = some2x2Array[0][1];				//extracting matrix element b from array
# int elementC = some2x2Array[1][0];				//extracting matrix element c from array
# int elementD = some2x2Array[1][1];				//extracting matrix element d from array
# determinate = (elementA * elementD ) - (elementB * elementC);//calculating determinate = a*d - b*c
# return determinate;
#
######################################################################
# Register Usage:
# $v0: Calculates and Stores determinate value
# $a0: Stores 2, which is the column and row size of the matrix
# $a1: base address of arra/matrix in memory
# $s0: data extracted from matrix element a
# $s1: data extracted from matrix element b
# $s2: data extracted from matrix element c
# $s3: data extracted from matrix element d
# $t0: row index of element
# $t1: holds address in memory of element
# $t2: column index of element
######################################################################
	.data				# Data declaration section
someArray:	.word 8, 10		# a, b
		.word 2, 5             # c, d
size:		.word 2    		# since there are both 2 rows and 2 colums
		.eqv DATA_SIZE	4 	# defining constant. its 4 because I'm using integers

DetIs:		.asciiz	"The determinate is: "

	.text				# Executable code follows
main:

	li	$v0, 4			# system call code for print_string
	la	$a0, DetIs		# printing "Determinate is: "
	syscall				# print the prompt for matrix data element a
	
	la 	$a0, someArray 		# loading address of array into register
	lw 	$a1, size 		# loading the size of the row & column into register

	jal 	calcDet 		# Calling function to calculate determiante
	move 	$a0, $v0     		# will be storing the determinate in $v0
	li 	$v0, 1	  		# system call to print integer
	syscall		  		# printing integer to console

	li 	$v0, 10 		# system call to exit program
	syscall				# ending program

calcDet:

	#USING FORMULA TO FIND ADDRESS LOCATION OF MATRIX ELEMENTS. addr = baseAddr + (rowIndex*colSize+colIndex)*datasize
	
	#FINDING DATA AT MATRIX ELEMENT a
	li $t0, 0 			# setting row index to 0
	li $t2, 0 			# setting column index to 0
	mul $t1, $t0, $a1		# finding rowindext *columsize
	add $t1, $t1, $t2      	# adding column index
	mul $t1, $t1, DATA_SIZE  	# multiplying by datasize
	add $t1, $t1, $a0 		# adding base address. Now $t1 has address of  element a	
	lw $s0, ($t1)			# loading data from memory address into register $t2
	
	#FINDING DATA AT MATRIX ELEMENT d
	li $t0, 1 			# setting row index to 1
	li $t2, 1			# setting column index to 1
	mul $t1, $t0, $a1		# finding rowindext *columsize
	add $t1, $t1, $t2       	# adding column index
	mul $t1, $t1, DATA_SIZE  	# multiplying by datasize
	add $t1, $t1, $a0 		# adding base address. Now $t1 has address of  element d	
	lw $s1, ($t1)			# loading data from memory address into register $t2
		
	#FINDING DATA AT MATRIX ELEMENT b
	li $t0, 0  			# setting row index to 0
	li $t2, 1 			# setting column index to 1
	mul $t1, $t0, $a1		# finding rowindext *columsize
	add $t1, $t1, $t2       	# adding column index
	mul $t1, $t1, DATA_SIZE  	# multiplying by datasize
	add $t1, $t1, $a0 		# adding base address. Now $t1 has address of  element b
	lw  $s2, ($t1)			# loading data from memory address into register $t2
	
	#FINDING DATA AT MATRIX ELEMENT c
	li $t0, 1  			# setting row index to 1
	li $t2, 0 			# setting column index to 0
	mul $t1, $t0, $a1		# finding rowindext *columsize
	add $t1, $t1, $t2       	# adding column index
	mul $t1, $t1, DATA_SIZE  	# multiplying by datasize
	add $t1, $t1, $a0 		# adding base address. Now $t1 has address of  element c	
	lw $s3, ($t1)			# loading data from memory address into register $t2

	#COMPUTING DETERMINATE
	mul $v0, $s0, $s1 		# a*d	
	mul $v1, $s2, $s3		# b*c
	sub $v0, $v0, $v1		# (a*d)-(b*c)
	
	jr $ra				# jumping back to main program