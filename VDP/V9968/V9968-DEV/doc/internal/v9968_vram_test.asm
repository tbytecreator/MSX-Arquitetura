; Cartridge test: access distinct locations at 00000h and 20000h.
	org 04000h
	db "AB"
	dw start
	ds 12, 0

start:
	di
	xor a
	out (09ch),a
	ld b,21
	call write_reg
	ld a,8
	ld b,8
	call write_reg

	ld a,8
	ld b,14
	call write_reg
	call set_write_address
	ld a,0a5h
	out (098h),a
	call delay

	xor a
	ld b,14
	call write_reg
	call set_write_address
	ld a,05ah
	out (098h),a
	call delay

	ld a,8
	ld b,14
	call write_reg
	call set_read_address
	in a,(098h)
	ld (0c001h),a
	call delay

	xor a
	ld b,14
	call write_reg
	call set_read_address
	in a,(098h)
	ld (0c002h),a

	ld d,0
write_banks:
	ld a,d
	ld b,28
	call write_reg
	call set_write_address
	ld a,d
	xor 0a0h
	out (098h),a
	call delay
	inc d
	ld a,d
	cp 16
	jr nz,write_banks

	ld d,0
	ld hl,0c010h
read_banks:
	ld a,d
	ld b,28
	call write_reg
	call set_read_address
	in a,(098h)
	ld (hl),a
	inc hl
	call delay
	inc d
	ld a,d
	cp 16
	jr nz,read_banks

	xor a
	ld b,28
	call write_reg
	call set_read_address
	ld a,1
	ld b,28
	call write_reg
	in a,(098h)
	ld (0c020h),a

	ld a,0c7h
	ld (0c000h),a
	halt
	jr $

write_reg:
	out (099h),a
	ld a,b
	or 080h
	out (099h),a
	ret

set_write_address:
	xor a
	out (099h),a
	ld a,040h
	out (099h),a
	ret

set_read_address:
	xor a
	out (099h),a
	out (099h),a
	call delay
	ret

delay:
	nop
	nop
	nop
	nop
	ret

	ds 08000h-$,0
