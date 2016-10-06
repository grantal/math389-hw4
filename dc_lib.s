# Alex Grant
# Math 389
# dc_lib.s
# This has all the functions I will call in my_dc.s

    .align 16

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
divide: #this is here because c gets confused about calling "div"
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


# dcon
# gets decimals
# rdi has the stack pointer
.globl dcon
dcon:
                          # rdi will point to the element we want
    #movq    %rdi, %rdx
    movq    0(%rdi), %rcx # rcx will be the counter 
    movq    $0, %rax      # rax will be the result
dcon_loop:
    cmpq    $0, %rcx      # see if counter is 0
    jle     dcon_return
    subq    $1, %rcx      # decrement counter and pointer
    subq    $8, %rdi
    # multiply rax by 10
    # (2*2 + 1)*2 = 10
    movq    %rax, %rdx
    salq    %rax
    salq    %rax
    addq    %rdx, %rax
    salq    %rax
    #add the digit to rax
    addq    0(%rdi), %rax 
    jmp     dcon_loop
dcon_return:
    retq

# pow
# computes x^p
/* old power function
.globl power
power: # again, c thinks I want the pow in math.h
.globl pow
pow:
    movq    %rdi, %rdx # rdx is x
    movq    %rsi, %rcx # rcx is p 
    movq    $1, %rax   # result
pow_loop: 
    cmpq    $0, %rcx
    jle     pow_return
    subq    $1, %rcx
    movq    %rdx, %rdi
    movq    %rax, %rsi
    callq   mul        #multiply rax by rdx
    jmp     pow_loop
pow_return:
    retq
*/
.globl power
power: # again, c thinks I want the pow in math.h
.globl pow
pow:
    # make stack frame
    pushq   %rbp 
    movq    %rsp, %rbp
    subq    $16, %rsp
    
    # save current values of r12, r13    
    movq   %r12, -8(%rbp)
    movq   %r13, -16(%rbp)

    movq    %rdi, %r12 # r12 is x
    movq    %rsi, %r13 # r13 is p 
    
    # if p = 0, then basecase
    cmpq    $0, %r13
    je      pow_basecase
    # if r12 & 1 = 0 then r12 is even
    movq    %r13, %rcx
    andq    $1, %rcx
    cmpq    $0, %rcx
    je      pow_even
    # otherwise, it's odd
    jmp     pow_odd
    
pow_basecase:
    movq    $1, %rax 
    jmp     pow_return
pow_even:
    # don't need to change x
    # p = p//2
    # (pow(x,p//2))**2
    movq    %r12, %rdi
    sarq    %r13
    movq    %r13, %rsi
    callq   pow
    # square result
    movq    %rax, %rdi
    movq    %rax, %rsi
    callq   mul
    jmp     pow_return
pow_odd:
    # p -= 1
    # want: pow(x,p-1)*x
    subq    $1, %r13 
    movq    %r13, %rsi
    movq    %r12, %rdi
    callq   pow
    movq    %rax, %rsi
    movq    %r12, %rdi
    # multiply result time x
    callq   mul
    jmp     pow_return
pow_return:
    # restore r12, r13
    movq   -8(%rbp), %r12
    movq   -16(%rbp), %r13
    # resore stack frame
    movq    %rbp, %rsp
    popq    %rbp
    retq

