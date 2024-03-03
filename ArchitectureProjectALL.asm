.data 
#for menu --------------------------------------------------
strips: .asciiz "\n-----------------------------------------------------------------------------------------------------------------------------------\n"
welcome: .asciiz "                                            Wlecome to our copmression/decompression project"
options: .asciiz "\nPlease enter your choice (c for compress, d for decompress, q to quit) -> "
invalid_choice: .asciiz "\nThe character you choose/sympol/word is not within the possible choices, please try again! \n"
compression_sel: .asciiz "\n\nCompression Selected!\n"
decompression_sel: .asciiz "\nDecompression Selected!\n"
quit_sel: .asciiz "\nQuitting the program.\n"
option_buffer: .space 2 #one for character one for end of word.
compressedFile: .asciiz "C:/Users/ansam/Desktop/Compressed.txt"
decompressedFile: .asciiz "C:/Users/ansam/Desktop/Decompressed.txt"
zero_x: .asciiz "0x"
empty: .asciiz ""
uncompressedSize: .asciiz " Bytes\nThe uncompressesed size is -> "
compressedSize: .asciiz "\nThe compressesed size is -> "
ratio: .asciiz " Bytes\n\nThe ratio is -> "
bytes: .asciiz " Bytes\n"
notInDictError: .asciiz "\nThere is a number that does not exist to dictionary!!!.\n"
#for compression file----------------------------------------
readCFile: .asciiz "\nPlease enter the path for the file you want to compress:\n"
CFile_buffer: .space 256
CompReadBuffer: .space 16384
error: .asciiz "Error opening the file"
result: .space 8
buffer4: .asciiz "\n"
successfulC: .asciiz "\nThe file successfuly Compressed!!\n"
#for decompression file--------------------------------------
readDFile: .asciiz "\nPlease enter the path for the file you want to decompress:\n"
DFile_buffer: .space 256
DecompReadBuffer: .space 16384
successfulD: .asciiz "\nThe file successfuly Decompressed!!\n"
HexArray: .space 4096
hexNumber: .space 8
BufferForNumber: .space 9
#FOR DICTIONARY----------------------------------------------
readyDictionary: .asciiz "Your dictionary is ready to use!\n"
wordArray: .space 16384 #512*32 2D array
dictionary: .space 16384 #512*32 2D array
savedWord: .space 32

dictExists: .asciiz "\nDoes dictionary.txt exist? (y/n): " # prompt to ask user if dictionary file exists
enterDictFile: .asciiz "\nPlease, enter the path of dictionary.txt: \n" # prompt to ask user for path to dictionary file
yesNoBuffer: .space 2
ynOnlyInput: .asciiz "\nplease enter y or n only" # prompt to ask user if dictionary file exists
DictFile_buffer: .space 256
dictReadBuffer: .space 16384
dictionary_txt: .asciiz "dictionary.txt"

.text
.globl main

