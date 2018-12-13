#312349103 Eldar Shalev
.data
.section .rodata

        format_invalid: .string "invalid input!\n"

.text
.global pstrlen
    .type pstrlen, @function
pstrlen:
	subq $1,(%rdi)							# we deacrease by one becuase of '\0' 
	movzbq    (%rdi), %rax                  # take the first byte of the pstring
    ret



.globl replaceChar
	.type replaceChar, @function
replaceChar: 
    movq %rdx, %r9                                  #rdx get second char
    movq %rsi, %r11                                 #rsi gets first char
    movq %rdi, %rsi                                 #rdi gets pstring pointer
    movq %rsi, %r8                                  #save value in r8,to save point to the lenght
    movq (%r8), %rax                                #the lenght of the string
    xorq %rcx, %rcx									#zero rcx
    movb %al, %cl
    movq %rcx, %r10
    incq %r8                                        #increment the pointer to the begin of the string 
    
    xorq %rcx, %rcx                                 #zero rcx 
    cmp %rcx, %r10
    ja replaceCharLoop                              #if r10 is bigger then rcx
    jmp replaceCharEnd
    replaceCharLoop:
    
    xorq %rdx, %rdx                                 # zero rdx
    xorq %rax, %rax									# zero rax
    movb (%r8), %dl                                 # dl = pstr[i]
    movq %r11, %rax									# take from r11 to rax
    cmpb %dl, %al
    je replaceChar_if								#condition jump
    jmp replaceChar_endif
    replaceChar_if:
    movq %r9, %rax
    xorq %rdx, %rdx									#zero rdx
    movb %al, %dl
    movb %dl, (%r8)
    replaceChar_endif:
    incq %r8                                        #the index of the string
    incq %rcx                                       #the counter of the loop
    cmp %rcx, %r10									
    ja replaceCharLoop                              #r10 is bigger
    
    replaceCharEnd:
    movq %rsi, %rax                                 #return value is the poiner to the string
    ret
    
.globl pstrijcpy
	.type pstrijcpy, @function
pstrijcpy:
    #rdi - first string, dst
    #rsi - second string, src
    #rdx - i
    #rcx -j
    
    movb %dl, %al									#get i
    movb %cl, %ah 									#get j
    movq %rsi, %rsi 								#get second string, src
	subq $1, (%rsi)									# decrease by because of '\0' 
    movq %rdi, %rdi 								#get first string, dst
	subq $1, (%rdi)									# decrease by because of '\0' 
    movq %rdi, %r13
    
    #check that i and j are not valid
    cmpb %ah, (%rdi)    							#validation 1: j>pstr1.length
    jb pstrijcpy_if
    cmpb %al, (%rsi)    							#validation 2: i>pstr2.length
    jb pstrijcpy_if
    cmpb %al, (%rdi)    							#validation 3: i>pstr1.length 
    jb pstrijcpy_if
	cmpb %ah, (%rsi)    							#validation 4 : j>pstr2.length
    jb pstrijcpy_if
    jmp pstrijcpy_endif 							#if i and j are valid, we jump to the operation
    
    #if i or j are not valid
    pstrijcpy_if:
    movq $format_invalid, %rdi
    xorq %rax, %rax
    call printf
    jmp pstrijcpy_end 								#jmp to the end and finish the function
        
    pstrijcpy_endif:
    pstrijcpy_loop: 								#for i from 0 to j 
    cmpb %al, %ah									# compare i and j
    jb pstrijcpy_end								# if(i > j) means we scan all pstring and we can jmp to the end
    
    movq $0, %rbx
    movb %al, %bl                        			#save i in rbx
    leaq 1(%rsi, %rbx, 1), %rcx         			#pstr2[i]
    leaq 1(%rdi, %rbx, 1), %rdx          			#pstr1[i]
    
    movq $0, %rbx
    movb (%rcx), %bl 								#pstr1[i] = pstr2[i]
    movb %bl, (%rdx) 
        
    incb %al 										#i++
    jmp pstrijcpy_loop								#continue, back to loop
    pstrijcpy_end:									# if we finish the loop
    movq %r13, %rax 								#return pstr1
    ret

