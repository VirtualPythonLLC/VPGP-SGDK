    | void unpack_dico0(u8* buf)
    |
    | Registers use:
    | a1.L = destination buffer
    | a3.L = movie src
    | d1.L = remaining word
    |
    .globl  unpack_dico0
unpack_dico0:

    move.l %a2,%a1              | a1 = dest
    moveq #16,%d1               | d1 = remaining word

.unpack_dico0_loop:
    movq #0,%d0
    move.b (%a3)+,%d0
    jeq .unpack_dico0_unpacked
    cmpi.b #30,%d0
    jls .unpack_dico0_varpacked

    add.w %d0,%d0

.unpack_dico0_packed_base:
    move.w (.unpack_dico0_packed_table-.unpack_dico0_packed_base)-2(%pc,%d0.w),(%a1)+
    subq.b #1,%d1
    jne .unpack_dico0_loop
    rts

    .align 4
.unpack_dico0_packed_table:
    dc.w 0x0000
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0xCCCC
    dc.w 0x3333
    dc.w 0xCCCC
    dc.w 0x3333
    dc.w 0xCCCC
    dc.w 0x3333
    dc.w 0xCCCC
    dc.w 0x3333
    dc.w 0x5555
    dc.w 0x5555
    dc.w 0x5555
    dc.w 0x5555
    dc.w 0xFF00
    dc.w 0x00FF
    dc.w 0xFF00
    dc.w 0x00FF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0xCCCC
    dc.w 0x3333
    dc.w 0x5555
    dc.w 0x00FF
    dc.w 0xFF00
    dc.w 0x1111
    dc.w 0x4444
    dc.w 0xAAAA
    dc.w 0xC000
    dc.w 0xFFFC
    dc.w 0x3FFF
    dc.w 0x0003
    dc.w 0xBBBB
    dc.w 0xCFFF
    dc.w 0x000C
    dc.w 0x0FFF
    dc.w 0xEEEE
    dc.w 0x0001
    dc.w 0x4000
    dc.w 0xBFFF
    dc.w 0x000F
    dc.w 0xFFF0
    dc.w 0xCC00
    dc.w 0x1000
    dc.w 0xFFF3
    dc.w 0x0004
    dc.w 0x3000
    dc.w 0xFFFE
    dc.w 0x00CC
    dc.w 0x0033
    dc.w 0xEFFF
    dc.w 0xF000
    dc.w 0xFFCC
    dc.w 0x33FF
    dc.w 0xFFFB
    dc.w 0xCCFF
    dc.w 0x3300
    dc.w 0xFF33
    dc.w 0x7777
    dc.w 0xDDDD
    dc.w 0x9999
    dc.w 0x6666
    dc.w 0x0002
    dc.w 0xFFFD
    dc.w 0x2333
    dc.w 0x003F
    dc.w 0x0008
    dc.w 0xFFC0
    dc.w 0xFFF7
    dc.w 0x0CCC
    dc.w 0xCCC0
    dc.w 0x7333
    dc.w 0xCCCF
    dc.w 0x3337
    dc.w 0x0011
    dc.w 0x2222
    dc.w 0xBBFF
    dc.w 0x00CF
    dc.w 0x8000
    dc.w 0x03FF
    dc.w 0xFC00
    dc.w 0xDCCC
    dc.w 0xFCCC
    dc.w 0x7FFF
    dc.w 0xCCC8
    dc.w 0x0CFF
    dc.w 0x4400
    dc.w 0x3332
    dc.w 0x2000
    dc.w 0x8888
    dc.w 0x0333
    dc.w 0x333F
    dc.w 0xDFFF
    dc.w 0x8CCC
    dc.w 0xFF30
    dc.w 0xF300
    dc.w 0xEEFF
    dc.w 0xFFEE
    dc.w 0x1100
    dc.w 0x0044
    dc.w 0xCCCD
    dc.w 0x0023
    dc.w 0x3330
    dc.w 0xF333
    dc.w 0xFFDC
    dc.w 0xC400
    dc.w 0x3BFF
    dc.w 0xFFBB
    dc.w 0x37FF
    dc.w 0x008C
    dc.w 0xC800
    dc.w 0x3100
    dc.w 0xFF73
    dc.w 0x0013
    dc.w 0xCEFF
    dc.w 0xCDFF
    dc.w 0x3200
    dc.w 0x2233
    dc.w 0x33BF
    dc.w 0xCC40
    dc.w 0xFFEC
    dc.w 0x004C
    dc.w 0x7733
    dc.w 0xFFFA
    dc.w 0xDDCC
    dc.w 0x77BB
    dc.w 0x0111
    dc.w 0x0233
    dc.w 0x3377
    dc.w 0xFFB3
    dc.w 0x3310
    dc.w 0xFDCC
    dc.w 0x5000
    dc.w 0x0133
    dc.w 0xBBBF
    dc.w 0xFFB7
    dc.w 0xCCC4
    dc.w 0xCCEF
    dc.w 0x0012
    dc.w 0x04CC
    dc.w 0xEEDD
    dc.w 0xFECC
    dc.w 0xCC88
    dc.w 0x1122
    dc.w 0x2100
    dc.w 0xFFED
    dc.w 0x08CC
    dc.w 0x3322
    dc.w 0xEEEF
    dc.w 0x333B
    dc.w 0xF733
    dc.w 0xFB33
    dc.w 0x8844
    dc.w 0x0048
    dc.w 0x4440
    dc.w 0x0444
    dc.w 0x3321
    dc.w 0x337B
    dc.w 0xBB77
    dc.w 0x8400
    dc.w 0x88CC
    dc.w 0x7BFF
    dc.w 0x04FF
    dc.w 0xCC84
    dc.w 0xFE00
    dc.w 0x3331
    dc.w 0xCC80
    dc.w 0xDEFF
    dc.w 0xFB00
    dc.w 0xFEEE
    dc.w 0xAFFF
    dc.w 0x1110
    dc.w 0xB733
    dc.w 0x033F
    dc.w 0x337F
    dc.w 0x1233
    dc.w 0x00EF
    dc.w 0xFF10
    dc.w 0xDDEE
    dc.w 0xFF40
    dc.w 0xCCCE
    dc.w 0x01FF
    dc.w 0x0005
    dc.w 0xFBBB
    dc.w 0xAAA5
    dc.w 0x000E
    dc.w 0x2211
    dc.w 0x7BBB
    dc.w 0xCCDF
    dc.w 0xFCC0
    dc.w 0xCCDD
    dc.w 0xFFF4
    dc.w 0x3320
    dc.w 0x0EFF
    dc.w 0xEDCC
    dc.w 0x777B
    dc.w 0x1333
    dc.w 0xCCDE
    dc.w 0x000B
    dc.w 0x4CCC
    dc.w 0x5550
    dc.w 0xF400
    dc.w 0xFD00
    dc.w 0x00BF
    dc.w 0x08FF
    dc.w 0xF330
    dc.w 0x48CC
    dc.w 0xECCC
    dc.w 0x4488
    dc.w 0xFFF1
    dc.w 0x0CCF
    dc.w 0xFFB0
    dc.w 0xFFAA
    dc.w 0x0BFF
    dc.w 0xE000
    dc.w 0x000D
    dc.w 0x4FFF
    dc.w 0xFFF8
    dc.w 0x02FF
    dc.w 0xB000
    dc.w 0xAA55
    dc.w 0xFF80
    dc.w 0x8FFF
    dc.w 0xB777
    dc.w 0x5500
    dc.w 0xEDDD
    dc.w 0xFFE0
    dc.w 0xF100
    dc.w 0x1222
    dc.w 0xF700
    dc.w 0x004F
    dc.w 0xB333
    dc.w 0xFFD0
    dc.w 0x1FFF
    dc.w 0x008F
    dc.w 0xD000
    dc.w 0x1155
    dc.w 0x00DF
    dc.w 0x5566
    dc.w 0xFF20
    dc.w 0xEEED
    dc.w 0x1112
    dc.w 0xFFF2

