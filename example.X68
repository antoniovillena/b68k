        ORG     $1000


START:
        lea     final, a0
        move.w  #$2ffc, a1
        bsr     b68k
loop:   bra     loop

        include b68k_fast.asm

        incbin "example.b68k"
final:
        END     START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