main:
	#empty copressed file------------------------------------------------
	li $v0, 13              # System call number 13 for "open"
   	 la $a0, compressedFile      # Load the address of the file name
    	li $a1, 1              # File creation flags: create new file, write-only
  	li $a2, 0               # File permissions: not used for file creation
    	syscall
    				
    	move $t0, $v0
    		
    	# Write the data to the file
    	li $v0, 15              # System call number 15 for "write"
    	move $a0, $t0           # File handle
    	la $a1, empty          # Load the address of the data to be written
    	li $a2, 0               # Length of the data to be written
    	syscall

    	# Close the file
    	li $v0, 16              # System call number 16 for "close"
    	move $a0, $t0           # File handle
    	syscall
    	#---------------------------------------------------------------------
    	
    	
    	#empty decopressed file------------------------------------------------
	li $v0, 13              # System call number 13 for "open"
   	 la $a0, decompressedFile      # Load the address of the file name
    	li $a1, 1              # File creation flags: create new file, write-only
  	li $a2, 0               # File permissions: not used for file creation
    	syscall
    				
    	move $t0, $v0
    		
    	# Write the data to the file
    	li $v0, 15              # System call number 15 for "write"
    	move $a0, $t0           # File handle
    	la $a1, empty          # Load the address of the data to be written
    	li $a2, 0               # Length of the data to be written
    	syscall

    	# Close the file
    	li $v0, 16              # System call number 16 for "close"
    	move $a0, $t0           # File handle
    	syscall
    	#---------------------------------------------------------------------
	
	#for menu
	li $v0, 4
	la $a0, strips
	syscall
	
	#for menu
	li $v0, 4
	la $a0, welcome
	syscall
	
	#for menu
	li $v0, 4
	la $a0, strips
	syscall
	
	#for menu
	li $v0, 4
	la $a0, dictExists
	syscall

	# Read user input
	li $v0, 8
    	la $a0, yesNoBuffer
    	li $a1, 2
    	syscall

	yes_No_selection:
		la $t0, yesNoBuffer
		lb $t1, 0($t0)
	
		selectYN:
		li $t2, 'y'
		beq $t2, $t1, getPathDict
		li $t2, 'Y'
		beq $t2, $t1, getPathDict
	
		li $t2, 'n'
		beq $t2, $t1, createEmptyDict
		li $t2, 'N'
		beq $t2, $t1, createEmptyDict
	
		# Print error message
        	li $v0, 4
        	la $a0, ynOnlyInput
        	syscall
        	j exit

	getPathDict:
		#print file path message
        	li $v0, 4
        	la $a0, enterDictFile
        	syscall

		# Read user input
		li $v0, 8
    		la $a0, DictFile_buffer
    		li $a1, 256
    		syscall
    		
    		#remove the new line charachter 
		la $a0, DictFile_buffer	# pass filename to $a0 register
		add $a0, $a0, 100	 	# add 100 to $a0, 
	
		# finding the new line character
	    newline:
		lb $v0,0($a0) 		# get buffer character value
		bne $v0,$zero, end 	# if reached the end
		sub $a0,$a0,1 		# subtracting 1 from $a0
		j newline
	    end: 				# define end of line 
		sb $zero,0($a0) 	# replace the new line character with null

	 	# Open the file for reading
    		li $v0, 13            # System call number for "open" (open a file)
    		la $a0, DictFile_buffer     # Load the address of the filename
    		li $a1, 0             # Mode: read-only
    		li $a2, 0               # Permission: default
    		syscall               # Open the file
    	
    		move $s0, $v0         # Save the file descriptor
    		
    		# Check for error opening the file
    		beqz $s0, open_error    # If file descriptor == 0 (error), branch to error handling

		# Read from the file
    		li $v0, 14            # System call number for "read" (read from a file)
    		move $a0, $s0         # File descriptor
    		la $a1, dictReadBuffer        # Load the address of the buffer
    		li $a2, 16384           # Maximum number of bytes to read
    		syscall               # Read from the file
    
    		move $s1, $v0         # Save the number of bytes read
    	
    
    		# Print the file contents
    		#li $v0, 4               # System call number for "print string"
    		#la $a0, dictReadBuffer          # Load the address of the buffer
    		#move $a1, $s1           # Number of bytes to print
    		#syscall                 # Print the file contents
    
    		# Close the file
    		li $v0, 16              # System call number for "close" (close a file)
    		move $a0, $s0           # File descriptor
    		syscall                 # Close the file
    		
    		j read_dict
    		
    		open_error:
   	 	# Print error message
    		li $v0, 4               # System call number for "print string"
    		la $a0, error     # Load the address of the error message
    		syscall                 # Print the error message
    		j exit
    		
    		
    		#------------------------------------------------------------------------------------------------------------------------
    		
    		#read_loop start--------------------------------------------------------------------------
	 	# Read the string byte by byte into the string array
	 read_dict:
		li $t0, 0      # word counter in wordArraycounter
    		li $t1, 32   # Maximum string length (adjust as needed)
    		la $t2, dictReadBuffer # Load the address of the input string
    		la $t4, wordArray   # Load the address of the string array
		la $s0, wordArray
		li $t7, 0 #flag 
		li $s6, 0 #dictionary array counter
		addiu $s5, $s5, 16384
	
	read_loop:
   		lbu $t5, ($t2) #get the current byte
  		beq $t5, $zero, done
  		# Check if the current character is space or punctuation
    		li $t6, ' '               # Space
    		beq $t5, $t6, storeWord   # If the current character is space, store the current word
    	
    		li $t6, ','               # Space
    		beq $t5, $t6, storeWord   # If the current character is space, store the current word
    	
    		li $t6, '.'               # Space
    		beq $t5, $t6, storeWord   # If the current character is space, store the current word
    	
    		li $t6, '!'               # Space
    		beq $t5, $t6, storeWord   # If the current character is space, store the current word
    	
    		li $t6, '\n'               # Space
    		beq $t5, $t6, storeWord   # If the current character is space, store the current word
    	
    		li $t6, '?'               # Space
    		beq $t5, $t6, storeWord   # If the current character is space, store the current word
    		
    		li $t6, '#'               # Space
    		beq $t5, $t6, storeWord   # If the current character is space, store the current word
    	
    		li $t6, '$'               # Space
    		beq $t5, $t6, storeWord   # If the current character is space, store the current word
    	
    		sb $t5, ($t4) #store the current byte
   	
  		addiu $t2, $t2, 1   # Increment the input string address
  		addiu $t4, $t4, 1   # Increment the saved word string array address
  		addiu $t7, $t7, 1   # Increment flag
    	
    		beq $t4, $s5, done
    		j read_loop               # Continue looping
 		#read loop end -----------------------------------------------------------
    	
	storeWord:
		beqz  $t7, skip 
	
		addiu $s0, $s0, 32
		addiu $t0, $t0, 1   # Increment the loop counter
		move $t4, $s0
	
  	   skip: #to skkip the instructions of adding the characters to the array in case it's at the beginning or the same as ", " 
  		sb $t5, ($t4)
  		addiu $s0, $s0, 32
  		addiu $t0, $t0, 1   # Increment the loop counter
  		addiu $t2, $t2, 1   # Increment the input string address
  		beq $t4, $s5, done
  		li $t7, 0 #flag 
  		move $t4, $s0
		j read_loop	
	
	done:
 	 #loop start------------------------------------------------------------------
		la $s0, wordArray
	
		la $s0, wordArray
		la $t3, wordArray
		move $t8, $t0       # Load the size of the wordArray into $t2
		move $s7, $t0       # Load the size of the wordArray into $t2
	
  	loop: #the rows of the wordArray 
		move $t3, $s0
		la $t0, savedWord
 		la $t4, savedWord
        	
        	li $t2, 32        # Load the size of the buffer into $t2   	
        
        #loop2 start------------------------------------------------------------
     	loop2: #the column of a row in the wordArray
		lbu $t5, ($t3) #get the current byte
        	sb $t5, ($t4) #store the current byte
        	
        	addiu $t3, $t3, 1  # Increment the buffer address by 1 byte		
        	addiu $t4, $t4, 1  # Increment the buffer address by 1 byte						
        	addiu $t2, $t2, -1  # Decrement the counter					
        							
        	bnez $t2, loop2 # Repeat the loop until the buffer is filled		
	
	#loop2 end--------------------------------------------------------------

		la $s1, dictionary
		la $t1, dictionary
		la $s2, savedWord
		la $t2, savedWord
		#to compare the word in the dictionary by linear search
		dictionary_linearsearch:
			bnez $s6, notEmptyDict

			#loop to put the first word into the dictionary (byte by byte)
			li $t3, 32  
		   	insertion:
				lbu $t4, ($t2)
				sb $t4, ($t1)
				
				addiu $t1, $t1, 1  # Increment the buffer address by 1 byte		
     				addiu $t2, $t2, 1  # Increment the buffer address by 1 byte						
        			addiu $t3, $t3, -1  # Decrement the counter					
        							
        			bnez $t3, insertion # Repeat the loop until the buffer is filled	
        		
        		addiu $s6, $s6, 1			
        		move $t2, $s2	
        		move $t1, $s1	
			j continue_to_the_next_word_in_wordArray
			#---------------------------------------------------------------	
		 	notEmptyDict:
		 	move $t4, $s6
		  	#loop to compare the word before insertion
		  	dictionary_row_loop:
		 		li $t3, 32 
		 	   	word_vs_row_loop:
		  			lbu $t5, ($t1)
		  			lbu $t6, ($t2)
			
		  			bne $t5, $t6, next_eol
		  			beq $t5, $t6, next_equals
		  			
		  	 next_eol:	beqz $t5, next_dictionary_word
		  	 		beqz $t6, next_dictionary_word
		  	 		bne $t5, $t6, next_dictionary_word
		  	 		
		  	 next_equals:	addiu $t1, $t1, 1  # Increment the buffer address by 1 byte		
     					addiu $t2, $t2, 1  # Increment the buffer address by 1 byte						
        				addiu $t3, $t3, -1  # Decrement the counter	
        				bnez $t3, word_vs_row_loop
        				
        			#if here then all 32 characters match ------------
        			j continue_to_the_next_word_in_wordArray
        			#if here then characters are diiferent -----------
        			next_dictionary_word:
        				addiu $s1, $s1, 32
        				move $t1, $s1
        				move $t2, $s2
        				addiu $t4, $t4, -1
        				bnez $t4, dictionary_row_loop
        			
        			#if here then no match to anything
        			#loop to insert the string into dictionary
        				li $t3, 32  
		   		insertion2:
					lbu $t4, ($t2)
					sb $t4, ($t1)
					
					addiu $t1, $t1, 1  # Increment the buffer address by 1 byte		
     					addiu $t2, $t2, 1  # Increment the buffer address by 1 byte						
        				addiu $t3, $t3, -1  # Decrement the counter					
        							
        				bnez $t3, insertion2 # Repeat the loop until the buffer is filled	  
        				
        			addiu $s6, $s6, 1    			
	#------------
	continue_to_the_next_word_in_wordArray:	
		addiu $t8, $t8, -1  # Decrement the counter	
		beqz $t8, countinueDict	
		addiu $s0, $s0, 32	
       		j loop	
       	
       	countinueDict:
       		#for menu
		li $v0, 4
		la $a0, readyDictionary
		syscall
		
       		j comp_decomp_menu
   	#loop end------------------------------------------------------------------------
   
	createEmptyDict:
		# File does not exist
   		# Create a new empty file
    		li $v0, 13              # System call number 13 for "open"
    		la $a0, dictionary_txt      # Load the address of the file name
    		li $a1, 11              # File creation flags: create new file, write-only
    		li $a2, 0


	comp_decomp_menu:	
		#for menu
		li $v0, 4
		la $a0, options
		syscall
	
		# Read user input
		li $v0, 8
    		la $a0, option_buffer
    		li $a1, 2
    		syscall

	     c_d_q_option:
		la $t0, option_buffer
		lb $t1, 0($t0)
	
		li $t2, 'c'
		beq $t2, $t1, compression_selected
		li $t2, 'C'
		beq $t2, $t1, compression_selected
	
		li $t2, 'd'
		beq $t2, $t1, decompression_selected
		li $t2, 'D'
		beq $t2, $t1, decompression_selected
	
		li $t2, 'q'
		beq $t2, $t1, quit_selected
		li $t2, 'Q'
		beq $t2, $t1, quit_selected
	
		# Print error message
        	li $v0, 4
        	la $a0, invalid_choice
        	syscall
        	j exit
        
