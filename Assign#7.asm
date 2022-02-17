#####################################################################
# Assignment #7					Programmer: Rebecca Sieber
# Due Date: 5/9/21				Course: CSC 225 800
# Last Modified: 5/8/21
#####################################################################
# Functional Description:
# This program will contain 7 functions with a main function that
# ties them all together. The main program allocates memory onto
# the stack, loads data into the stack memory, calls functions
# to operate on the stack memory, pulls function data back off the 
#stack, prints said data into the console, and deallocates stack
# memory when the process is complete.
#
# FUNCTIONS:
# 1)	Search- searches an array for a given character and returns the
#	 integer location of the character in the array, or returns 
#	-1 if the character was not found.
# 2)	Scan- scans an array of ascii characters and tabulates the number
#	 of lowercase letters, uppercase letters, and decimal digits.
# 3)	Mul32- multiplies 2 integers, and returns the product. This function 
#	also sets a flag when binary overflow is detected. 
# 4)	Length- given a pointer to a string, calculates the length of the
#	 string and returns the corresponding integer.
# 5)	Create- given a pointer to a string, allocates new memory for a new string,
#	 copies the given string into the new string, and returns a pointer to the new string.
# 6)	Append- given pointers to 2 strings, allocates new memory for a new string,
#	 copies both the given strings into the new string (concatenates them).
# 7)	Print- given a pointer to the string, prints the string.

#####################################################################
# Pseudocode:
# std::cout << "Please enter a char to search for in array: " << std::endl;
# std::cin >> V;
# L = Search(X, N, V);
# std::cout << "The Value of L (location of value) is: " << L << std::endl;
#
# Scan(X, N, U, L, D);
# std::cout << "In the array there are: " << std::endl;
# std::cout << U << " uppercase letters." << std::endl;
# std::cout << L << " lowercase letters." << std::endl;
# std::cout << D << " decimal digits." << std::endl;
# std::cout << "Enter integer #1: ";
# std::cin >> n;
# std::cout << "Enter integer #2: ";
# std::cin >> m;
#
# mul32(m, n, p, f);										
# std::cout << "The product is " << p << std::endl;
# std::cout << "The error flag is "<< f << std::endl;
# std::cout << "The length of the string is: " << length(ptrX) << std::endl;
# std::cout << "The string printed is: ";	
# print(ptrX);
# print(Append(ptrX, ptrY));
# print(create(ptrX));
# return 0;
######################################################################
# Register Usage:
# $s0 - $s1 =  user input
# $v0 - $v1 = function output
######################################################################
	.data
	
string:		.asciiz "AbCd1234"
guess:		.asciiz "Please enter a character to guess: "
charloc:	.asciiz "\nThe location of the character you guessed is: "
intro3:   	.asciiz "Please input 2 integers hitting <enter> after each integer.\n"
productis:  	.asciiz "The product is: "
errorflag: 	.asciiz "Error: overflow has occured."
string:		.asciiz "AbCde12354"
lengthis:	.asciiz "The length of the string is: "
string:		.asciiz "AbCde12354"
makingcopy:	.asciiz "Making a copy of the string. "
copyloc:	.asciiz "The copied string is located: "
string:		.asciiz "AbCde12354"
string2:	.asciiz "!!!!"
appended:	.asciiz "Appended string: "

	.text
	
