	.globl	tile_unpack
tile_unpack:
	movm.l %d2-%d3/%a2-%a3,-(%sp)

	move.l tileWrite,%a2            | a2 = dst
	move.l movie_src,%a3            | a3 = src

	move.b (%a3)+,%d2
	lsl.w #8,%d2
	move.b (%a3)+,%d2               | d2 = remain
	subq.w #1,%d2
	jmi .L16

.L14:
	move.b (%a3)+,%d1

	moveq #31,%d3
	and.b %d1,%d3                   | d3 = extra

	move.b %d1,%d0
	lsr.b #3,%d0
    andi.w #0x1C,%d0                | d0 = header * 4

.LI13:
    move.l (.L13-.LI13)-2(%pc,%d0.w),%a0
    jmp (%a0)

    .align 4
.L13:
	.long .L6
	.long .L7
	.long .L4
	.long .L8
	.long .L10
	.long .L11
	.long .L9
	.long .L12

.L6:
	jsr unpack_dico0

	lea (32,%a2),%a2
	dbra %d2,.L14
	jmp .L16

.L7:
	jsr unpack_dico1

	lea (32,%a2),%a2
	dbra %d2,.L14
	jmp .L16

.L4:
	jsr unpack_dico2

	lea (32,%a2),%a2
	dbra %d2,.L14
	jmp .L16

.L8:
	jsr unpack_plain_and_pix

	lea (32,%a2),%a2
	dbra %d2,.L14
	jmp .L16

.L9:
	move.l %a2,%a0
	sub.l tileWrite,%a0
	add.l tileRead,%a0

	jsr unpack_copy

	lea (32,%a2),%a2
	dbra %d2,.L14
	jmp .L16

.L10:
	move.l %a2,%a0
	sub.l tileWrite,%a0
	add.l tileRead,%a0

	jsr unpack_derive

	lea (32,%a2),%a2
	dbra %d2,.L14
	jmp .L16

.L11:
    moveq #1,%d0
    and.b %d3,%d0
    lsl.w #8,%d0
	move.b (%a3)+,%d0           | d0 = index
	lsl.l #5,%d0
	move.l tileRead,%a0
	add.l %d0,%a0               | a0 = prev tile

	jsr unpack_derive

	lea (32,%a2),%a2
	dbra %d2,.L14
	jmp .L16

.L12:
	jsr unpack_raw

	lea (32,%a2),%a2
	dbra %d2,.L14

.L16:
	move.l %a3,movie_src
	move.l %a2,%d0
	sub.l tileWrite,%d0
	lsr.l #5,%d0

	movm.l (%sp)+,%d2-%d3/%a2-%a3
	rts



    | a2 = dst
    | a3 = src
    .globl  unpack_plain_and_pix
unpack_plain_and_pix:
	moveq #0,%d1
	move.b (%a3)+,%d1

	moveq #15,%d0
	and.w %d1,%d0           | d0 = plain color
	add.w %d0,%d0
	add.w %d0,%d0

	lea cnv_4to32_tab,%a0
	move.l (%a0,%d0.w),%d0

	move.l %a2,%a1          | a1 = dst

	move.l %d0,(%a1)+
	move.l %d0,(%a1)+
	move.l %d0,(%a1)+
	move.l %d0,(%a1)+
	move.l %d0,(%a1)+
	move.l %d0,(%a1)+
	move.l %d0,(%a1)+
	move.l %d0,(%a1)

	lsr.w #4,%d1            | d1 = remain
	subq.w #1,%d1
	moveq #0,%d0

	move.l %a2,%a1          | a1 = dst

.L20:
	move.b (%a3)+,%d0
	add.l %d0,%a1
	move.b (%a3)+,(%a1)
	dbra %d1,.L20

	rts


    | a0 = prev
    | a2 = dst
    | a3 = src
    .globl  unpack_derive
unpack_derive:
	move.l %a2,%a1              | a1 = dst

	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0),(%a1)

	move.l %a2,%a1              | a1 = dst

	move.w %d3,%d1              | d1 = extra
	lsr.w #1,%d1
	subq.w #1,%d1
	jmi .L28

	moveq #0,%d0

.L26:
	move.b (%a3)+,%d0
	add.l %d0,%a1
	move.b (%a3)+,(%a1)
	dbra %d1,.L26

.L28:
	rts


    | a0 = prev
    | a2 = dst
    .globl  unpack_copy
unpack_copy:
	move.l %a2,%a1              | a1 = dst

	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0)+,(%a1)+
	move.l (%a0),(%a1)

	rts


    | a2 = dst
    | a3 = src
    .globl  unpack_raw
unpack_raw:
	move.l %a2,%a1
	moveq #3,%d0

.L33:
	move.b (%a3)+,(%a1)+
	move.b (%a3)+,(%a1)+
	move.b (%a3)+,(%a1)+
	move.b (%a3)+,(%a1)+
	move.b (%a3)+,(%a1)+
	move.b (%a3)+,(%a1)+
	move.b (%a3)+,(%a1)+
	move.b (%a3)+,(%a1)+
	dbra %d0,.L33

	rts
