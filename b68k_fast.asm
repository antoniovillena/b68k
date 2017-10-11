; -----------------------------------------------------------------------------
; B68K by Einar Saukas, Antonio Villena. With suggestions of Leander
; Based on http://www.worldofspectrum.org/infoseekid.cgi?id=0027996
; "Fast" version (264 bytes only)
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

offene: moveq   #0, d2
        add.b   d0, d0
        addx.b  d2, d2
        GETBIT
        addx.b  d2, d2
        add.b   d0, d0
        addx.b  d2, d2
        GETBIT
        roxl.w  #8, d2
        add     d3, d2
        lea     1(a1, d2), a2
        lsr     #1, d1
        bcc.s   comp1e
        bne.s   comp2e
        move.b  -(a2), -(a1)
        move.b  -(a2), -(a1)
        bra.s   mainlo

b68k:   moveq   #$80, d0
copybe: move.b  -(a0), -(a1)
mainle: add.b   d0, d0
        beq.s   lb1
        bcs.s   mainco
copybo: move.b  -(a0), -(a1)
mainlo: add.b   d0, d0
        bcc.s   copybe

maince: moveq   #1, d1
        GETBIT
        bcs.s   contie
lenvae: add.b   d0, d0
        addx.w  d1, d1
        GETBIT
        bcc.s   lenvae
contie: move.b  -(a0), d3
        bmi.s   offene

        lea     1(a1, d3), a2
        lsr     #1, d1
        bcc.s   comp1e
        bne.s   comp2e
        move.b  -(a2), -(a1)
        move.b  -(a2), -(a1)
        bra.s   mainlo

comp1e: beq.s   return
        lsr     #1, d1
        bcs.s   bucla3
        bra.s   bucla1
comp2e: lsr     #1, d1
        bcc.s   bucla2
bucla4: move.b  -(a2), -(a1)
bucla3: move.b  -(a2), -(a1)
bucla2: move.b  -(a2), -(a1)
bucla1: move.b  -(a2), -(a1)
        dbra    d1, bucla4
        bra.s   mainlo

return: rts

lb1:    move.b  -(a0), d0
        addx.b  d0, d0
        bcc     copybo

mainco: moveq   #1, d1
        add.b   d0, d0
        bcs.s   contio
lenvao: GETBIT
        addx.w  d1, d1
        add.b   d0, d0
        bcc.s   lenvao
contio: move.b  -(a0), d3
        bmi.s   offeno

        lea     1(a1, d3), a2
        lsr     #1, d1
        bcc.s   comp1o
        bne.s   comp2o
        move.b  -(a2), -(a1)
        move.b  -(a2), -(a1)
        bra     mainle

comp1o: beq.s   return
        lsr     #1, d1
        bcs.s   buclo3
        bra.s   buclo1
comp2o: lsr     #1, d1
        bcc.s   buclo2
buclo4: move.b  -(a2), -(a1)
buclo3: move.b  -(a2), -(a1)
buclo2: move.b  -(a2), -(a1)
buclo1: move.b  -(a2), -(a1)
        dbra    d1, buclo4
        bra     mainle

offeno: moveq   #0, d2
        GETBIT
        addx.b  d2, d2
        add.b   d0, d0
        addx.b  d2, d2
        GETBIT
        addx.b  d2, d2
        add.b   d0, d0
        roxl.w  #8, d2
        add     d3, d2
        lea     1(a1, d2), a2
        lsr     #1, d1
        bcc.s   comp1o
        bne.s   comp2o
        move.b  -(a2), -(a1)
        move.b  -(a2), -(a1)
        bra     mainle