compression_selected:
        
        	#print file path message
        	li $v0, 4
        	la $a0, readCFile
        	syscall
        
        	# Read user input
		li $v0, 8
    		la $a0, CFile_buffer
    		li $a1, 256
    		syscall
    		
		#--------------------------------------------------------
		#remove the new line charachter 
		la $a0,CFile_buffer	# pass filename to $a0 register
		add $a0,$a0,100	 	# add 100 to $a0, 
	
		# finding the new line character

	   newline2:
		lb $v0,0($a0) 		# get buffer character value
		bne $v0,$zero, end2 	# if reached the end
		sub $a0,$a0,1 		# subtracting 1 from $a0
		j newline2
	   end2: 				# define end of line 
		sb $zero,0($a0) 	# replace the new line character with null
	
	 	# Open the file for reading
    		li $v0, 13            # System call number for "open" (open a file)
    		la $a0, CFile_buffer      # Load the address of the filename
    		li $a1, 0             # Mode: read-only
    		li $a2, 0               # Permission: default
    		syscall               # Open the file
  
    		move $s0, $v0         # Save the file descriptor
    
     		# Read from the file
    		li $v0, 14            # System call number for "read" (read from a file)
    		move $a0, $s0         # File descriptor
    		la $a1, CompReadBuffer        # Load the address of the buffer
    		li $a2, 16384           # Maximum number of bytes to read
    		syscall               # Read from the file
    
    		move $s1, $v0         # Save the number of bytes read
    		move $v1, $v0

   		# Check for error opening the file
   		 #beqz $s0, open_error2    # If file descriptor == 0 (error), branch to error handling
    
    
    		# Print the file contents
    		#li $v0, 4               # System call number for "print string"
    		#la $a0, CompReadBuffer          # Load the address of the buffer
    		#move $a1, $s1           # Number of bytes to print
    		#syscall                 # Print the file contents
    
    		# Close the file
   		 li $v0, 16              # System call number for "close" (close a file)
    		move $a0, $s0           # File descriptor
    		syscall                 # Close the file
    		
    		
    	#for reading content and putting the best value for compression---------------------------------
    		la $t0, wordArray   # Load the address of the string array
    		sll $t1, $s7, 5
    		 
    	    emptyLoop:
    	    	li $t4, 0              # ASCII code of null terminator
    		sb $t4, ($t0)        # Store the null terminator at the current address
		addiu $t0, $t0, 1    #add 1 to the address
		addiu $t1, $t1, -1
		bnez $t1, emptyLoop
    		
    		
    		 # Read the string byte by byte into the string array
		li $t0, 0      # word counter in wordArraycounter
    		li $t1, 32   # Maximum string length (adjust as needed)
    		la $t2, CompReadBuffer # Load the address of the input string
    		la $t4, wordArray   # Load the address of the string array
		la $s0, wordArray
		li $t7, 0 #flag 
		
		
	   read_loop2:
   		lbu $t5, ($t2) #get the current byte
  		beq $t5, $zero, done2
  		# Check if the current character is space or punctuation
    		li $t6, ' '               # Space
    		beq $t5, $t6, storeWord2   # If the current character is space, store the current word
    	
    		li $t6, ','               # Space
    		beq $t5, $t6, storeWord2   # If the current character is space, store the current word
    	
    		li $t6, '.'               # Space
    		beq $t5, $t6, storeWord2   # If the current character is space, store the current word
    	
    		li $t6, '!'               # Space
    		beq $t5, $t6, storeWord2   # If the current character is space, store the current word
    	
    		li $t6, '\n'               # Space
    		beq $t5, $t6, storeWord2   # If the current character is space, store the current word
    	
    		li $t6, '?'               # Space
    		beq $t5, $t6, storeWord2   # If the current character is space, store the current word
    	
    		li $t6, '#'               # Space
    		beq $t5, $t6, storeWord2   # If the current character is space, store the current word
    	
    		li $t6, '$'               # Space
    		beq $t5, $t6, storeWord2   # If the current character is space, store the current word
    	
    		sb $t5, ($t4) #store the current byte
   	
  		addiu $t2, $t2, 1   # Increment the input string address
  		addiu $t4, $t4, 1   # Increment the saved word string array address
  		addiu $t7, $t7, 1   # Increment flag
    	
    		beq $t4, $s5, done2
    		j read_loop2               # Continue looping
 		#read loop end -----------------------------------------------------------
    	
	   storeWord2:
		beqz  $t7, skip2 
	
		addiu $s0, $s0, 32
		addiu $t0, $t0, 1   # Increment the loop counter
		move $t4, $s0
	
  	   skip2: #to skkip the instructions of adding the characters to the array in case it's at the beginning or the same as ", " 
  		sb $t5, ($t4)
  		addiu $s0, $s0, 32
  		addiu $t0, $t0, 1   # Increment the loop counter
  		addiu $t2, $t2, 1   # Increment the input string address
  		beq $t4, $s5, done2
  		li $t7, 0 #flag 
  		move $t4, $s0
		j read_loop2	
	
	done2:
	#--------------------------------------------------------------------------------------------------------------------------
 	#loop3 start------------------------------------------------------------------
		la $s0, wordArray
	
		la $s0, wordArray
		la $t3, wordArray
		move $t8, $t0       # Load the size of the wordArray into $t2
		move $s7, $t0       # Load the size of the wordArray into $t2
		li $s3, 0 #counter for number of compressed numbers.
	
  	loop3: #the rows of the wordArray 
		move $t3, $s0
		la $t0, savedWord
 		la $t4, savedWord
        	
        	li $t2, 32        # Load the size of the buffer into $t2   	
        
       	    #loop4 start------------------------------------------------------------
     	    loop4: #the column of a row in the wordArray
		lbu $t5, ($t3) #get the current byte
        	sb $t5, ($t4) #store the current byte
        	
        	addiu $t3, $t3, 1  # Increment the buffer address by 1 byte		
        	addiu $t4, $t4, 1  # Increment the buffer address by 1 byte						
        	addiu $t2, $t2, -1  # Decrement the counter					
        							
        	bnez $t2, loop4 # Repeat the loop until the buffer is filled		
	
	     #loop4 end--------------------------------------------------------------

		la $s1, dictionary
		la $t1, dictionary
		la $s2, savedWord
		la $t2, savedWord
		#to compare the word in the dictionary by linear search
		dictionary_linearsearch2:
			li $s4, 0 #index in dictionary
			bnez $s6, notEmptyDict2

			#loop to put the first word into the dictionary (byte by byte)
			li $t3, 32  
		   	insertion3:
				lbu $t4, ($t2)
				sb $t4, ($t1)
				
				addiu $t1, $t1, 1  # Increment the buffer address by 1 byte		
     				addiu $t2, $t2, 1  # Increment the buffer address by 1 byte						
        			addiu $t3, $t3, -1  # Decrement the counter					
        							
        			bnez $t3, insertion3 # Repeat the loop until the buffer is filled	
        		
        		addiu $s6, $s6, 1			
        		move $t2, $s2	
        		move $t1, $s1	
			j continue_to_the_next_word_in_wordArray2
			#---------------------------------------------------------------	
		 	notEmptyDict2:
		 	move $t4, $s6
		  	#loop to compare the word before insertion
		  	dictionary_row_loop2:
		 		li $t3, 32 
		 	   	word_vs_row_loop2:
		  			lbu $t5, ($t1)
		  			lbu $t6, ($t2)
			
		  			bne $t5, $t6, next_eol2
		  			beq $t5, $t6, next_equals2
		  			
		  	 next_eol2:	beqz $t5, next_dictionary_word2
		  	 		beqz $t6, next_dictionary_word2
		  	 		bne $t5, $t6, next_dictionary_word2
		  	 		
		  	 next_equals2:	addiu $t1, $t1, 1  # Increment the buffer address by 1 byte		
     					addiu $t2, $t2, 1  # Increment the buffer address by 1 byte						
        				addiu $t3, $t3, -1  # Decrement the counter	
        				bnez $t3, word_vs_row_loop2
        				
        			#if here then all 32 characters match ------------
        			j continue_to_the_next_word_in_wordArray2
        			#if here then characters are diiferent -----------
        			next_dictionary_word2:
        				addiu $s1, $s1, 32
        				move $t1, $s1
        				move $t2, $s2
        				addiu $t4, $t4, -1
        				addiu $s4, $s4, 1
        				bnez $t4, dictionary_row_loop2
        			
        			#if here then no match to anything
        			#loop to insert the string into dictionary
        				li $t3, 32  
		   		insertion4:
					lbu $t4, ($t2)
					sb $t4, ($t1)
					
					addiu $t1, $t1, 1  # Increment the buffer address by 1 byte		
     					addiu $t2, $t2, 1  # Increment the buffer address by 1 byte						
        				addiu $t3, $t3, -1  # Decrement the counter					
        							
        				bnez $t3, insertion4 # Repeat the loop until the buffer is filled	  
        				
        			
        			addiu $s6, $s6, 1    			
		#------------
	continue_to_the_next_word_in_wordArray2:	

		move $t7, $s4 
		li $t5, 8 # counter 
		la $t6, result 	# where answer will be stored 
	
	Loop: 
		beqz $t5, Exit 
		# branch to exit if counter is equal to zero 
		rol $t7, $t7, 4 # rotate 4 bits to the left 
		and $t9, $t7, 0xf # mask with 1111 
		ble $t9, 9, Sum # if less than or equal to nine, branch to sum 
		addi $t9, $t9, 55 # if greater than nine, add 55 
		b End 

	Sum: 
		addi $t9, $t9, 48 # add 48 to result 
	End: 
		sb $t9, 0($t6) # store hex digit into result 
		addi $t6, $t6, 1 # increment address counter 
		addi $t5, $t5, -1 # decrement loop counter 
	j Loop 
	
	Exit: 
	
		#la $a0, savedWord 
		#li $v0, 4 
		#syscall
		
		#la $a0, result 
		#li $v0, 4 
		#syscall
		#-------------------------------------------------------------------------
		addiu $s3, $s3, 1
		
		li $v0, 13              # System call number 13 for "open"
   	 	la $a0, compressedFile      # Load the address of the file name
    		li $a1, 9              # File creation flags: create new file, write-only
  		li $a2, 0               # File permissions: not used for file creation
    		syscall
    				
    		move $t0, $v0
    		
    		# Write the data to the file
    		li $v0, 15              # System call number 15 for "write"
    		move $a0, $t0           # File handle
    		la $a1, zero_x          # Load the address of the data to be written
    		li $a2, 2               # Length of the data to be written
    		syscall

    		# Write the data to the file
    		li $v0, 15              # System call number 15 for "write"
    		move $a0, $t0           # File handle
    		la $a1, result          # Load the address of the data to be written
    		li $a2, 8               # Length of the data to be written
    		syscall
    		
    		# Write the data to the file
    		li $v0, 15              # System call number 15 for "write"
    		move $a0, $t0           # File handle
    		la $a1, buffer4          # Load the address of the data to be written
    		li $a2, 1              # Length of the data to be written
    		syscall

    		# Close the file
    		li $v0, 16              # System call number 16 for "close"
    		move $a0, $t0           # File handle
    		syscall
		
	#-----------------------------------------------------
	addiu $t8, $t8, -1  # Decrement the counter	
	beqz $t8, finalcomp		
	addiu $s0, $s0, 32	
        j loop3
   	#loop3 end------------------------------------------------------------------------
   	finalcomp:
   		li $v0, 4 
    		la $a0, successfulC 
		syscall
	
		li $v0, 4 
    		la $a0, compressedSize 
		syscall
	
		#li $v0, 1 
    		#move $a0, $s3 
		#syscall
	
		sll $t1, $s3, 4
		li $v0, 1  #size compressed
    		move $a0, $t1 
		syscall
	
		#li $v0, 1 
    		#move $a0, $v1 
		#syscall
    	
    		li $v0, 4 
    		la $a0, uncompressedSize 
		syscall
	
		sll $t2, $v1, 4
		li $v0, 1 #size uncompresses
    		move $a0, $t2 
		syscall
	
		mtc1 $t1, $f0
		cvt.d.w $f0, $f0
	
		mtc1 $t2, $f2
		cvt.d.w $f2, $f2
    	
    		div.d $f4, $f2, $f0
    	
    		li $v0, 4 
    		la $a0, ratio 
		syscall
    	
    		mov.d $f12, $f4            # Move the double value to register $f12
    		li $v0, 3                  # System call number 3 for "print double"
    		syscall
    		
    		li $v0, 4 
    		la $a0, bytes 
		syscall
	
    	j comp_decomp_menu
    
    	open_error2:
    		# Print error message
   		li $v0, 4               # System call number for "print string"
    		la $a0, error     # Load the address of the error message
    		syscall                 # Print the error message

