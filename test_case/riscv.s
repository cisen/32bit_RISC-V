.section .text
.globl _start
_start:
	lui		x1,0x74567
	lui		x2,0x29869
	lui		x3,0xf0c51
	lui		x4,0x8944a
	lui		x5,0x71f29
	lui		x6,0x858ba
	lui		x7,0xc41f2
	lui		x8,0x6a9e3
	lui		x9,0x80000
	lui		x10,0x80000
	lui		x11,0x6231b
	lui		x12,0xcde7
	lui		x13,0xe0f76
	lui		x14,0x5f92e
	lui		x15,0xcc233
	lui		x16,0x7c4c9
	lui		x17,0xafb66
	lui		x18,0xb500d
	lui		x19,0xdba31
	lui		x20,0x130a3
	lui		x21,0xc6125
	lui		x22,0xab105
	lui		x23,0x3a858
	lui		x24,0x3845e
	lui		x25,0xdbdab
	lui		x26,0x3d0cd
	lui		x27,0xa769b
	lui		x28,0x32454
	lui		x29,0x6c40e
	lui		x30,0x5f874
	lui		x31,0x0
	addi	x1,x1,0x3c6
	addi	x2,x2,0xfffff873
	addi	x3,x3,0xfffffcff
	addi	x4,x4,0xfffff8ec
	addi	x5,x5,0xfffffccd
	addi	x6,x6,0x7ab
	addi	x7,x7,0xfffffefb
	addi	x8,x8,0x146
	addi	x9,x9,0xffffffff
	addi	x10,x10,0x001
	addi	x11,x11,0xfffff9e8
	addi	x12,x12,0x38d
	addi	x13,x13,0x55a
	addi	x14,x14,0x263
	addi	x15,x15,0x79f
	addi	x16,x16,0x79a
	addi	x17,x17,0xfffffd32
	addi	x18,x18,0x7b7
	addi	x19,x19,0x458
	addi	x20,x20,0xfffff95a
	addi	x21,x21,0xfffff95d
	addi	x22,x22,0x317
	addi	x23,x23,0xfffffae9
	addi	x24,x24,0xfffff8d4
	addi	x25,x25,0xfffffcb2
	addi	x26,x26,0xc6
	addi	x27,x27,0xfffffeb4
	addi	x28,x28,0x611
	addi	x29,x29,0xfffffd82
	addi	x30,x30,0x641
	addi	x31,x31,0xffffffb0
	nop
	nop
	nop
	nop
	nop
	add		x1,x1,x2
	add		x2,x3,x4
	sub		x3,x5,x6
	sub		x4,x7,x8
	addi	x5,x9,0x123
	addi	x6,x10,0xfffffabc
	and		x7,x7,x8
	or		x8,x8,x9
	xor		x9,x11,x12
	sll		x10,x11,x11
	srl		x11,x12,x13
	sra		x12,x13,x14
	slt		x13,x14,x15
	slt		x14,x15,x16
	sltu	x15,x17,x16
	sltu	x16,x16,x17
	andi	x17,x18,0xfffffca3
	ori		x18,x18,0xfffff806
	xori	x19,x19,0x257
	slti	x20,x0,0xfffffc93
	slti	x21,x0,0x7ff
	sltiu	x22,x22,0
	sltiu	x23,x24,0xfffff9d1
	slli	x24,x24,16
	srli	x25,x26,21
	srai	x26,x27,9
	mul		x27,x27,x28
	nop
	nop
	nop
	nop
	nop
	#lui	x28,0x7f400
	ori		x28,x0,0x100
	nop
	nop
	nop
	nop
	nop
	sw		x2,4(x28)			#mem(x28+4)=0x7a09a5eb
	nop
	nop
	nop
	nop
	nop
	sh		x3,6(x28)			#mem(x28+4)=0xe522a5eb
	nop
	nop
	nop
	nop
	nop
	sb		x4,7(x28)			#mem(x28+4)=0xb522a5eb
	nop
	nop
	nop
	nop
	nop
	sw		x12,-4(x28)			#mem(x28-4)=0xfc1eecab
	nop
	nop
	nop
	nop
	nop							#x31=0xffffffb0
	beq		x5,x0,L00
L01:beq		x0,x0,L02			#x31+=3
L03:bne		x0,x0,L04
L05:bne		x5,x0,L06			#x31+=7
L07:blt		x0,x0,L08
L09:blt		x5,x0,L10			#x31+=11
L11:bltu	x5,x0,L12
L13:bltu	x0,x5,L14			#x31+=15
L15:bge		x5,x0,L16
L17:bge		x0,x5,L18			#x31+=19
L19:bgeu	x0,x5,L20
L21:bgeu	x5,x0,L22			#x31+=23
L23:nop
	nop
	nop
	nop
	nop
	nop
	lw		x29,4(x28)			#x29=0xb522a5eb	x30=0x5f874641
	nop
	nop
	nop
	nop
	nop
	add		x30,x30,x29
	nop
	nop
	nop
	nop
	nop
	lh		x29,-2(x28)			#x29=0xfffffc1e
	nop
	nop
	nop
	nop
	nop
	add		x30,x30,x29
	nop
	nop
	nop
	nop
	nop
	lhu		x29,-2(x28)			#x29=0x0000fc1e
	nop
	nop
	nop
	nop
	nop
	add		x30,x30,x29
	nop
	nop
	nop
	nop
	nop
	lb		x29,-1(x28)			#x29=0xfffffffc
	nop
	nop
	nop
	nop
	nop
	add		x30,x30,x29
	nop
	nop
	nop
	nop
	nop
	lbu		x29,-1(x28)			#x29=0x000000fc
	nop
	nop
	nop
	nop
	nop
	add		x30,x30,x29
flag_finish:
	addi	x31,x31,1
	nop
	nop
	nop
	nop
	nop
L00:addi	x31,x31,1
	beq		x0,x0,L01
L02:addi	x31,x31,3
	beq		x0,x0,L03
L04:addi	x31,x31,5
	beq		x0,x0,L05
L06:addi	x31,x31,7
	beq		x0,x0,L07
L08:addi	x31,x31,9
	beq		x0,x0,L09
L10:addi	x31,x31,11
	beq		x0,x0,L11
L12:addi	x31,x31,13
	beq		x0,x0,L13
L14:addi	x31,x31,15
	beq		x0,x0,L15
L16:addi	x31,x31,17
	beq		x0,x0,L17
L18:addi	x31,x31,19
	beq		x0,x0,L19
L20:addi	x31,x31,21
	beq		x0,x0,L21
L22:addi	x31,x31,23
	beq		x0,x0,L23