.unpack_dico0_varpacked:
    add.w %d0,%d0
    add.w %d0,%d0
.unpack_dico0_varpacked_base:
    move.l (.unpack_dico0_varpacked_table-.unpack_dico0_varpacked_base)-2(%pc,%d0.w),%a0
    jmp (%a0)

    .align 4
.unpack_dico0_varpacked_table:
    .long .unpack_dico0_word0
    .long .unpack_dico0_word1
    .long .unpack_dico0_word2
    .long .unpack_dico0_word3
    .long .unpack_dico0_word4
    .long .unpack_dico0_word5
    .long .unpack_dico0_word6
    .long .unpack_dico0_word7
    .long .unpack_dico0_word8
    .long .unpack_dico0_word9
    .long .unpack_dico0_word10
    .long .unpack_dico0_word11
    .long .unpack_dico0_word12
    .long .unpack_dico0_word13
    .long .unpack_dico0_word14
    .long .unpack_dico0_word15
    .long .unpack_dico0_word16
    .long .unpack_dico0_word17
    .long .unpack_dico0_word18
    .long .unpack_dico0_word19
    .long .unpack_dico0_word20
    .long .unpack_dico0_word21
    .long .unpack_dico0_word22
    .long .unpack_dico0_word23
    .long .unpack_dico0_word24
    .long .unpack_dico0_word25
    .long .unpack_dico0_word26
    .long .unpack_dico0_word27
    .long .unpack_dico0_word28
    .long .unpack_dico0_word29
    .long .unpack_dico0_word30