main:	
					#### SEARCH ####
	li $v0, 4			# System call to print string
 	la $a0, guess 			# loading "Please enter a character to guess: "
  	syscall				# Printing string
  	
	li $v0, 12			# system call to read character
    	syscall 			# reading character
	move $s1, $v0			# Loading user input into register $s0

	la $s0, string			# loading address of string into register 
	
	li $v0, 4			# System call to print string
 	la $a0, charloc 		# loading "The location of the character you guessed is: "
  	syscall				# Printing string

	jal search			# jumping to search function
	
	li $v0, 1			# System call to print integer
  	move $a0, $v1			# loading location of character
  	syscall				# printing location of character
  	
					#### SCAN ####
	la, $a0, string			# loading address of string to $a0	
	jal	scan			# calling scan function
	
	li 	$v0, 1	  		# system call to print integer
	move   	$a0, $s1     		# printing number of uppercase characters
	syscall		  		# printing integer to console

	li 	$v0, 1	  		# system call to print integer
	move 	$a0, $s2     		# printing number of lowercase characters
	syscall		  		# printing integer to console
	
	li 	$v0, 1	  		# system call to print integer
	move 	$a0, $s3     		# printing number of decimal digits
	syscall		  		# printing integer to console	
	
					#### MUL32 ####
	li $v0,4 			# System call to print String
	la $a0, intro3			# Loading string prompt "Enter 5 integers hitting <enter> after each one."
	syscall 			# print string
	
	li $v0,5			# system call to read integer N
    	syscall 			# reading integer
	move $s0, $v0			# Loading user input into register $s0
	
	li $v0,5			# system call to read integer M
    	syscall 			# reading integer
	move $s1, $v0			# Loading user input into register $s1

	jal Mul32			# loading multiplication function

	move $s0, $v0			# product is from function in $v0, loading into $s0
	move $s1, $v1			# overflow flag

	beqz $s1, printprod		# overflow flag = 0 so no overflow
	bltz $s1, error	

printprod:
	li $v0,4 			# System call to print String
	la $a0, productis		# Loading string prompt "The product is: "
	syscall 			# print string
	
	li $v0,1 			# System call to print integer
	add $a0, $s0, $zero		# Loading string "There were NO duplicates"
	syscall 			# printing string
	j continue
error:
 	li $v0,4 			# System call to print String
	la $a0, errorflag		# Loading string prompt "Error: overflow has occured."
	syscall 			# print string
	
continue:
					#### LENGTH FUNCTION ####
 	la $a0, string         	# Load address of string.
	jal length             	# Calling length function

	move $a1, $a0          	# Move address of string to $a1
	move $v1, $v0       		# Move length of string to $v1

	li $v0, 4			# System call to print string
 	la $a0, lengthis 		# Printing "The length of the string is: "
  	syscall				# Printing string

  	li $v0, 1			# System call to print integer
  	move $a0, $t0			# loading length of string to print
  	syscall				# printing length of string

					#### CREATE FUNCTION #####
	la $a0, string         	# Load address of source string.

	jal create            		# Calling create function to copy string
	
	li $v0, 4			# System call to print string
 	la $a0, makingcopy		# Printing "The length of the string is: "
  	syscall				# Printing string

  	li $v0, 4			# System call to print string
  	move $a0, $a1			# loading length of string to print
  	syscall				# printing string

					#### APPEND FUNCTION ####
 	la $a0, string         	# Load address of source string.
	la $a1, string2			# Loading address of source string in another register

	li $v0, 4			# System call to print string
 	la $a0, appended 		# Printing "Appended string: "
  	syscall				# Printing string

	jal append             	# Calling create function to copy string

  	li $v0, 4			# System call to print string
  	move $a0, $v1			# string to be printed
  	syscall				# printing string

					#### PRINT FUNCTION ####
	la $a1, string         	# Load address of string.
	jal print             		# Calling length function

					#### PROGRAM END ####
	li $v0, 10			# System call to terminate program
   	syscall				# Terminating program	
   	
#####################################################################
# Functional Description: Search (&X, N, V, L)
# This function will sequentially search an array (inconveniently) 
# named X of N bytes for the relative location L of value V. L is a
# number ranging from 1 to N. If the value V is not found in the arra
# y, the function will return -1
#####################################################################
# Pseudocode:
# int Search(char X[], int N, char V)
#{
#	for (int i = 0; i < N; i++)	//looping through each index of the array
#	{
#		if (X[i] == V)		//checking to see if array element matches value to match
#			return i+1;	//if they match, returning index+1
#	}
#	return -1;			//returns -1 if no match found
#}
######################################################################
# Register Usage:
# $s0 = string to be searched
# $s1 = character to search for
# $t0 = loop counter (=location of character)
# $t1 = current character in string being compared 
######################################################################
		.text	
