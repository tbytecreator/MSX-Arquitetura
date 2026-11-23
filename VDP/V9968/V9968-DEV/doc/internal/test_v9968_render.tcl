set throttle off
set frameskip 0
proc out {p v} {debug write ioports $p $v}
proc regwrite {r v} {out 0x99 $v; out 0x99 [expr {0x80 | $r}]}
proc fail {message} {
	set f [open /dev/stderr w]
	puts $f "V9968 render test failed: $message"
	close $f
	exit 1
}
proc pixels {} {
	set path [file join $::env(OPENMSX_HOME) v9968-render-test.png]
	if {[file exists $path]} {error "$path already exists"}
	set status [catch {
		screenshot -raw -size 320 $path
		set f [open "|[list ffmpeg -v error -i $path -f rawvideo -pix_fmt rgb24 -]" r]
		fconfigure $f -translation binary
		set data [read $f]
		close $f
		if {[string length $data] != 320 * 240 * 3} {error "unexpected screenshot size"}
		set result {}
		foreach {x y} {50 50 82 75} {
			set pos [expr {($y * 320 + $x) * 3}]
			binary scan [string range $data $pos [expr {$pos + 2}]] H6 pixel
			lappend result $pixel
		}
	} message]
	file delete -force $path
	if {$status} {error $message}
	return $result
}
after time 6 {
	if {[catch {
		set throttle on
		out 0x9c 0
		regwrite 21 0
		regwrite 0 6
		regwrite 1 0x40
		regwrite 2 0x1f
		regwrite 5 0xec
		regwrite 6 0x0f
		regwrite 8 8
		debug write_block {physical VRAM} 0x40000 [string repeat "\x11" 32768]
		debug write_block {physical VRAM} 0x80000 [string repeat "\x44" 32768]
		foreach {base color} {0xc0000 15 0x100000 2} {
			debug write_block {physical VRAM} [expr {$base + 0x7400}] [string repeat [binary format c $color] 16]
			debug write_block {physical VRAM} [expr {$base + 0x7600}] [binary format c* {50 50 0 0 216}]
			debug write_block {physical VRAM} [expr {$base + 0x7800}] [string repeat "\xff" 8]
		}
		regwrite 29 0x31
	} err]} {fail $err}
	after time 1 {
		if {[catch {set a [pixels]; regwrite 29 0x32} err]} {fail $err}
		after time 1 {
			if {[catch {set b [pixels]; regwrite 29 0x41} err]} {fail $err}
			after time 1 {
				if {[catch {
					set c [pixels]
					lassign $a bg1 sprite1
					lassign $b bg2 sprite2
					lassign $c bg3 sprite3
					if {$bg1 eq $bg2 || $bg1 ne $bg3 ||
					    $sprite1 ne $sprite2 || $sprite1 eq $sprite3 ||
					    $sprite3 eq $bg3} {error "pixels: $a / $b / $c"}
				} err]} {
					fail $err
				} else {
					set f [open /dev/stderr w]
					puts $f "V9968 render bank test passed"
					close $f
					exit 0
				}
			}
		}
	}
}