.unpack_dico0_word0:
    move.w #0x0000,(%a1)+
    subq.w #1,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word1:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #16,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word2:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #16,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word3:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #12,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word4:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #12,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word5:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word6:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word7:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #6,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word8:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #6,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word9:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word10:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word11:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word12:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word13:
    move.l #0x00000000,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word14:
    move.l #0xFFFFFFFF,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word15:
    move.l #0xCCCCCCCC,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word16:
    move.l #0x33333333,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word17:
    move.l #0xCCCCCCCC,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word18:
    move.l #0x33333333,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word19:
    move.l #0xCCCCCCCC,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word20:
    move.l #0x33333333,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word21:
    move.l #0xCCCCCCCC,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word22:
    move.l #0x33333333,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word23:
    move.l #0x55555555,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word24:
    move.l #0x55555555,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word25:
    move.l #0x55555555,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word26:
    move.l #0x55555555,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word27:
    move.l #0xFF00FF00,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word28:
    move.l #0x00FF00FF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word29:
    move.l #0xFF00FF00,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_word30:
    move.l #0x00FF00FF,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico0_loop
    rts

.unpack_dico0_unpacked:
    move.b (%a3)+,(%a1)+
    move.b (%a3)+,(%a1)+
    subq.b #1,%d1
    jne .unpack_dico0_loop
    rts


    | void unpack_dico1(u8* buf)
    |
    | Registers use:
    | a1.L = destination buffer
    | a3.L = movie src
    | d1.L = remaining word
    |
    .globl  unpack_dico1
unpack_dico1:

    move.l %a2,%a1              | a1 = dest
    moveq #16,%d1               | d1 = remaining word

.unpack_dico1_loop:
    movq #0,%d0
    move.b (%a3)+,%d0
    jeq .unpack_dico1_unpacked
    cmpi.b #24,%d0
    jls .unpack_dico1_varpacked

    add.w %d0,%d0

.unpack_dico1_packed_base:
    move.w (.unpack_dico1_packed_table-.unpack_dico1_packed_base)-2(%pc,%d0.w),(%a1)+
    subq.b #1,%d1
    jne .unpack_dico1_loop
    rts

    .align 4