#------------------------------------------------------------------------------------------------------------------    
decompression_selected:
	# Print decompression message
        li $v0, 4
        la $a0, decompression_sel
        syscall
        
        #print file path message
        li $v0, 4
        la $a0, readDFile
        syscall
        
        # Read user input
	li $v0, 8
    	la $a0, DFile_buffer
    	li $a1, 256
    	syscall
    	
    	#li $v0, 4
	#la $a0, DFile_buffer
	#syscall
	
	#remove the new line charachter 
	la $a0, DFile_buffer	# pass filename to $a0 register
	add $a0, $a0, 100	 	# add 100 to $a0, 
	
	# finding the new line character
	newlineD:
	lb $v0,0($a0) 		# get buffer character value
	bne $v0,$zero, endD 	# if reached the end
	sub $a0,$a0,1 		# subtracting 1 from $a0
	j newlineD
    endD: 				# define end of line 
	sb $zero,0($a0) 	# replace the new line character with null

	 # Open the file for reading
    	li $v0, 13            # System call number for "open" (open a file)
    	la $a0, DFile_buffer     # Load the address of the filename
    	li $a1, 0             # Mode: read-only
    	li $a2, 0               # Permission: default
    	syscall               # Open the file
    	
    	move $s0, $v0         # Save the file descriptor
    		
    	# Check for error opening the file
  	# beqz $s0, open_errorD    # If file descriptor == 0 (error), branch to error handling

		# Read from the file
    	li $v0, 14            # System call number for "read" (read from a file)
  	move $a0, $s0         # File descriptor
    	la $a1, DecompReadBuffer       # Load the address of the buffer
    	li $a2, 16384           # Maximum number of bytes to read
    	syscall               # Read from the file
    
    	move $s1, $v0         # Save the number of bytes read
    	
    
    	# Print the file contents
    	#li $v0, 4               # System call number for "print string"
    	#la $a0, dictReadBuffer          # Load the address of the buffer
    	#move $a1, $s1           # Number of bytes to print
    	#syscall                 # Print the file contents
    
    	# Close the file
    	li $v0, 16              # System call number for "close" (close a file)
    	move $a0, $s0           # File descriptor
    	syscall                 # Close the file
        
   	 read_numbers:
    		li $t0, 0      # numbers counter in numersArray
    		la $t2, DecompReadBuffer # Load the address of the input string
    		la $t4, HexArray   # Load the address of the string array
		la $s0, HexArray
		addiu $s5, $s5, 4096
		
		addiu $t2, $t2, 2
        
        readNumbersLoop:
        	lbu $t5, ($t2) #get the current byte
  		beq $t5, $zero, doneHex
  		# Check if the current character is space or punctuation
  		
    		li $t6, '\n'               # Space
    		beq $t5, $t6, storeHex   # If the current character is space, store the current word
    		
    		li $t6, 0x0d               # Space
    		beq $t5, $t6, storeHex   # If the current character is space, store the current word
    		
    		sb $t5, ($t4) #store the current byte
   	
  		addiu $t2, $t2, 1   # Increment the input string address
  		addiu $t4, $t4, 1   # Increment the saved word string array address
  		#addiu $t7, $t7, 1   # Increment flag
    	
    		beq $t4, $s5, doneHex
    		j readNumbersLoop              # Continue looping
        
        storeHex:
        	addiu $t0, $t0, 1   # Increment the loop counter
  		addiu $t2, $t2, 3   # Increment the input string address
  		beq $t4, $s5, doneHex
  		j readNumbersLoop
  	ignore:
  		addiu $t2, $t2, 1   # Increment the input string address
  		addiu $t4, $t4, 1   # Increment the saved word string array address
  		
  		beq $t4, $s5, doneHex
    		j readNumbersLoop              # Continue looping
  	
  	doneHex:
		#addiu $t0, $t0, 1
		move $t8, $t0
		
    		la $t4, HexArray   # Load the address of the string array
		la $s0, HexArray
	
  		loopRowDecomp:
  			la $t2, BufferForNumber # Load the address of the input string
  			li $t1, 8   # Maximum string length (adjust as needed)
  			loopColumnDecomp:
  				lbu $t3, ($t4)
  				sb $t3, ($t2)
  				
  				addiu $t4, $t4, 1
  				addiu $t2, $t2, 1
  				addiu $t1, $t1, -1
  				
  				bnez $t1, loopColumnDecomp
  			
			#----------------------------------------------------------------
			la $a0, BufferForNumber       # Load the address of the hexadecimal string into $a0

    			move $t0, $zero          # Initialize $t0 to hold the integer value

			loopHexToDec:
    				lb $t1, ($a0)            # Load a byte from the hexadecimal string
    				beqz $t1, endHexToDec            # Branch to end if end of string is reached

   				sll $t0, $t0, 4          # Shift the result left by 4 bits

    				blt $t1, 58, skip_sub    # Skip subtraction if the character is a digit
    				addi $t1, $t1, -7        # Adjust character 'A' to value 10 and 'a' to value 10
			skip_sub:

    				sub $t1, $t1, 48         # Convert ASCII digit to integer value

    				add $t0, $t0, $t1        # Add the current digit to the result
    				addi $a0, $a0, 1         # Move to the next character
    				j loopHexToDec

			endHexToDec:
			#----------------------------------------------------------------
  			#li $v0, 4
        		#la $a0, BufferForNumber
        		#syscall
  				
  			#li $v0, 4
        		#la $a0, buffer4
        		#syscall	
  			
  			#li $v0, 1
        		#move $a0, $t0
        		#syscall	
        		
        		#li $v0, 4
        		#la $a0, buffer4
        		#syscall	
        		
        		bgeu $t0, $s6, DoNotExistInDictionary
        		
        		li $t1, 32
        		la $t2, dictionary
        		sll $t3, $t0, 5
        		addu $t2, $t2, $t3
        		la $t9, savedWord
        		
        		FillWordOfAddress:
        			lbu $t7, ($t2)
        			sb $t7, ($t9)
        			
        			addiu $t2, $t2, 1
        			addiu $t9, $t9, 1
        			addiu $t1, $t1, -1
        			bnez $t1, FillWordOfAddress
        			
        		#li $v0, 4
        		#la $a0, savedWord
        		#syscall
  				
  			#li $v0, 4
        		#la $a0, buffer4
        		#syscall	
  			#-------------------------------------------
  			#printing the info in uncompresses file
  			li $t1, -1 #size counter
  			la $t2, savedWord
  			li $t5, 32
  			GetStringSize:
  				lbu $t3, ($t2)
  				addiu $t2, $t2, 1
  				addiu $t1, $t1, 1
  				addiu $t5, $t5, -1
  				beqz $t5, continuDecomping
  				bnez  $t3, GetStringSize
  				
  				
  			#li $v0, 1
        		#move $a0, $t1
        		#syscall	
        		
        		#li $v0, 4
        		#la $a0, buffer4
        		#syscall		
  			
  			#li $v0, 4
        		#la $a0, strips
        		#syscall	
        		
        		li $v0, 13              # System call number 13 for "open"
   	 		la $a0, decompressedFile      # Load the address of the file name
    			li $a1, 9              # File creation flags: create new file, write-only
  			li $a2, 0               # File permissions: not used for file creation
    			syscall
    				
    			move $t0, $v0

    			# Write the data to the file
    			li $v0, 15              # System call number 15 for "write"
    			move $a0, $t0           # File handle
    			la $a1, savedWord          # Load the address of the data to be written
    			move $a2, $t1              # Length of the data to be written
    			syscall

    			# Close the file
    			li $v0, 16              # System call number 16 for "close"
    			move $a0, $t0           # File handle
    			syscall
  				
  			#-------------------------------------------
  		continuDecomping:
  			addiu $t8, $t8, -1	
  			bnez $t8, loopRowDecomp
  			
  		li $v0, 4
        	la $a0, successfulD
        	syscall
        	
        j comp_decomp_menu

#---------------------------------------------------------------------------------------------------------------------
quit_selected:
    	# Close the program
   	 li $v0, 10      # System call number 10 for "exit"
    	syscall
	
DoNotExistInDictionary:
	li $v0, 4
        la $a0, notInDictError
        syscall
        			
exit: