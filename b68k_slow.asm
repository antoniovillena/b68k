; -----------------------------------------------------------------------------
; B68K by Einar Saukas, Antonio Villena. With suggestions of Leander
; Based on http://www.worldofspectrum.org/infoseekid.cgi?id=0027996
; "Slow" version (58 bytes only)
; -----------------------------------------------------------------------------
; Parameters:
;   A0: end of source address (compressed data)
;   A1: end of destination address (decompressing)
; -----------------------------------------------------------------------------
b68k:   moveq   #$80, d0
copyby: move.b  -(a0), -(a1)
mainle: bsr.s   getbit
        bcc.s   copyby

mainco: moveq   #1, d1
        moveq   #0, d3
        bra.s   skip
lenval: bsr.s   getbit
        roxl.w  #1, d1
        beq.s   return
skip:   bsr.s   getbit
        bcc.s   lenval
        move.b  -(a0), d3
        bpl.s   offend

        moveq   #$10, d2
nexbit: bsr.s   getbit
        addx.b  d2, d2
        bcc.s   nexbit
        lsl.w   #7, d2
        add     d2, d3

offend: move.b  (a1,d3), -(a1)
        dbra    d1, offend
        bra.s   mainle

getbit: add.b   d0, d0
        bne.s   return
        move.b  -(a0), d0
        addx.b  d0, d0
return: rts