.unpack_dico1_packed_table:
    dc.w 0x0000
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0xCCCC
    dc.w 0xCCCC
    dc.w 0xCCCC
    dc.w 0xCCCC
    dc.w 0x5555
    dc.w 0x5555
    dc.w 0x5555
    dc.w 0x5555
    dc.w 0x00FF
    dc.w 0x00FF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0xCCCC
    dc.w 0x5555
    dc.w 0x00FF
    dc.w 0x4444
    dc.w 0xAAAA
    dc.w 0xC000
    dc.w 0x0003
    dc.w 0x000C
    dc.w 0xEEEE
    dc.w 0x0001
    dc.w 0x4000
    dc.w 0x000F
    dc.w 0xCC00
    dc.w 0x1000
    dc.w 0x0004
    dc.w 0x3000
    dc.w 0x00CC
    dc.w 0x0033
    dc.w 0xF000
    dc.w 0xCCFF
    dc.w 0xDDDD
    dc.w 0x9999
    dc.w 0x0002
    dc.w 0x003F
    dc.w 0x0008
    dc.w 0x0CCC
    dc.w 0xCCC0
    dc.w 0xCCCF
    dc.w 0x0011
    dc.w 0x00CF
    dc.w 0x8000
    dc.w 0xFC00
    dc.w 0xDCCC
    dc.w 0xFCCC
    dc.w 0xCCC8
    dc.w 0x0CFF
    dc.w 0x4400
    dc.w 0x2000
    dc.w 0x8888
    dc.w 0x8CCC
    dc.w 0xEEFF
    dc.w 0x0044
    dc.w 0xCCCD
    dc.w 0x0023
    dc.w 0xC400
    dc.w 0x008C
    dc.w 0xC800
    dc.w 0x0013
    dc.w 0xCC40
    dc.w 0x004C
    dc.w 0x5000
    dc.w 0xCCC4
    dc.w 0xCCEF
    dc.w 0x0012
    dc.w 0x04CC
    dc.w 0xCC88
    dc.w 0x08CC
    dc.w 0xEEEF
    dc.w 0x8844
    dc.w 0x0048
    dc.w 0x4440
    dc.w 0x0444
    dc.w 0x8400
    dc.w 0x88CC
    dc.w 0x04FF
    dc.w 0xCC84
    dc.w 0xCC80
    dc.w 0xFEEE
    dc.w 0x00EF
    dc.w 0xDDEE
    dc.w 0xCCCE
    dc.w 0x0005
    dc.w 0x000E
    dc.w 0xCCDF
    dc.w 0xFCC0
    dc.w 0xCCDD
    dc.w 0xCCDE
    dc.w 0x000B
    dc.w 0x4CCC
    dc.w 0xF400
    dc.w 0x00BF
    dc.w 0x08FF
    dc.w 0x48CC
    dc.w 0xECCC
    dc.w 0x4488
    dc.w 0x0CCF
    dc.w 0xE000
    dc.w 0x000D
    dc.w 0xB000
    dc.w 0xEDDD
    dc.w 0x004F
    dc.w 0x008F
    dc.w 0xD000
    dc.w 0x00DF
    dc.w 0x5566
    dc.w 0x001F
    dc.w 0x7000
    dc.w 0x4455
    dc.w 0x0007
    dc.w 0x0010
    dc.w 0x8444
    dc.w 0x007F
    dc.w 0xF800
    dc.w 0x002F
    dc.w 0x5599
    dc.w 0x000A
    dc.w 0x0040
    dc.w 0x0400
    dc.w 0x4445
    dc.w 0x5556
    dc.w 0x8440
    dc.w 0x8884
    dc.w 0xDDDE
    dc.w 0xA000
    dc.w 0xC840
    dc.w 0x5559
    dc.w 0x4448
    dc.w 0x048C
    dc.w 0xFEFF
    dc.w 0xC884
    dc.w 0xFAAA
    dc.w 0x00AF
    dc.w 0x4888
    dc.w 0xA555
    dc.w 0xC888
    dc.w 0x0037
    dc.w 0xAAEE
    dc.w 0x003B
    dc.w 0x888C
    dc.w 0x99AA
    dc.w 0x5999
    dc.w 0x0022
    dc.w 0x00CE
    dc.w 0xEC00
    dc.w 0x9955
    dc.w 0x005F
    dc.w 0xDC00
    dc.w 0x00CD
    dc.w 0xAABB
    dc.w 0x8CFF
    dc.w 0x5444
    dc.w 0xAAAE
    dc.w 0x0009
    dc.w 0x4CFF
    dc.w 0x0055
    dc.w 0x0448
    dc.w 0xAEEE
    dc.w 0x9555
    dc.w 0x0006
    dc.w 0xC844
    dc.w 0xAAFF
    dc.w 0x6000
    dc.w 0x9000
    dc.w 0xAAAB
    dc.w 0x999A
    dc.w 0x04CF
    dc.w 0x55AA
    dc.w 0x0CEF
    dc.w 0x488C
    dc.w 0x8840
    dc.w 0x0488
    dc.w 0x6555
    dc.w 0xCC44
    dc.w 0x0088
    dc.w 0x0800
    dc.w 0x009F
    dc.w 0x9995
    dc.w 0x006F
    dc.w 0xFC80
    dc.w 0xFC40
    dc.w 0xEEAA
    dc.w 0xDDEF
    dc.w 0x0020
    dc.w 0x0080
    dc.w 0xDD99
    dc.w 0x08CF
    dc.w 0xDCC8
    dc.w 0x0CCD
    dc.w 0x448C
    dc.w 0x99DD
    dc.w 0x8800
    dc.w 0xFDFF
    dc.w 0x0CDF
    dc.w 0xFCFF
    dc.w 0xFCC4
    dc.w 0xDCC0
    dc.w 0x8CCF
    dc.w 0x555A
    dc.w 0xEEEA
    dc.w 0x9DDD
    dc.w 0xF0FF
    dc.w 0xCCEE
    dc.w 0x0030
    dc.w 0xDDFF
    dc.w 0xECC0
    dc.w 0x0440
    dc.w 0xA999
    dc.w 0xFCC8
    dc.w 0x999D
    dc.w 0x0C00
    dc.w 0xDDD9
    dc.w 0x4CCF
    dc.w 0x5400
    dc.w 0x00C0
    dc.w 0x0015
    dc.w 0x0CCE
    dc.w 0xEAAA
    dc.w 0xBAAA
    dc.w 0xD999
    dc.w 0x8CCD
    dc.w 0xAAAF
    dc.w 0xC8CC
    dc.w 0xCC8C
    dc.w 0xDCC4
    dc.w 0x44CC
    dc.w 0x04EF
    dc.w 0x0045
    dc.w 0xAEFF
    dc.w 0x0050
    dc.w 0x0021
    dc.w 0x004E
    dc.w 0x008E
    dc.w 0x008D
    dc.w 0xE400
    dc.w 0x001B
    dc.w 0x004D
    dc.w 0x9888
    dc.w 0xDCFF
    dc.w 0xD400