search:	
	addi $sp, $sp,-4		# save space on the stack (push) for the $ra
	sw $ra, 0($sp)    		# save $ra
	li $t0, 1			# creating loop counter staring at 1 (first character in string)
	
loop1:	
	lb $t1, 0($s0) 			# loading next character in string
	beqz $t1, notfound 		# if next character is null branch to exit
	beq $t1, $s1, found		# if string character matches character guessed branch to found
	addi $s0, $s0, 1 		# increment the string character pointer
	addi $t0, $t0, 1		# incrementing loop counter
	j loop1 			# resume loop to find next character
found:
	move $v1, $t0			# setting return value to index of string where match was found
	j done1				# branching to done

notfound:
	addi $v1, $zero, -1		# setting return value to -1 to signify no match found
	j done1				# branching to done
	
done1:		
	lw 	$ra, 0($sp)   		# restore $ra
	addi 	$sp, $sp, 4 		# return the space on the stack (pop) 
	jr	$ra			# return to main program

#####################################################################
# Functional Description:
# Scan(&X, N, U, L, int& D) This function scans a string and tabulates
# how many uppercase letters, how many lowercase letters, and how many
# decimal digits are contained in the string
#####################################################################
# Pseudocode:
# U = 0;					//initializing uppercase letter counter
# L = 0;					//initializing lowercase letter counter
# D = 0;					//initializing decimal digit counter
# for (int i = 0; i < N; i++)			//looping through each element of array
# {
# if (int(X[i]) >= 65 && int(X[i]) <= 90)	//checking ASCII values for lowercase char
# ++U;						//increasing Uppercase counter
# else if (int(X[i]) >= 97 && int(X[i]) <= 122) //checking ASCII values for uppercase char
# ++L;						//increasing lowercase counter
# else if (int(X[i]) >= 48 && int(X[i]) <= 57)  //checking ASCII vaues for dec digits
# ++D;						//increasing decimal digit counter	
# }
######################################################################
# Register Usage:
# $s0 = holds each character of the string
# $s1 = holds # of uppercase chars
# $s2 = holds # of lowercase chars
# $s3 = holds # of decimal digits
# $t0 = ascii value of "0"
# $t1 = ascii value of "9"
# $t2 = ascii value of "A"
# $t3 = ascii value of "Z"
# $t4 = ascii value of "a"
# $t5 = ascii value of "z"	
######################################################################
scan:		
	addi $sp, $sp,-12 		# save space on the stack (push) for the $ra
	sw $ra, 0($sp)    		# save $ra

	li $s1, 0			# UPPERCASE counter
	li $s2, 0			# LOWERCASE counter
	li $s3, 0			# DECIMAL DIGIT counter	
	li $t0, 48 			# ascii value of "0"
	li $t1, 58			# ascii value of "9"	PLUS ONE
	li $t2, 65 			# ascii value of "A"
	li $t3, 91			# ascii value of "Z"    PLUS ONE
	li $t4, 97 			# ascii value of "a"
	li $t5, 123			# ascii value of "z"	PLUS ONE
	
loop2:
	lb $s0, 0($a0) 			# loading next character in string
	beqz $s0, done2 		# if next character is null branch to exit					
	blt $s0, $t1, decimal		# Checking to see if char is decimal digit	
	blt $s0, $t3, upper		# Checking to see if char is uppercase				
	blt $s0, $t5, lower		# Checking to see if char is lowercase
contloop:										
	addiu $s0, $s0, 1 		# increment the string character pointer
	j loop2 			# resume loop to find next character

done2:	
	lw 	$ra, 0($sp)      	# restore $ra
	addi 	$sp, $sp, 12  		# return the space on the stack (pop) 
	jr	$ra 

decimal:
	bge $s0, $t0, incrementD	# decimal digit detected, branch to incriment decimal counter
	j contloop			# returning to loop because its not a decimal digit	
