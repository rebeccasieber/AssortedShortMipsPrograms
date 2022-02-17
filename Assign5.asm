#####################################################################
# Assignment #5: Check Book		Programmer: Rebecca Sieber
# Due Date: 4/28/21			Course: CSC 225 040
# Last Modified: 4/16/21
#####################################################################
# Functional Description:
# This program can be used to balance your check book.
# Feature has been added to alert user of any overflow and ignore the 
# transaction that caused the negative or positive overflow. Overflow 
# will occur when the balance exceeds $2,147,483,647 or -$2,147,483,648
#####################################################################
# Pseudocode:
# 	Print Header;
#	s0 = 0;
# loop:	Prompt user for transaction;
#	v0 << transaction amount;
#	if (v0 = 0) done;
####	s1 = s0; 			//saving previous balance before transaction
#	s0 = s0 + v0;
####	if ($v0<0 && $s1>0) 		//No Overflow possible
#####		continue;		//continue program
####   if ($v0>0 && $s1<0) 		//No Overflow possible
####		continue;		//continue program
####	if ($v0>0 && $s1>0 && $s0<0) 	//Overflow detected
####		break; 			//branch to OVERFLOW
####    if ($v0<0 && $s1<0 and $s0>0)	//overflow detected
####		break; 			//branch to OVERFLOW
#### 	Overflow: cout << overflow error message;
####		   s0 = s1;           //restore previous balance before overflow
####		   go to loop; 		//return to beginning of loop
#	cout << s0
#	go to loop
# done:
# 	cout << "Adios Amigo"
# 
######################################################################
# Register Usage:
# $v0: Transaction Amount
# $s0: Current Bank Balance
# $s1: Holds previous balance before transaction
# $t3: Holds data results when comparing $v0, $s0, and $s1
######################################################################
	.data			# Data declaration section
Head: 	.ascii	"\n\tThis program, written by <YOUR NAME>,"
	.ascii	" can be used to balance your check book."
	.asciiz	"\n\n\t\t\t\t\t\t\t\t\t  Balance"
tabs:	.asciiz	"\t\t\t\t\t\t\t\t\t"
tran:	.asciiz	"\nTransaction:"
bye:	.asciiz	"\n  ****  Adios Amigo  **** "
error:  .asciiz	 "\n An Overflow had Occurred – This transaction has been ignored \n"

	.text				# Executable code follows
main:
	li	$v0, 4			# system call code for print_string
	la	$a0, Head		# load address of Header message into $a0
	syscall				# print the Header
	move	$s0, $zero		# Set Bank Balance to zero

loop:
	li	$v0, 4			# system call code for print_string
	la	$a0, tran		# load address of prompt into $a0
	syscall				# print the prompt message

	li	$v0, 5			# system call code for read_integer
	syscall				# reads the amount of  Transaction into $v0

	move	$s1, $s0		####copying previous balance to new register for comparison purposes 

	beqz	$v0, done		# If $v0 equals zero, branch to done
	addu 	$s0, $s0, $v0		# add transaction amount to the Balance
					
					#### Checking for overflow
	xor 	$t3, $s1, $v0  		#### if signs differ $t3 < 0, if signs are the same $t3 = 0
	slt 	$t3, $t3, $zero	 	#### if $t3 < 0 setting $t3 = 1
	bnez 	$t3, NoOverflow  	#### if $t3 != 0, then the signs between oprands differ, so no overflow possible
	xor 	$t3, $s0, $s1 		#### since signs match, checking to see if balance sign also matches
	slt 	$t3, $t3, $zero 	#### if $t3 < 0 setting $t3 = 1
	bnez 	$t3, Overflow  		#### if $t3 != 0 then OVERFLOW DETECTED- branching to overflow instructions

NoOverflow: 				#### If no overflow has occured, continuing with program
	li	$v0, 4			# system call code for print_string
	la	$a0, tabs		# load address of tabs into $a0
	syscall				# used to space over to the Balance column
	
	li	$v0, 1			# system call code for print_integer
	move	$a0, $s0		# move Bank Balance value to $a0 
	syscall				# print Bank Balance
	b 	loop			# branch back to loop

Overflow: 				#### if there is overflow detected...
	li	$v0, 4			#### system call code for print_string
	la	$a0, error		#### load address of msg. into $a0
	syscall                	#### Printing overflow error message

	la	$a0, tabs		##### load address of tabs into $a0
	syscall				##### used to space over to the Balance column
	
	move	$s0, $s1       		#### Restoring previous balance (before overflow)
	li	$v0, 1			#### system call code for print_integer
	move	$a0, $s0		#### move Bank Balance value to $a0 
	syscall				#### print Bank Balance	
	b 	loop           		#### Branch back to loop for user to start over

done:	
	li	$v0, 4			# system call code for print_string
	la	$a0, bye		# load address of msg. into $a0
	syscall				# print the string

	li	$v0, 10			# terminate program run and
	syscall				# return control to system

					# END OF PROGRAM