.unpack_dico1_varpacked:
    add.w %d0,%d0
    add.w %d0,%d0
.unpack_dico1_varpacked_base:
    move.l (.unpack_dico1_varpacked_table-.unpack_dico1_varpacked_base)-2(%pc,%d0.w),%a0
    jmp (%a0)

    .align 4
.unpack_dico1_varpacked_table:
    .long .unpack_dico1_word0
    .long .unpack_dico1_word1
    .long .unpack_dico1_word2
    .long .unpack_dico1_word3
    .long .unpack_dico1_word4
    .long .unpack_dico1_word5
    .long .unpack_dico1_word6
    .long .unpack_dico1_word7
    .long .unpack_dico1_word8
    .long .unpack_dico1_word9
    .long .unpack_dico1_word10
    .long .unpack_dico1_word11
    .long .unpack_dico1_word12
    .long .unpack_dico1_word13
    .long .unpack_dico1_word14
    .long .unpack_dico1_word15
    .long .unpack_dico1_word16
    .long .unpack_dico1_word17
    .long .unpack_dico1_word18
    .long .unpack_dico1_word19
    .long .unpack_dico1_word20
    .long .unpack_dico1_word21
    .long .unpack_dico1_word22
    .long .unpack_dico1_word23
    .long .unpack_dico1_word24