.globl swapCase
	.type swapCase, @function
swapCase:
    #the string is in rdi
    subq $1, (%rdi)    
    movq %rdi, %rax 							    #get the pstring from rdi
    movzbq (%rax), %rcx 							#get the lenght of the string
    xorq %rdx, %rdx 								#zero rdx means zero i 
    letters_loop: 									#for i from zero to length
    cmpb %dl, %cl        							#if(i >= length) jmp to the end
    jle swapCase_end
    leaq 1(%rax,%rdx,1), %rbx 	        			#str[i] (moving the work to rbx)
    cmpb $65, (%rbx) 								#if(str[i] < 65) comparing ascii 
    jb notCapital
    cmpb $90, (%rbx) 								#if(str[i] > 90) comparing ascii 
    ja notCapital
    addb $32, (%rbx) 								#make the letter small
    jmp notSmall 		
    
    #if not capital
    notCapital:
    cmpb $97, (%rbx) 								#if(str[i] < 97) comparing ascii
    jb notSmall		
    cmpb $122, (%rbx) 								#if(str[i] > 122) comparing ascii
    ja notSmall
    subb $32, (%rbx) 								#make the letter capital
	
	#if not small
    notSmall:
    incq %rdx 										#i++ // change to incb
    jmp letters_loop 								#jmp to the begining of the loop
    
    swapCase_end:
    #we dont need to move anything to rax because it points on the pstring and we did'nt change it 
    ret

.globl pstrijcmp
	.type pstrijcmp, @function
pstrijcmp:
    
    movb %dl, %al                       #get i
    movb %cl, %ah                       #get j
    movq %rsi, %rsi                     #get second string
    movq %rdi, %rdi                     #get first string
    
    #checking if i and j are valid and between the range
    cmpb %ah, (%rdi) 					#validation1: j>str1.length
    jb pstrijcmp_validation
    cmpb %al, (%rsi) 					#validation2: i>str2.length
    jb pstrijcmp_validation
    cmpb %al, (%rdi) 					#validation3: i>str1.length
    jb pstrijcmp_validation
	cmpb %ah, (%rsi) 					#validation4: j>str2.length
    jb pstrijcmp_validation
    jmp pstrijcmp_canStart				#all the validations are good

	# if one from the validations were invalid
    pstrijcmp_validation:
    movq $format_invalid, %rdi
    xorq %rax, %rax
    call printf
    jmp pstrijcmp_found_error			#jmp to return -2

    pstrijcmp_canStart:
    pstrijcmp_loop:        	            #for i from zero to j
    cmpb %al, %ah 						#if(i > j) jmp to the end
    jb pstrijcmp_endloop
    
    xorq %rbx, %rbx 					#rbx = 0
    movb %al, %bl 						#bl = i
    leaq 1(%rdi,%rbx,1), %rcx       	#str1[i]
    leaq 1(%rsi,%rbx,1), %rdx 	        #str2[i]
    
    xorq %rbx, %rbx 					#rbx = 0
    movb (%rcx), %bl 					#bl = str1[i]
    movb (%rdx), %bh 					#bh = str2[i]
    cmpb %bl, %bh
    
    jb pstrijcmp_bigger  				#if(str1[i] > str2[i])
    ja pstrijcmp_smaller             	#if(str1[i] < str2[i])

    incb %al 							#i++
    jmp pstrijcmp_loop 					#continue the loop

    pstrijcmp_endloop: 					#the strings are equal
    xorq %rax, %rax 					#zero rax
    jmp pstrijcmp_exit
    
    pstrijcmp_found_error: 		        #if there was a problem with the validation of i or j 
    movq $-2, %rax 						#return -2 (defualt)
    jmp pstrijcmp_exit
    
    pstrijcmp_bigger: 					#if pstr1 is bigger
    movq $1, %rax 						#return 1
    jmp pstrijcmp_exit
    
    pstrijcmp_smaller: 					#if pstr2 is smaller
    movq $-1, %rax						#return -1
    jmp pstrijcmp_exit
    
    pstrijcmp_exit:
    ret
    