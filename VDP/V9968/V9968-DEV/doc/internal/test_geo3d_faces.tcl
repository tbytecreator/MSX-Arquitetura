set throttle off
proc out {p v} {debug write ioports $p $v}
proc regwrite {r v} {out 0x99 $v; out 0x99 [expr {0x80 | $r}]}
proc geo_bytes {idx bytes} {
	out 0x9d $idx
	foreach byte $bytes {out 0x9f $byte}
}
proc geo_words {idx words} {
	out 0x9d $idx
	foreach word $words {
		out 0x9f [expr {$word & 255}]
		out 0x9f [expr {($word >> 8) & 255}]
	}
}
proc fail {message} {
	set f [open /dev/stderr w]
	puts $f "Geo3D face test failed: $message"
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
		geo_words 0 {16384 0 0 0 16384 0 0 0 16384 0 0 256 256 128 106 16 256 212}
		geo_bytes 0x42 {4}
		geo_bytes 0x40 {0}
		geo_words 0x50 {-28 6 0 -24 6 0 -24 2 0 -28 2 0}
		geo_bytes 0x58 {0 1}
		geo_bytes 0x52 {0 1 2 3 0 0 0 0 0 0 5}
	} err]} {fail $err}
	after time 0.1 {
		set path [file join $::env(OPENMSX_HOME) geo3d-face-state.oms]
		if {[file exists $path]} {fail "$path already exists"}
		set status [catch {
			geo_bytes 0x48 {3}
			if {![expr {[debug read ioports 0x9d] & 1}]} {error "face did not start"}
			store_machine [machine] $path
			activate_machine [restore_machine $path]
		} err]
		file delete -force $path
		if {$status} {fail $err}
		after time 0.2 {
			if {[catch {
				if {[debug read ioports 0x9d] & 1} {error "filled face still running"}
				if {[debug read {physical VRAM} [expr {0x80000 + 12850}]] != 0x55} {
					error "filled face pixel"
				}
				debug write {physical VRAM} [expr {0x40000 + 65536}] 0x77
				geo_bytes 0x58 {0}
				geo_bytes 0x52 {0 1 2 3 0 0 0 0 0 0 128}
				geo_bytes 0x65 {0}
				geo_bytes 0x53 {0 0 0 0 0 0 0 0}
				geo_bytes 0x48 {7}
			} err]} {fail $err}
			after time 0.2 {
				if {[catch {
					if {[debug read ioports 0x9d] & 1} {error "textured face still running"}
					if {[debug read {physical VRAM} [expr {0x80000 + 12850}]] != 0x77} {
						error "textured face pixel"
					}
				} err]} {
					fail $err
				} else {
					set f [open /dev/stderr w]
					puts $f "Geo3D face test passed"
					close $f
					exit 0
				}
			}
		}
	}
}