incrementD:
	addi $s3, $s3, 1		# incrimenting decimal digit counter 
	j contloop			# returning to loop 


upper:
	bge $s0, $t2, incrementU	# decimal digit detected, branch to incriment decimal counter
	j contloop			# returning to loop because its not a decimal digit
incrementU:
	addi $s1, $s1, 1		# incrimenting decimal digit counter 
	j contloop			# returning to loop 


lower:
	bge $s0, $t4, incrementL	# decimal digit detected, branch to incriment decimal counter
	j contloop			# returning to loop because its not a decimal digit
incrementL:
	addi $s2, $s2, 1		# incrimenting decimal digit counter 
	j contloop			# returning to loop 

#####################################################################
# Functional Description:mul32
# multiplies 2 integers, and returns the product. This function also
# sets a flag when binary overflow is detected. 
#####################################################################
# Pseudocode:
#	f = 0;				//resetting error flag to false
# p = m * n;				//finding product of two integers
# if (m >= 0 && n > 0 && p <= 0)	//pos*pos = negative/zero -> ERROR
# f = 1;				//setting error flag to true
#
# if (m < 0 && n < 0 && p <= 0)	//neg*neg = negative/zero -> ERROR
# f = 1;				//setting error flag to true
#
# if (m > 0 && n < 0 && p >= 0)	//pos*neg = positive/zero -> ERROR
# f = 1;				//setting error flag to true
#
# if (m < 0 && n > 0 && p >= 0)	//neg*pos = positive/zero -> ERROR
# f = 1;				//setting error flag to true

######################################################################
# Register Usage:
# $s0-$s1 holds integers provided by main program
# $t0 holds lower 32 bits of multiplication
# $t1 holds comparison between integers being multiplied
# $t2 holds comparison between integers being multiplied and product
# $t3 holds upper 32 bits of product
# $v0 output register to product
# $v1 overflow flag
######################################################################
Mul32:
	addi $sp, $sp,-12 		# save space on the stack (push) for the $ra
	sw $ra, 0($sp)    		# save $ra

	mult	$s0,  $s1		# Multiplying M and N 
	mflo	$t0			# Loading lower 32 bits of product into new register
	mfhi	$t3		        # Loading upper 32 bits of product into new register
	xor	$t1,  $s0, $s1		# Comparing +/- signs between M and N 
	xor	$t2,  $t1, $t0		# Comparying +/- signs between product and M/N
	bltz	$t2,  overflow		# Overflow detected, branching to overflow
	bgez	$t2,  positive		# If M and N s signs differ, branch to positive case
	addiu	$t3,  $t3, 1		# Checking to see if all binary digits are 1
	
positive:	
	bnez	$t3,  overflow		# Overflow detected, branching to overflow
	move	$v0, $t0		# Saving Product to output register
	addi	$v1, $v1, 0 		# No overflow, setting error flag to 0 and saving to memory
	j	done3			# Returning to main program
overflow:
	li	$v1,  -1		# Setting error flag to -1 to signify overflow
	j	done3
done3:
	lw 	$ra, 0($sp)      	# restore $ra
	addi 	$sp, $sp, 12  		# return the space on the stack (pop) 
	jr	$ra 			# Returning to main program

#####################################################################
# Functional Description: LENGTH
# This function finds the length of a string given a pointer to the string
#####################################################################
# Pseudocode:
# int length = 0;
# while (*p != '\0')		//looping until the end of the string
#{
# length++;			//increasing length counter
# p++;				//moving pointer over 1
# }
# return length;
######################################################################
# Register Usage:
# $t0 = holds length counter
# $t1 = holds each character of string
# $a0 = holds address of string
######################################################################
length:
	addi $sp, $sp,-4	# save space on the stack (push) for the $ra
	sw $ra, 0($sp)    	# save $ra
	li $t0, 0		# initialize the length counter to zero
