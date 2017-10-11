; -----------------------------------------------------------------------------
; B68K by Einar Saukas, Antonio Villena. With suggestions of Leander
; Based on http://www.worldofspectrum.org/infoseekid.cgi?id=0027996
; "Medium" version (154 bytes only)
; -----------------------------------------------------------------------------
; Parameters:
;   A0: end of source address (compressed data)
;   A1: end of destination address (decompressing)
; -----------------------------------------------------------------------------
GETBIT macro
        add.b   d0, d0
        bne.s   loop\@
        move.b  -(a0), d0
        addx.b  d0, d0
loop\@ 
        endm

offend: moveq   #0, d2
        GETBIT
        addx.b  d2, d2
        GETBIT
        addx.b  d2, d2
        GETBIT
        addx.b  d2, d2
        GETBIT
        roxl.w  #8, d2
        add     d3, d2
        lea     1(a1, d2), a2
        lsr     #1, d1
        bcc.s   comp1
        bne.s   comp2
        move.b  -(a2), -(a1)
        move.b  -(a2), -(a1)
        bra.s   mainle

b68k:   moveq   #$80, d0
copyby: move.b  -(a0), -(a1)
mainle: GETBIT
        bcc.s   copyby

mainco: moveq   #1, d1
        GETBIT
        bcs.s   contie
lenval: GETBIT
        addx.w  d1, d1
        GETBIT
        bcc.s   lenval
contie: move.b  -(a0), d3
        bmi.s   offend

        lea     1(a1, d3), a2
        lsr     #1, d1
        bcc.s   comp1
        bne.s   comp2
        move.b  -(a2), -(a1)
        move.b  -(a2), -(a1)
        bra.s   mainle

comp1:  beq.s   return
        lsr     #1, d1
        bcs.s   bucla3
        bra.s   bucla1
comp2:  lsr     #1, d1
        bcc.s   bucla2
bucla4: move.b  -(a2), -(a1)
bucla3: move.b  -(a2), -(a1)
bucla2: move.b  -(a2), -(a1)
bucla1: move.b  -(a2), -(a1)
        dbra    d1, bucla4
        bra.s   mainle