.unpack_dico1_word0:
    move.w #0x0000,(%a1)+
    subq.w #1,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word1:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #16,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word2:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #16,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word3:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #12,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word4:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #12,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word5:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word6:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word7:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #6,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word8:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #6,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word9:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word10:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word11:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word12:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word13:
    move.l #0x00000000,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word14:
    move.l #0xFFFFFFFF,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word15:
    move.l #0xCCCCCCCC,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word16:
    move.l #0xCCCCCCCC,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word17:
    move.l #0xCCCCCCCC,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word18:
    move.l #0xCCCCCCCC,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word19:
    move.l #0x55555555,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word20:
    move.l #0x55555555,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word21:
    move.l #0x55555555,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word22:
    move.l #0x55555555,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word23:
    move.l #0x00FF00FF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_word24:
    move.l #0x00FF00FF,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico1_loop
    rts

.unpack_dico1_unpacked:
    move.b (%a3)+,(%a1)+
    move.b (%a3)+,(%a1)+
    subq.b #1,%d1
    jne .unpack_dico1_loop
    rts


    | void unpack_dico2(u8* buf)
    |
    | Registers use:
    | a1.L = destination buffer
    | a3.L = movie src
    | d1.L = remaining word
    |
    .globl  unpack_dico2
unpack_dico2:

    move.l %a2,%a1              | a1 = dest
    moveq #16,%d1               | d1 = remaining word

.unpack_dico2_loop:
    movq #0,%d0
    move.b (%a3)+,%d0
    jeq .unpack_dico2_unpacked
    cmpi.b #24,%d0
    jls .unpack_dico2_varpacked

    add.w %d0,%d0

.unpack_dico2_packed_base:
    move.w (.unpack_dico2_packed_table-.unpack_dico2_packed_base)-2(%pc,%d0.w),(%a1)+
    subq.b #1,%d1
    jne .unpack_dico2_loop
    rts

    .align 4
