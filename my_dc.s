# Alex Grant
# MAth 389

    .globl  my_dc
	.align 16
my_dc:
    pushq   %rbp       
    movq    %rsp, %rbp	
    movq    %rdi, %rbx # rbx will have the calculator stack pointer
    
loop:
    # get input
    callq    input_char 
    movq     %rax, %rdx 

    # if rdx is between 48 and 57,
    # it is a digit
    movq    $48, %rcx
    cmp     %rcx, %rdx
    jl      else
    movq    $57, %rcx
    cmp     %rcx, %rdx
    jg      else
    
    jmp     num

else:
    # print top of stack if it is p
    movq    $112, %rcx
    cmpq    %rdx, %rcx
    je      print 

    # add top two if it is +
    movq    $43, %rcx
    cmpq    %rdx, %rcx
    je      add 


    # quit if %rdx is 'x'
    movq    $120, %rcx
    cmpq    %rdx, %rcx
    je      return 
    jmp     loop 


# The "top" of my stack will be at -1(%rbx)
# This is so I can put the first variable on the stack
# exactly at %rbx and then increment %rbx
num:
    # make %rdx its value, not its char value
    subq    $48, %rdx
    # put %rdx on calc stack
    movq    %rdx, 0(%rbx) 
    addq    $1, %rbx
    jmp     loop 

print:
    # put top of stack in rdi
    movq    -1(%rbx), %rdi
    callq   output_long
    jmp     loop 

add:
    movq    -1(%rbx), %rcx   # get top item off stack
    movq    $0, -1(%rbx)     # overwrite the higher one
    subq    $1, %rbx         # decrement the calc pointer
    movq    -1(%rbx), %rdx   # get top item off stack
    # put the sum at the new top
    addq    %rcx, %rdx
    movq    %rdx, -1(%rbx) 
    jmp     loop 
    

return:
    movq    $0, %rax    # return 0
    popq    %rbp        #
    retq                #
