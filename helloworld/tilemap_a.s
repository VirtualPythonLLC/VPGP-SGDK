	.globl	unpack_rle
unpack_rle:
	movm.l #0x3800,-(%sp)

	move.l 16(%sp),%a0      | a0 = dst
	move.l movie_src,%a1    | a1 = src
	move.w #1120,%d4        | d4 = len

.L38:
	move.b (%a1)+,%d1
	jmi .L29_0

	moveq #0,%d2
	move.b %d1,%d2
	lsr.b #3,%d2            | d2 = col
	jmp .L29

.L29_0:
	moveq #0x40,%d2
	add.b %d2,%d2           | d2 = col

.L29:
	and.w #7,%d1            | d1 = rep
	jeq .L30

	sub.w %d1,%d4           | len -= rep
	subq.w #1,%d1

.L33:
	move.w %d2,(%a0)+
	dbra %d1,.L33

	jra .L26

.L30:
	move.b (%a1)+,%d1
	addq.w #1,%d1           | d1 = rep

	sub.w %d1,%d4           | len -= rep
	subq.w #1,%d1

.L37:
	move.w %d2,(%a0)+
	dbra %d1,.L37

.L26:
	tst.w %d4
	jbgt .L38

	move.l %a1,movie_src
	movm.l (%sp)+,#0x1c
	rts


	.globl	unpack_rle_binary
unpack_rle_binary:
	movm.l #0x3c00,-(%sp)

	move.l 20(%sp),%a0      | a0 = dst
	move.l movie_src,%a1    | a1 = src
	move.w #1120,%d4        | d4 = len

	clr.w %d3
	moveq #0,%d5

.L59:
	move.b (%a1)+,%d1
	jmi .L48_0

	btst #6,%d1
	jne .L48_1

	moveq #0,%d2            | d2 = col
	jmp .L48

.L48_0:
	moveq #0x40,%d2
	add.b %d2,%d2           | d2 = col
	jmp .L48

.L48_1:
	moveq #0x0F,%d2         | d2 = col

.L48:
	and.w #0x1F,%d1         | d1 = rep
	jeq .L51

	sub.w %d1,%d4           | len -= rep
	subq.w #1,%d1

.L54:
	move.w %d2,(%a0)+
	dbra %d1,.L54

	jbra .L45

.L51:
	move.b (%a1)+,%d1
	addq.w #1,%d1           | d1 = rep

	sub.w %d1,%d4           | len -= rep
	subq.w #1,%d1

.L58:
	move.w %d2,(%a0)+
	dbra %d1,.L58

.L45:
	tst.w %d4
	jbgt .L59

	move.l %a1,movie_src
	movm.l (%sp)+,#0x3c
	rts



	.globl	tilemap_prepareBuffer
tilemap_prepareBuffer:                  | take 75 scanlines to execute
	movm.l #0x3c00,-(%sp)

	move.l tilemapUnpackWrite,%a0
	move.l tilemapWrite,%a1
	move.w baseTileInd,%d1
	move.w #0x8F,%d2
	moveq #27,%d4

.L20:
	moveq #4,%d3

.L19:
	move.w (%a0)+,%d0
	and.b %d2,%d0
	jbge .L11
	move.w %d1,%d0
	addq.w #1,%d1
.L11:
	move.w %d0,(%a1)+

	move.w (%a0)+,%d0
	and.b %d2,%d0
	jbge .L12
	move.w %d1,%d0
	addq.w #1,%d1
.L12:
	move.w %d0,(%a1)+

	move.w (%a0)+,%d0
	and.b %d2,%d0
	jbge .L13
	move.w %d1,%d0
	addq.w #1,%d1
.L13:
	move.w %d0,(%a1)+

	move.w (%a0)+,%d0
	and.b %d2,%d0
	jbge .L14
	move.w %d1,%d0
	addq.w #1,%d1
.L14:
	move.w %d0,(%a1)+

	move.w (%a0)+,%d0
	and.b %d2,%d0
	jbge .L15
	move.w %d1,%d0
	addq.w #1,%d1
.L15:
	move.w %d0,(%a1)+

	move.w (%a0)+,%d0
	and.b %d2,%d0
	jbge .L16
	move.w %d1,%d0
	addq.w #1,%d1
.L16:
	move.w %d0,(%a1)+

	move.w (%a0)+,%d0
	and.b %d2,%d0
	jbge .L17
	move.w %d1,%d0
	addq.w #1,%d1
.L17:
	move.w %d0,(%a1)+

	move.w (%a0)+,%d0
	and.b %d2,%d0
	jbge .L18
	move.w %d1,%d0
	addq.w #1,%d1
.L18:
	move.w %d0,(%a1)+

	dbra %d3,.L19

	lea (48,%a1),%a1
	dbra %d4,.L20

	movm.l (%sp)+,#0x3c
	rts
