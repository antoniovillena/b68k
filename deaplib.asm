;Copyright 2017 Antonio Villena

;Permission is hereby granted, free of charge, to any person obtaining a copy
;of this software and associated documentation files (the "Software"), to deal
;in the Software without restriction, including without limitation the rights
;to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;copies of the Software, and to permit persons to whom the Software is
;furnished to do so, subject to the following conditions:

;The above copyright notice and this permission notice shall be included in
;all copies or substantial portions of the Software.

;THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;SOFTWARE.

MAXINLINE EQU 61

M_GETBIT: macro
          add.b     d0, d0
          bne.s     .loop\@
          move.b    -(a0), d0
          addx.b    d0, d0
.loop\@
          endm

deaplip:  moveq.l   #-1, d6
          moveq.l   #MAXINLINE-1, d4
.restart: move.b    -(a0), -(a1)
          move.b    -(a0), d0
          bpl.s     .restart
          addx.b    d0, d0
          moveq.l   #1, d1
          moveq.l   #0, d2
          add.b     d0, d0
          bne.s     .skipex
          bra.s     .skip2

.copyby:  move.b    -(a0), -(a1)
.mainlo:  M_GETBIT
          bcc.s     .copyby
          moveq.l   #1, d1
          moveq.l   #0, d2
          bra.s     .skip
.lenval:  add.b     d0, d0
          bne.s     .lenexit
          move.b    -(a0), d0
          addx.b    d0, d0
.lenexit: addx.w    d1, d1
.skip:    add.b     d0, d0
          bne.s     .skipex
.skip2:   move.b    -(a0), d0
          addx.b    d0, d0
.skipex:  bcc.s     .lenval
          move.b    d1, d5
          eor.b     d6, d5
          beq.s     .return
          move.b    -(a0), d3
          bpl.s     .offend
.nexbit:  M_GETBIT
          addx.b    d2, d2
          M_GETBIT
          addx.b    d2, d2
          M_GETBIT
          addx.b    d2, d2
          M_GETBIT
          addx.b    d2, d2
          lsl.w     #7, d2
          add.w     d3, d2
          lea       1(a1,d2), a2
          cmp.w     d4, d1
          ble.s     .turbo
          lsr.w     #1, d1
          bcc.s     .bucle1
.bucle:   move.b    -(a2), -(a1)
.bucle1:  move.b    -(a2), -(a1)
          dbra.s    d1, .bucle
          bra.s     .mainlo
.return:  rts
.offend:  lea       1(a1,d3), a2
          cmp.w     d4, d1
          ble.s     .turbo
          lsr.w     #1, d1
          bcc.s     .bucla1
.bucla:   move.b    -(a2), -(a1)
.bucla1:  move.b    -(a2), -(a1)
          dbra.s    d1, .bucla
          jmp       .mainlo

.turbo:   add.w     d1, d1
          neg.w     d1
          lea       .final(pc,d1.w), a5
          jmp       (a5)
          rept      MAXINLINE
          move.b    -(a2), -(a1)
          endr
.final:   move.b    -(a2), -(a1)
          jmp       .mainlo
