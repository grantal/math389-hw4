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
    
# subtracts top from previous top
sub:
    movq    -1(%rbx), %rcx   # get top item off stack
    movq    $0, -1(%rbx)     # overwrite the higher one
    subq    $1, %rbx         # decrement the calc pointer
    movq    -1(%rbx), %rdx   # get top item off stack
    # put the difference at the new top
    subq    %rcx, %rdx
    movq    %rdx, -1(%rbx) 
    jmp     loop 


mulcall:
    movq    -1(%rbx), %rdi   # get top item off stack
    movq    $0, -1(%rbx)     # overwrite the higher one
    subq    $1, %rbx         # decrement the calc pointer
    movq    -1(%rbx), %rsi   # get top item off stack
    # put the product at the new top
    callq   mul
    movq    %rax, -1(%rbx) 
    jmp     loop 

modcall:
    movq    -1(%rbx), %rsi   # get top item off stack
    movq    $0, -1(%rbx)     # overwrite the higher one
    subq    $1, %rbx         # decrement the calc pointer
    movq    -1(%rbx), %rdi   # get top item off stack
    # put the remainder at the new top
    callq   mod
    movq    %rax, -1(%rbx) 
    jmp     loop 

return:
    movq    $0, %rax    # return 0
    popq    %rbp        #
    retq                #


# actual functions
    
# mod(n,d)
# rdi % rsi
# where %rdi is n, the dividend
# and %rsi is d the divisor
.globl mod
mod:
    # dealing with a negative n
    movq    $0, %rcx
    cmpq    $0, %rdi
    jge      modloop
    negq    %rdi
    # putting a flag in rcx
    movq    $1, %rcx
modloop:
    subq    %rsi, %rdi 
    cmpq    $0, %rdi
    jl      modreturn
    jmp     modloop
modreturn:
    # how far away -rdi is from rsi
    # rax = rsi + rdi
    movq    $0, %rax
    addq    %rsi, %rax
    addq    %rdi, %rax
    cmpq    $1, %rcx  # seeing if the flag is set
    je      modnegreturn
    retq
modnegreturn:
    negq    %rax
    retq
    

.globl divide
divide:
div:
    # dealing with a negative n
    movq    $1, %rcx
    cmpq    $0, %rdi
    jge     divcallhelp
    negq    %rdi
    # putting a flag in rcx
    movq    $1, %rcx
divcallhelp:
    callq   divhelper
    cmpq    $1, %rcx  # seeing if the flag is set
    je      divnegreturn
    retq
divnegreturn:
    negq    %rax
    retq
    
divhelper:
    subq    %rsi, %rdi   # rdi = rsi - rdi
    # if rsi goes into rdi once, the the quotient is 0
    cmpq    $0, %rdi     
    jl      divbasecase
    # otherwise its the quotient of one less rsi plus 1
    callq   divhelper
    addq    $1, %rax
    retq
divbasecase:
    movq    $0, %rax
    retq
