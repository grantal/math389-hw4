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

    # quit if %rdx is 'x'
    movq    $120, %rcx
    cmpq    %rdx, %rcx
    je      return 
    jmp     loop 
    jmp     loop 
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

return:
    movq    $0, %rax    # return 0
    popq    %rbp        #
    retq                #
