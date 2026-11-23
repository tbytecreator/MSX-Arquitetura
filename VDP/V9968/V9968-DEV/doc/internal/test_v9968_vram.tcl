set throttle off
after time 6 {
	set marker [debug read memory 0xc000]
	set upper [debug read memory 0xc001]
	set lower [debug read memory 0xc002]
	set banks_ok 1
	for {set i 0} {$i < 16} {incr i} {
		if {[debug read memory [expr {0xc010 + $i}]] != (0xa0 ^ $i)} {
			set banks_ok 0
		}
	}
	set f [open /dev/stderr w]
	if {$marker != 0xc7 || $upper != 0xa5 || $lower != 0x5a || !$banks_ok ||
	    [debug read memory 0xc020] != 0xa0} {
		puts $f [format "V9968 VRAM test failed: %02x %02x %02x" $marker $upper $lower]
		close $f
		exit 1
	} else {
		puts $f "V9968 VRAM test passed"
		close $f
		exit 0
	}
}
