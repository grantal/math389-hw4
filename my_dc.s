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

divcall:
    movq    -1(%rbx), %rsi   # get top item off stack
    movq    $0, -1(%rbx)     # overwrite the higher one
    subq    $1, %rbx         # decrement the calc pointer
    movq    -1(%rbx), %rdi   # get top item off stack
    # put the quotient at the new top
    callq   div
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
    cmpq    $0, %rdi
    jge     div_pos_call 
    call    div_neg_helper
    retq
div_pos_call:
    call    div_pos_helper
    retq
# helper if dividend is positive
div_pos_helper:
    subq    %rsi, %rdi   # rdi = rsi - rdi
    # if rsi goes into rdi once, the the quotient is 0
    cmpq    $0, %rdi     
    jl      div_basecase
    # otherwise its the quotient of one less rsi plus 1
    callq   div_pos_helper
    addq    $1, %rax
    retq
# if negative
div_neg_helper:
    addq    %rsi, %rdi   # rdi = rsi + rdi
    # if rsi goes into rdi once, the the quotient is 0
    cmpq    $0, %rdi     
    jg      div_basecase
    # otherwise its the quotient of one more rsi minus 1
    callq   div_pos_helper
    subq    $1, %rax
    retq
# this basecase is being treated as part of both div helpers
# it returns for both of those functions
div_basecase:
    movq    $0, %rax
    retq


# dcon
# gets decimals
# rdi has the stack pointer
.globl dcon
dcon:
                          # rdi will point to the element we want
    movq    %rdi, %rdx
    callq   output_long
    movq    0(%rdx), %rcx # rcx will be the counter 
    movq    $0, %rax      # rax will be the result
dcon_loop:
    cmpq    $0, %rcx      # see if counter is 0
    jle     dcon_return
    subq    $1, %rcx      # subtract 1 from counter and pointer
    subq    $1, %rdx
    addq    0(%rdx), %rax 
    jmp     dcon_loop
dcon_return:
    movq    %rdx, %rdi
    callq   output_long
    retq

# pow
# computes x^p
.globl pow
pow:
    movq    %rdi, %rdx # rdx is x
    movq    %rsi, %rcx # rcx is p 
    movq    $1, %rax   # result
pow_loop: 
    cmpq    $0, %rcx
    jle     pow_return
    subq    %rcx
    movq    %rdx, %rdi
    callq   mul        #multiply rax by rdx
    jmp pow_loop
pow_return:
    retq