loop4:
	lb $t1, 0($a0) 		# loading next character in string
	beqz $t1, done4 	# if next character is null branch to exit
	addi $a0, $a0, 1 	# increment the string character pointer
	addi $t0, $t0, 1 	# increment the length count
	j loop4 		# resume loop to find next character
done4:
	lw $ra, 0($sp)    	# restore $ra
	addi $sp, $sp, 4  	# return the space on the stack (pop) 
	jr $ra			# return to main function
	
#####################################################################
# Functional Description:CREATE
# This function creates a new string given a pointer to an existing 
# string. It copies all of the data from the existing string to the
# new string and returns a pointer to the new string
#####################################################################
# Pseudocode:
# int length1 = length(p);
# char* ptr = new char[length1];
# std::copy(p, p + length1, ptr);
# return ptr;
######################################################################
# Register Usage:
# $v0 = holds new string
# $a0 = char in new string
# $a1 = char in current string
# $t1 = current character being copied
######################################################################
create:
	addi $sp, $sp,-4 	# save space on the stack (push) for the $ra
	sw $ra, 0($sp)    	# save $ra
	
	li $v0, 9           	# allocate memory for newstring
	li $a1, 80         	# enough memory fornew string
	syscall
	
	#li $t0, 0		# initialize the new string
loop4:
	lb $t1, 0($a0) 		# loading next character in string
	sb $t1, 0($a1)		# saving that character into new string
	beqz $t1, done5 	# if next character is null branch to exit
	addi $a0, $a0, 1 	# increment the string character pointer
	addi $a1, $a1, 1 	# increment the string character pointer
	j loop4 		# resume loop to find next character
done5:
	lw $ra, 0($sp)    	# restore $ra
	addi $sp, $sp, 4  	# return the space on the stack (pop) 
	jr $ra			# return to main function

#####################################################################
# Functional Description: APPEND
# This function appends 2 strings together into one new string and
# returns a pointer to the new string
#####################################################################
# Pseudocode:
# int length1 = length(p);
# int length2 = length(q);
# const int newLength = length1 + length2;
# char* ptr = new char[newLength];		//allocating memory for new string	 
# std::copy(p, p + length1, ptr);		//copying first string into new string
# std::copy(q, q + length2, ptr + length1);	//copying second string
# return ptr;
######################################################################
# Register Usage:
# $v1 = concatenated string to be returned by function 
# $a0 = first string pointer 
# $a1 = second string pointer
######################################################################
append:
	addi $sp, $sp,-4 	# save space on the stack (push) for the $ra
	sw $ra, 0($sp)    	# save $ra
	
  	lb $v1, 0($a1)    	# get char of second string
	beqz $v1, done6    	# if char is null, branch to done
	sb $v1, 0($a0)    	# storing current char into new string
	addi $a0,$a0,1      	# incrimenting destination pointer
   	addi $a1,$a1,1      	# incrimenting source pointer
    	j append		# looping back to do next character

done6:
	lw $ra, 0($sp)    	# restore $ra
	addi $sp, $sp, 4  	# return the space on the stack (pop) 
    	jr $ra            	# return back to main function

#####################################################################
# Functional Description: PRINT
# This function prints out a string given a pointer to the string
#####################################################################
# Pseudocode:
# while (*p != '\0')
# {
# std::cout << *p;
# p++;
# }
######################################################################
# Register Usage:
# $a1 = pointer to string
# $a0 = character in string
######################################################################  	
print:
	addi $sp, $sp,-4 	# save space on the stack (push) for the $ra
	sw $ra, 0($sp)    	# save $ra
		
	lbu $a0,($a1)      	# read the character from string
	beqz $a0, done7 	# if next character is null branch to done
	li $v0,11		# system call to print character
	syscall            	# Printing character
	addi $a1, $a1, 1 	# incrementing the string character pointer
	jal print		# jumping back beginning for next character

done7:
	lw $ra, 0($sp)    	# restore $ra
	addi $sp, $sp, 4  	# return the space on the stack (pop) 
	jr $ra			# return to main function
