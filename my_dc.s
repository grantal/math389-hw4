    .globl  my_dc
	.align 16
my_dc:
    pushq   %rbp       
    movq    %rsp, %rbp	
    
    # get input
    callq    input_char 
    movq     %rax, %rdx 

    # print what was inputed 
    pushq %rdx
    callq output_long
    popq  %rdx

    movq    $0, %rax    # return 0
    popq    %rbp        #
    retq                #