.unpack_dico2_packed_table:
    dc.w 0x0000
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x3333
    dc.w 0x3333
    dc.w 0x3333
    dc.w 0x3333
    dc.w 0x5555
    dc.w 0x5555
    dc.w 0x5555
    dc.w 0x5555
    dc.w 0xFF00
    dc.w 0xFF00
    dc.w 0x0000
    dc.w 0xFFFF
    dc.w 0x3333
    dc.w 0x5555
    dc.w 0xFF00
    dc.w 0x1111
    dc.w 0xAAAA
    dc.w 0xFFFC
    dc.w 0x3FFF
    dc.w 0xBBBB
    dc.w 0xCFFF
    dc.w 0x0FFF
    dc.w 0xBFFF
    dc.w 0xFFF0
    dc.w 0xFFF3
    dc.w 0xFFFE
    dc.w 0xEFFF
    dc.w 0xFFCC
    dc.w 0x33FF
    dc.w 0xFFFB
    dc.w 0x3300
    dc.w 0xFF33
    dc.w 0x7777
    dc.w 0x6666
    dc.w 0xFFFD
    dc.w 0x2333
    dc.w 0xFFC0
    dc.w 0xFFF7
    dc.w 0x7333
    dc.w 0x3337
    dc.w 0x2222
    dc.w 0xBBFF
    dc.w 0x03FF
    dc.w 0x7FFF
    dc.w 0x3332
    dc.w 0x0333
    dc.w 0x333F
    dc.w 0xDFFF
    dc.w 0xFF30
    dc.w 0xF300
    dc.w 0xFFEE
    dc.w 0x1100
    dc.w 0x3330
    dc.w 0xF333
    dc.w 0xFFDC
    dc.w 0x3BFF
    dc.w 0xFFBB
    dc.w 0x37FF
    dc.w 0xFF73
    dc.w 0x33BF
    dc.w 0xFFEC
    dc.w 0x7733
    dc.w 0xFFFA
    dc.w 0x77BB
    dc.w 0x0111
    dc.w 0x3377
    dc.w 0xFFB3
    dc.w 0x3310
    dc.w 0xBBBF
    dc.w 0xFFB7
    dc.w 0xFFED
    dc.w 0x3322
    dc.w 0x333B
    dc.w 0xF733
    dc.w 0xFB33
    dc.w 0x3321
    dc.w 0x337B
    dc.w 0xBB77
    dc.w 0x7BFF
    dc.w 0x3331
    dc.w 0xFB00
    dc.w 0xAFFF
    dc.w 0x1110
    dc.w 0xB733
    dc.w 0x033F
    dc.w 0x337F
    dc.w 0xFF10
    dc.w 0xFF40
    dc.w 0xFBBB
    dc.w 0xAAA5
    dc.w 0x2211
    dc.w 0x7BBB
    dc.w 0xFFF4
    dc.w 0x3320
    dc.w 0x777B
    dc.w 0x1333
    dc.w 0x5550
    dc.w 0xF330
    dc.w 0xFFF1
    dc.w 0xFFB0
    dc.w 0xFFAA
    dc.w 0x0BFF
    dc.w 0x4FFF
    dc.w 0xFFF8
    dc.w 0xAA55
    dc.w 0xFF80
    dc.w 0x8FFF
    dc.w 0xB777
    dc.w 0x5500
    dc.w 0xFFE0
    dc.w 0x1222
    dc.w 0xF700
    dc.w 0xB333
    dc.w 0xFFD0
    dc.w 0x1FFF
    dc.w 0x1155
    dc.w 0xFF20
    dc.w 0xFFF2
    dc.w 0xFF70
    dc.w 0xBBB7
    dc.w 0x0100
    dc.w 0x2FFF
    dc.w 0x07FF
    dc.w 0xFB73
    dc.w 0x3777
    dc.w 0x1555
    dc.w 0x7773
    dc.w 0x7BBF
    dc.w 0x4555
    dc.w 0xFBFF
    dc.w 0x1115
    dc.w 0xFFBF
    dc.w 0x37BF
    dc.w 0xFFF5
    dc.w 0xFF50
    dc.w 0x5666
    dc.w 0x2221
    dc.w 0x377B
    dc.w 0xFFEF
    dc.w 0x5FFF
    dc.w 0x5544
    dc.w 0xB773
    dc.w 0xFFC8
    dc.w 0xFB77
    dc.w 0xFF31
    dc.w 0xFBB7
    dc.w 0x13FF
    dc.w 0x23FF
    dc.w 0xFF32
    dc.w 0xFFA0
    dc.w 0xFFC4
    dc.w 0x37BB
    dc.w 0xFF77
    dc.w 0xFFDD
    dc.w 0x66AA
    dc.w 0x7300
    dc.w 0x9AAA
    dc.w 0x6655
    dc.w 0x6AAA
    dc.w 0xFFF6
    dc.w 0x5554
    dc.w 0xFFF9
    dc.w 0xABBB
    dc.w 0x2210
    dc.w 0xB300
    dc.w 0x666A
    dc.w 0x3311
    dc.w 0x9FFF
    dc.w 0x6FFF
    dc.w 0x5511
    dc.w 0x77BF
    dc.w 0x33BB
    dc.w 0x03BF
    dc.w 0x0555
    dc.w 0x6665
    dc.w 0x77FF
    dc.w 0x5551
    dc.w 0x5111
    dc.w 0xBB73
    dc.w 0xFF90
    dc.w 0x0200
    dc.w 0xFF60
    dc.w 0x037F
    dc.w 0xF310
    dc.w 0x6777
    dc.w 0xAA99
    dc.w 0xF730
    dc.w 0xFFCF
    dc.w 0xF7FF
    dc.w 0x0337
    dc.w 0x7766
    dc.w 0x2337
    dc.w 0xF320
    dc.w 0x233F
    dc.w 0xFB30
    dc.w 0xFFDF
    dc.w 0xBBAA
    dc.w 0x5AAA
    dc.w 0x033B
    dc.w 0xFF0F
    dc.w 0xFF3F
    dc.w 0xF331
    dc.w 0xF3FF
    dc.w 0x133F
    dc.w 0x2200
    dc.w 0xFF7F
    dc.w 0x7330
    dc.w 0x7776
    dc.w 0x0110
    dc.w 0xAAA9
    dc.w 0xF332
    dc.w 0xFB10
    dc.w 0x7332
    dc.w 0x0300
    dc.w 0xBBBA
    dc.w 0xB330
    dc.w 0x233B
    dc.w 0xAA66
    dc.w 0x2266
    dc.w 0x73FF
    dc.w 0xFFE4
    dc.w 0xBB33
    dc.w 0xABFF
    dc.w 0x3323
    dc.w 0x7331
    dc.w 0xAAA6
    dc.w 0xFFA5
    dc.w 0xFFB1
    dc.w 0x3BBF
    dc.w 0x1BFF
    dc.w 0x3733
    dc.w 0xFFB2
    dc.w 0x0155
    dc.w 0x0F00
    dc.w 0xFFEA
    dc.w 0xA666
    dc.w 0x0500
    dc.w 0x27FF
    dc.w 0x2BFF
    dc.w 0xFFCD
    dc.w 0xFF37

