bits 64

section .text

global tossCoin

tossCoin:
        ; rdi-in = number of total trial
    mov   rcx,rdi    ; rcx = number of total trial
    shr   rdi,6    ; rdi = quotient of rdi divided by 64
    xor   r9,r9    ; r9 = 0 = total number of heads
    test   rdi,rdi
   .loopUntilR8Zero:
        jz  .breakR8Zero    ; if rdi == 0
            ; rdi != 0
        rdrand   rax    ; rax = random 64 bits
        popcnt   rax,rax    ; rax = number of 1s of rax
        add   r9,rax    ; r9 = r9 + rax
        dec   rdi    ; rdi = rdi - 1
        jmp  .loopUntilR8Zero
   .breakR8Zero:
    mov   rdi,rcx    ; rdi = number of total trial
    and   rcx,3fh    ; rcx = remainder of rcx divided by 64
    mov   al,1
    shl   rax,cl    ; rax = 2^cl
    mov   rcx,rax    ; rcx = rax
    rdrand   rax    ; rax = random 64 bits
    dec   rcx    ; rcx = rcx - 1 (least significant bits set)
    and   rax,rcx    ; clear most significant bits of rax
    popcnt   rax,rax    ; rax = number of 1s of rax
    add   rax,r9    ; rax = total number of random 1s
    cvtsi2sd   xmm0,rax    ; xmm0 = (double)rax
    ret    ; return xmm0, rax
