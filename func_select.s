#312349103 Eldar Shalev

.data
.section .rodata
format_d1: .string "%d"
format_s1: .string "%s"
format_c1: .string "%c"

.align 8 # Align address to multiple of 8
SWITCH:
	.quad case50
	.quad case51
	.quad case52
	.quad case53
	.quad case54
	.quad default


    # for the switch case
    format_50:    .string "first pstring length: %d, second pstring length: %d\n"
    format_51:    .string "old char: %c, new char: %c, first string: %s, second string: %s\n" 
    format_52:    .string "length: %d, string: %s\n"
    format_53:    .string "length: %d, string: %s\n"
    format_54:    .string "compare result: %d\n"
    format_invalid:   .string "invalid option!\n"
    
.text
.globl run_func
	.type run_func, @function
	
run_func:
    pushq %rbx
    pushq %r12
    pushq %r13
    pushq %r14


	# Preperation before switch-case
    leaq -50(%rdi), %r8
    cmpq $5, %r8
    ja default
    jmp *SWITCH(,%r8,8)
     
    case50:	
	#option 50
    movq    %r15, %rdi                      # r15 gets the first pstring
    movq    $0, %rax
    call    pstrlen                         # compute first pstring length
    pushq   %r13                            # backup colee saved r13
    movq    %rax, %r13                      # r13 gets first pstring length
    
    movq    %r12, %rdi                      # r12 gets second pstring
    movq    $0, %rax
    call    pstrlen                         # comupte second pstring length
    pushq   %r14                            # backup colee saved r14
    movq    %rax, %r14                      # r14 gets second pstring length
 
    movq    $format_50, %rdi              # rdi gets this case's print format
    movq    %r13, %rsi                      # r13 gets first pstring length
    movq    %r14, %rdx                      # r14 gets second pstring length
    movq    $0, %rax
    call    printf                          # print the pstrings lengths
    popq    %r14                            # restore colee saved r13 and r14
    popq    %r13  
    jmp end									#finish program
    #################################################
	#finish case 50
	#################################################
     
     
     
    case51:
    #option 51
    #get first char
    
    pushq %rdx 							#second string
    pushq %rsi 							#first string
    movq $format_s1, %rdi		        #rdi gets the format we want to get because of scanf syntax
    
    movq $0, %rbx
    pushq %rbx                          #push 8 bytes to rbx for allocating                            
    movq %rsp, %rsi                     #rsp is the register stack pointer, rsi is the address to the where to write
                                        #rsi now gets the address to the stack and that means we write on the register that we pushed to the stack
    xorq %rax, %rax
    call scanf
    
	
    #get second char
    movq $format_s1, %rdi     		    #rdi gets the format we want to get because of scanf syntax
    movq $0, %rbx
    pushq %rbx                          #push 8 bytes to rbx for allocating
    movq %rsp, %rsi                     #rsp is the register stack pointer, rsi is the address to the where to write
                                        #rsi now gets the address to the stack and that means we write on the register that we pushed to the stack
    xorq %rax, %rax
    call scanf
 
    
    popq %rdx                           #the second char is in rdx
    popq %rsi                           #the first char is in rsi
    popq %rdi                           #first string
    
    movq %rdx, %r12                     #r12 gets second char
    movq %rsi, %r13                     #r13 gets first char
    movq %rdi, %r14                     #r14 gets first string
    
    call replaceChar
    
    popq %rdi
    movq %r13, %rsi
    movq %r12, %rdx
    movq %rax, %r15                      #saving value from the 1st call and get the other replace char
    
    call replaceChar
    
    movq $format_51, %rdi
    movq %r13, %rsi                      #second argument gets first char
    movq %r12, %rdx                      #third argument gets second char
    movq %r15, %rcx                      #forth argument to the pointer of first string
    movq %rax, %r8                       #fifth argument to the pointer of second string
    incq %rcx
    incq %r8
    xorq %rax, %rax
    call printf
    jmp end
    #################################################
	#finish case 51
	#################################################
     
    case52:
	# option 52 
    pushq %rdx 							#second string
    pushq %rsi 							#first string
	
    #scan the first number, (i index)
    movq $format_d1, %rdi    			#rdi gets first paramter which is the format

    movq $0, %r12
    pushq %r12                          #push 8 bytes to r12 for allocating
                                        
    movq %rsp, %rsi                     #rsp is the register stack pointer, rsi is the address to the where to write
                                        #rsi now gets the address to the stack and that means we write on the register that we pushed to the stack
    xorq %rax, %rax
    call scanf
    movq $0, %rax                       #return value from scanf

    #scan the second number, (j index)
    movq $format_d1, %rdi    			#rdi gets first paramter which is the format
    movq $0, %rbx                       
    pushq %rbx                          #push 8 bytes to rbx for allocating
    movq %rsp, %rsi                     #rsp is the register stack pointer, rsi is the address to the where to write
                                        #rsi now gets the address to the stack and that means we write on the register that we pushed to the stack
    xorq %rax, %rax
    call scanf
    movq $0, %rax                       #return value from scanf

    
     popq %rcx                          #index j
     popq %rdx                          #index i
     popq %rdi                          #first string  destination
     popq %rsi                          #second string source
     movq %rsi, %r14                    #source in a callee save register r14
     call pstrijcpy						#call function
     
     movq $format_52, %rdi 				#rdi gets first paramter which is the format
     movq %rax, %r15                    #r15 gets pstrings arguments
     movzbq (%r15), %rsi			
	 incb %r15b

     movq %r15, %rdx
     xorq %rax, %rax
     call printf
     
     movq $format_52, %rdi 				#rdi gets first paramter which is the format
     movzbq (%r14), %rsi				#r14 gets pstrings arguments
	 incb %r14b
     movq %r14, %rdx
     xorq %rax, %rax
     call printf 
     
     jmp end
     #################################################
	 #finish case 52
	 #################################################
     
     case53:
     ##################################################
     movq %rdx, %r13                        #second string
     movq %rsi ,%r14                        #first string
     
     
     
     movq %rsi, %rdi                        #rdi gets first string
     call swapCase
     
     movq $format_53, %rdi
     movq %rax, %rbx                        #rbx gets the new string
     movzbq (%rbx), %rsi					# dealing with the arugment 
     incb %bl
     movq %rbx, %rdx
     xorq %rax, %rax
     call printf
     
     
     movq %r13 ,%rdi                         #rdi gets second string
     call swapCase
     
     movq $format_53, %rdi
     movq %rax, %r12                         #r12 gets new string
     movzbq (%r12), %rsi					 # dealing with the argument carefully
     incb %r12b
     movq %r12, %rdx
     xorq %rax, %rax
     call printf
     
     jmp end
	 
     #################################################
	 #finish case 53
	 #################################################
	 
	 
     case54:
     ##################################################
     pushq %rdx                          	#second string
     pushq %rsi                          	#first srting
     #scan the first number, (i index)
     movq $format_d1, %rdi    			 	#rdi gets the format
                                         

     movq $0, %r12
     pushq %r12                         	#push 8 bytes to r12 for allocating
                                        
     movq %rsp, %rsi                  		#rsp is the register stack pointer, rsi is the address to the where to write
											#rsi now gets the address to the stack and that means we write on the register that we pushed to the stack
     xorq %rax, %rax
     call scanf
     xorq %rax, %rax
     
     #scan the second number, (j index)
     movq $format_d1, %rdi     			  #rdi gets the format
     movq $-1, %rbx                       #initialize to -1 to make sure both i and j were inserted and not only one of them
     pushq %rbx                           #push 8 bytes to rbx for allocating
     movq %rsp, %rsi                      #rsp is the address of the stack pointer , rsi hold the address to wherer to write
	 									  #rsi now gets the address to the stack and that means we write on the register that we pushed to the stack

     xorq %rax, %rax
     call scanf
  
     
     popq %rcx                              #index j
     popq %rdx                              #index i
     popq %rdi                              #first string  destination
     popq %rsi                              #second string source
     movq %rsi, %r14                       	#source to a callee save- register r14
     
     call pstrijcmp							# call function
     
     movq $format_54, %rdi
     movq %rax, %rsi
     xorq %rax, %rax
     call printf
     
     
     jmp end
     #################################################
	 #finish case 54
	 #################################################
     
     default:
	 # default for switch case
     movq $format_invalid, %rdi   			#rdi gets format of invalid
     xorq %rax, %rax						#zero rax
     call printf							#print invalid format
     
     end:  
	 #clear all calle registers
     popq %r14
     popq %r13
     popq %r12
     popq %rbx
      
     ret
     