#312349103 Eldar Shalev

.section .rodata
format_d: .string "%d"
format_s: .string "%s"

.text
.global main
.type main, @function
main:
    movq %rsp, %rbp                         # for correct debugging
    pushq %rbp                              # push rbp to the stack
    movq %rsp, %rbp                         # save the start of the frame in rbp
    
    #first pstring
    subq $4,%rsp                            # increase stack by 4 bytes
    movq %rsp,%rsi                          # rsi gets rsp 
    movq $format_d, %rdi                    # rdi gets address of format_d
    xorq  %rax, %rax                        # zero rax arguments 
    call scanf                              # call scanf
    movzbq (%rsp), %r10                     # saving byte 1 to r10
    leaq 4(%rsp),%rsp                       # delete 4 bytes from rsp
    
    subq %r10, %rsp                         # save enought space for string
    leaq -1(%rsp), %rsp                     # 1 byte for '\0'
    movq %rsp, %rsi                         # rsi gets rsp pointer
    movq $format_s, %rdi                    # rdi gets the string format
    xorq  %rax, %rax                        #zero rax    
    call scanf
    
    leaq    -1(%rsp), %rsp                  # create space for the byte number
    movb    %r10b, (%rsp)                   # insert the number to the head of pstring
    movq    %rsp, %r15                      # %r15 gets the first pstring

    subq    $4, %rsp                        # create space for four bytes (int)
    movq    %rsp, %rsi                      # rsi gets stack (rsp)
    movq    $format_d, %rdi                 # rdi gets address of format_d
    xorq    %rax, %rax                      # zero rax
    call    scanf
    movzbq  (%rsp), %r10                    # saving the 1-byte number we recieved to r10
    leaq    4(%rsp), %rsp                   # delete the 4-byte int we saved
    
    subq    %r10, %rsp                      # save enough space for string
    leaq    -1(%rsp), %rsp                  # 1 byte for '/0'
    movq    %rsp, %rsi                      # rsi gets the stack pointer to the next string
    movq    $format_s, %rdi                 # rdi gets address of format_s
    xorq    %rax, %rax                      #zero rax
    call    scanf
    
    leaq    -1(%rsp), %rsp                  # create space for the one byte
    movb    %r10b, (%rsp)                   # insert the number to the head of pstring
    movq    %rsp, %r12                      # r12 gets the second pstring
    
    leaq    -4(%rsp), %rsp                  # create space for int - 4 bytes
    movq    %rsp, %rsi                      # rsi gets register stack pointer
    movq    $format_d, %rdi                 # rdi gets address of format_d
    xorq    %rax, %rax                      # zero rax
    call    scanf                           # get the case number
    movq    $0, %r13
    movb    (%rsp), %r13b                   # r13 gets the case number
  
    movq    %r13, %rdi                      # rdi gets the case number
    movq    %r15, %rsi                      # rsi gets the first pstring
    movq    %r12, %rdx                      # r12 gets the second pstring
    xorq  	%rax, %rax                      #zero rax
    call    run_func                        # switch-case function from func_select
    
    
    #finish program
    xorq  %rax, %rax                        #zero rax
    movq %rbp, %rsp                         #close the frame
    popq %rbp                               #pop rbp to the start of the stack
    ret
