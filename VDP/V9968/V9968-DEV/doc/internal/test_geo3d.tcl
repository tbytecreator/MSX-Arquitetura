set throttle off
proc out {p v} {debug write ioports $p $v}
proc regwrite {r v} {out 0x99 $v; out 0x99 [expr {0x80 | $r}]}
proc geo_read {i} {out 0x9d $i; return [debug read ioports 0x9f]}
proc geo_words {idx words} {
	out 0x9d $idx
	foreach w $words {
		out 0x9f [expr {$w & 255}]
		out 0x9f [expr {($w >> 8) & 255}]
	}
}
proc fail {message} {
	set f [open /dev/stderr w]
	puts $f "Geo3D test failed: $message"
	close $f
	exit 1
}
after time 6 {
	if {[catch {
		if {[geo_read 0x49] != 0x20} {error "version ID"}
		if {[geo_read 0x6f] != 0xa0} {error "RAM capacity"}
		out 0x9c 0
		regwrite 21 0
		regwrite 0 6
		regwrite 1 0x40
		regwrite 8 8
		geo_words 0 {16384 0 0 0 16384 0 0 0 16384 0 0 256 256 128 106 16 256 212}
		geo_words 0x24 {-50 -30 0}
		if {[geo_read 0x30] != 78 || [geo_read 0x32] != 136 ||
		    [geo_read 0x34] != 0 || [geo_read 0x35] != 1} {
			error "immediate projection"
		}
		out 0x9d 0x42
		foreach v {2 1 15} {out 0x9f $v}
		out 0x9d 0x40; out 0x9f 0; out 0x9f 0
		geo_words 0x50 {-50 -30 0 60 40 0}
		out 0x9d 0x51; out 0x9f 0; out 0x9f 1
	} err]} {fail $err}
	after time 0.1 {
		out 0x9d 0x48
		out 0x9f 1
		after time 0.2 {
			if {[catch {
				if {[debug read ioports 0x9d] & 1} {error "RUN did not finish"}
				if {[geo_read 0x4c] != 1} {error "edge count"}
				set actual {}
				foreach n {36 37 38 39 40 41 42 43 44 45} {
					lappend actual [debug read {VDP regs} $n]
				}
				if {$actual ne {78 0 66 0 110 0 70 0 15 8}} {
					error "LINE registers: $actual"
				}
			} err]} {
				fail $err
			} else {
				set f [open /dev/stderr w]
				puts $f "Geo3D test passed"
				close $f
				exit 0
			}
		}
	}
}
