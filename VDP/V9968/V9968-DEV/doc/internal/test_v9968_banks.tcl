set throttle off
proc out {p v} {debug write ioports $p $v}
proc regwrite {r v} {out 0x99 $v; out 0x99 [expr {0x80 | $r}]}
proc fail {message} {
	set f [open /dev/stderr w]
	puts $f "Bank test failed: $message"
	close $f
	exit 1
}

after time 6 {
	if {[catch {
		out 0x9c 0
		regwrite 21 0
		regwrite 0 6
		regwrite 1 0x40
		regwrite 8 8
		regwrite 30 0x21
		debug write {physical VRAM} 0x40000 0xa5
		debug write {physical VRAM} 0x80000 0x12
		debug write {physical VRAM} 0 0x34
	} err]} {fail $err}
	after time 0.1 {
		if {[catch {
			foreach {r v} {32 0 33 0 34 0 35 0 36 0 37 0 38 0 39 0 40 2 41 0 42 1 43 0 44 0 45 0 46 0xd0} {
				regwrite $r $v
			}
		} err]} {fail $err}
		after time 0.1 {
			if {[catch {
				if {[debug read {physical VRAM} 0x80000] != 0xa5} {error "HMMM destination bank"}
				if {[debug read {physical VRAM} 0] != 0x34} {error "HMMM modified bank zero"}
				if {[debug read {physical VRAM} 0x40000] != 0xa5} {error "HMMM modified source"}
				regwrite 29 0xf1
				regwrite 28 15
				regwrite 21 1
				foreach r {28 29 30} {
					if {[debug read {VDP regs} $r] != 0} {error "R$r not cleared in compatible mode"}
				}
			} err]} {
				fail $err
			} else {
				set f [open /dev/stderr w]
				puts $f "V9968 command bank test passed"
				close $f
				exit 0
			}
		}
	}
}
