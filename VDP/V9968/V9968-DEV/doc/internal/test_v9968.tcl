# Run with Panasonic_FS-A1ST_V9968 and the V9968CHECK cartridge inserted.
set throttle off

proc check {condition message} {
	if {![uplevel 1 [list expr $condition]]} {
		error $message
	}
}

proc write_vdp_reg {reg value} {
	debug write ioports 0x99 $value
	debug write ioports 0x99 [expr {0x80 | $reg}]
}

proc test_v9968 {} {
	set screen ""
	for {set i 0} {$i < 960} {incr i} {
		append screen [format %c [debug read VRAM $i]]
	}
	check {[string first "V9968: VDP PRINCIPAL (98H)" $screen] >= 0} \
		"V9968CHECK did not identify the primary VDP"
	check {[debug size {physical VRAM}] == 4194304} "Expected 4 MiB of VRAM"
	check {([debug read {VDP status regs} 1] & 0x3e) == 4} "Expected compatible ID"

	write_vdp_reg 21 0
	check {([debug read {VDP regs} 21] & 1) == 1} "R21 changed while locked"
	write_vdp_reg 20 0x20
	check {[debug read {VDP regs} 20] == 0} "R20 changed while locked"
	debug write ioports 0x9c 0
	write_vdp_reg 21 0
	check {([debug read {VDP status regs} 1] & 0x3e) == 6} "Expected extended ID"
	write_vdp_reg 20 0x20
	check {[debug read {VDP regs} 20] == 0x20} "R20 FIL bit unavailable"
	write_vdp_reg 14 15
	check {[debug read {VDP regs} 14] == 15} "Extended VRAM address bit unavailable"
	foreach {reg bit} {2 0x80 4 0x40 6 0x40 10 0x08 11 0x04} {
		write_vdp_reg $reg $bit
		check {([debug read {VDP regs} $reg] & $bit) != 0} "Table A17 unavailable"
	}
	debug write ioports 0x9c 0x80
	write_vdp_reg 21 1
	check {([debug read {VDP regs} 21] & 1) == 0} "R21 changed after relocking"
	debug write ioports 0x9c 0
	write_vdp_reg 21 1
	foreach {reg bit} {2 0x80 4 0x40 6 0x40 10 0x08 11 0x04} {
		check {([debug read {VDP regs} $reg] & $bit) == 0} "Table A17 not cleared"
		write_vdp_reg $reg $bit
		check {([debug read {VDP regs} $reg] & $bit) == 0} "Table A17 accepted in compatible mode"
	}
	write_vdp_reg 14 15
	check {[debug read {VDP regs} 14] == 7} "Compatible VRAM address mask incorrect"
	write_vdp_reg 21 0
	reset
	write_vdp_reg 21 0
	check {([debug read {VDP regs} 21] & 1) == 1} "Reset did not lock R21"
	check {([debug read {VDP status regs} 1] & 0x3e) == 4} "Reset did not restore compatible ID"
	write_vdp_reg 14 15
	check {[debug read {VDP regs} 14] == 7} "Reset did not restore compatible VRAM mask"
}

after time 6 {
	if {[catch {test_v9968} result]} {
		set f [open /dev/stderr w]
		puts $f "V9968 test failed: $result"
		close $f
		exit 1
	} else {
		set f [open /dev/stderr w]
		puts $f "V9968 test passed"
		close $f
		exit 0
	}
}
