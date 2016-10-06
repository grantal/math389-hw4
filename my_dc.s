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

    # subtract top two if it is -
    movq    $45, %rcx
    cmpq    %rdx, %rcx
    je      sub 


    # multiply top two if it is *
    movq    $42, %rcx
    cmpq    %rdx, %rcx
    je      mulcall

    # modulo top two if it is %
    movq    $37, %rcx
    cmpq    %rdx, %rcx
    je      modcall

    # divide top two if it is /
    movq    $47, %rcx
    cmpq    %rdx, %rcx
    je      divcall

    # dcon if d
    movq    $100, %rcx
    cmpq    %rdx, %rcx
    je      dconcall

    # power if ^
    movq    $94, %rcx
    cmpq    %rdx, %rcx
    je      powcall

    # quit if %rdx is 'x'
    movq    $120, %rcx
    cmpq    %rdx, %rcx
    je      return 

    jmp     loop 


# The "top" of my stack will be at -8(%rbx)
# This is so I can put the first variable on the stack
# exactly at %rbx and then increment %rbx
num:
    # make %rdx its value, not its char value
    subq    $48, %rdx
    # put %rdx on calc stack
    movq    %rdx, 0(%rbx) 
    addq    $8, %rbx
    jmp     loop 

print:
    # put top of stack in rdi
    movq    -8(%rbx), %rdi
    callq   output_long
    jmp     loop 

add:
    movq    -8(%rbx), %rcx   # get top item off stack
    movq    $0, -8(%rbx)     # overwrite the higher one
    subq    $8, %rbx         # decrement the calc pointer
    movq    -8(%rbx), %rdx   # get top item off stack
    # put the sum at the new top
    addq    %rcx, %rdx
    movq    %rdx, -8(%rbx) 
    jmp     loop 
    
# subtracts top from previous top
sub:
    movq    -8(%rbx), %rcx   # get top item off stack
    movq    $0, -8(%rbx)     # overwrite the higher one
    subq    $8, %rbx         # decrement the calc pointer
    movq    -8(%rbx), %rdx   # get top item off stack
    # put the difference at the new top
    subq    %rcx, %rdx
    movq    %rdx, -8(%rbx) 
    jmp     loop 


mulcall:
    movq    -8(%rbx), %rdi   # get top item off stack
    movq    $0, -8(%rbx)     # overwrite the higher one
    subq    $8, %rbx         # decrement the calc pointer
    movq    -8(%rbx), %rsi   # get top item off stack
    # put the product at the new top
    callq   mul
    movq    %rax, -8(%rbx) 
    jmp     loop 

modcall:
    movq    -8(%rbx), %rsi   # get top item off stack
    movq    $0, -8(%rbx)     # overwrite the higher one
    subq    $8, %rbx         # decrement the calc pointer
    movq    -8(%rbx), %rdi   # get top item off stack
    # put the remainder at the new top
    callq   mod
    movq    %rax, -8(%rbx) 
    jmp     loop 

divcall:
    movq    -8(%rbx), %rsi   # get top item off stack
    movq    $0, -8(%rbx)     # overwrite the higher one
    subq    $8, %rbx         # decrement the calc pointer
    movq    -8(%rbx), %rdi   # get top item off stack
    # put the quotient at the new top
    callq   div
    movq    %rax, -8(%rbx) 
    jmp     loop 

dconcall:
    movq    %rbx, %rdi     # pass pointer to 'top of stack' to dcon
    subq    $8, %rdi
    callq   dcon
    movq    -8(%rbx), %rcx # rcx will be counter for purge
# remove top rcx number of items
dconcall_loop:
    cmpq    $0, %rcx
    jle     dconcall_end
    subq    $1, %rcx
    subq    $8, %rbx
    movq    $0, 0(%rbx)
    jmp dconcall_loop
# put dcon result on top
dconcall_end:
    movq    %rax, -8(%rbx) 
    jmp     loop 

powcall:
    movq    -8(%rbx), %rsi   # get top item off stack
    movq    $0, -8(%rbx)     # overwrite the higher one
    subq    $8, %rbx         # decrement the calc pointer
    movq    -8(%rbx), %rdi   # get top item off stack
    # put the power at the new top
    callq   pow
    movq    %rax, -8(%rbx) 
    jmp     loop 

return:
    movq    $0, %rax    # return 0
    popq    %rbp        #
    retq                #
