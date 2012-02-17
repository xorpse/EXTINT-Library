; indirect call
macro invoke proc, [args] {
	reverse
		push args
	common
		call [proc]
}

; direct call
macro invoked proc, [args] {
	reverse
		push args
	common
		call proc
}
