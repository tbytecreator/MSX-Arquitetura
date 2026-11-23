set throttle off
proc out {p v} {debug write ioports $p $v}
proc regwrite {r v} {out 0x99 $v; out 0x99 [expr {0x80 | $r}]}
after time 6 {
	set path [file join $::env(OPENMSX_HOME) v9968-test-state.oms]
	if {[file exists $path]} {
		set f [open /dev/stderr w]
		puts $f "V9968 state test failed: $path already exists"
		close $f
		exit 1
	}
	set status [catch {
		out 0x9c 0
		regwrite 21 0
		regwrite 28 15
		regwrite 29 0x43
		regwrite 30 0x21
		debug write {physical VRAM} 0x3c0000 0xa5
		out 0x9d 0x42
		out 0x9f 42
		store_machine [machine] $path
		activate_machine [restore_machine $path]
		if {[debug read {physical VRAM} 0x3c0000] != 0xa5} {error "bank data"}
		foreach {r v} {28 15 29 0x43 30 0x21} {
			if {[debug read {VDP regs} $r] != $v} {error "R$r"}
		}
		out 0x9d 0x42
		if {[debug read ioports 0x9f] != 42} {error "Geo3D register"}
		regwrite 21 1
		if {[debug read {VDP regs} 21] != 1} {error "unlock state"}
	} message]
	file delete -force $path
	set f [open /dev/stderr w]
	if {$status} {
		puts $f "V9968 state test failed: $message"
		close $f
		exit 1
	} else {
		puts $f "V9968 state test passed"
		close $f
		exit 0
	}
}
