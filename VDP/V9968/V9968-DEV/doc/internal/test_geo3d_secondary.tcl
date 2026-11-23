set throttle off
after time 3 {
	set status [catch {
		debug write ioports 0x8d 0x49
		if {[debug read ioports 0x8f] != 0x20} {error "Geo3D version ID"}
	} message]
	set f [open /dev/stderr w]
	if {$status} {
		puts $f "Secondary Geo3D test failed: $message"
		close $f
		exit 1
	} else {
		puts $f "Secondary Geo3D test passed"
		close $f
		exit 0
	}
}