.unpack_dico2_varpacked:
    add.w %d0,%d0
    add.w %d0,%d0
.unpack_dico2_varpacked_base:
    move.l (.unpack_dico2_varpacked_table-.unpack_dico2_varpacked_base)-2(%pc,%d0.w),%a0
    jmp (%a0)

    .align 4
.unpack_dico2_varpacked_table:
    .long .unpack_dico2_word0
    .long .unpack_dico2_word1
    .long .unpack_dico2_word2
    .long .unpack_dico2_word3
    .long .unpack_dico2_word4
    .long .unpack_dico2_word5
    .long .unpack_dico2_word6
    .long .unpack_dico2_word7
    .long .unpack_dico2_word8
    .long .unpack_dico2_word9
    .long .unpack_dico2_word10
    .long .unpack_dico2_word11
    .long .unpack_dico2_word12
    .long .unpack_dico2_word13
    .long .unpack_dico2_word14
    .long .unpack_dico2_word15
    .long .unpack_dico2_word16
    .long .unpack_dico2_word17
    .long .unpack_dico2_word18
    .long .unpack_dico2_word19
    .long .unpack_dico2_word20
    .long .unpack_dico2_word21
    .long .unpack_dico2_word22
    .long .unpack_dico2_word23
    .long .unpack_dico2_word24

.unpack_dico2_word0:
    move.w #0x0000,(%a1)+
    subq.w #1,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word1:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #16,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word2:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #16,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word3:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #12,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word4:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subi.w #12,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word5:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word6:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word7:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #6,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word8:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #6,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word9:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word10:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word11:
    move.l #0x00000000,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word12:
    move.l #0xFFFFFFFF,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word13:
    move.l #0x00000000,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word14:
    move.l #0xFFFFFFFF,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word15:
    move.l #0x33333333,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word16:
    move.l #0x33333333,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word17:
    move.l #0x33333333,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word18:
    move.l #0x33333333,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word19:
    move.l #0x55555555,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #8,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word20:
    move.l #0x55555555,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word21:
    move.l #0x55555555,%d0

    move.l %d0,(%a1)+
    move.w %d0,(%a1)+
    subq.w #3,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word22:
    move.l #0x55555555,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word23:
    move.l #0xFF00FF00,%d0

    move.l %d0,(%a1)+
    move.l %d0,(%a1)+
    subq.w #4,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_word24:
    move.l #0xFF00FF00,(%a1)+
    subq.w #2,%d1
    jgt .unpack_dico2_loop
    rts

.unpack_dico2_unpacked:
    move.b (%a3)+,(%a1)+
    move.b (%a3)+,(%a1)+
    subq.b #1,%d1
    jne .unpack_dico2_loop
    rts












