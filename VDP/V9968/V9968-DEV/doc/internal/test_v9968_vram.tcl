set throttle off
after time 6 {
	set marker [debug read memory 0xc000]
	set upper [debug read memory 0xc001]
	set lower [debug read memory 0xc002]
	set f [open /dev/stderr w]
	if {$marker != 0xc7 || $upper != 0xa5 || $lower != 0x5a} {
		puts $f [format "V9968 VRAM test failed: %02x %02x %02x" $marker $upper $lower]
		close $f
		exit 1
	} else {
		puts $f "V9968 VRAM test passed"
		close $f
		exit 0
	}
}
