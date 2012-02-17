format elf ; ms coff for windows

include 'macro.inc'
include 'constant.inc'

; Assignment
public _extassign as 'extassign' ; destination, type, dword_count, dword1, dword2, ...
public _extassign_zero as 'extassign_zero' ; destination, type
public _extassign_neg_one as 'extassign_neg_one' ; destination, type

; Simple arithmetic
public _extadd as 'extadd' ; destination, source, type
public _extsub as 'extsub' ; destination, source, type
public _extneg as 'extneg' ; destination, type
public _extinc as 'extinc' ; destination, type
public _extdec as 'extdec' ; destination, type

; Complex arithmetic
public _extdiv as 'extdiv' ; quotient, residue, source, divisor, type
public _extidiv as 'extidiv' ; quotient, residue, source,divisor, type
public _extmul as 'extmul' ; destination, source, multiplier, type
public _extimul as 'extimul' ; destination, source, multiplier, type

; Optimised complex arithmetic
public _extmul_auto_speed as 'extmuls' ; destination, source, multiplier, type
public _extimul_auto_speed as 'extimuls' ; destination, source, multiplier, type

; Bitwise manipulation - shifts
public _extshl as 'extshl' ; destination, source, shift, type
public _extshl_single as 'extshl_single' ; destination, type
public _extshr as 'extshr' ; destination, source, shift, type
public _extshr_single as 'extshr_single' ; destination, type

; Bitwise manipulation - rotations
public _extrol as 'extrol' ; destination, source, rotate, type
public _extror as 'extror' ; destination, source, rotate, type

; Bitwise manipulation - standard boolean algebra operations (and xor)
public _extand as 'extand' ; destination, source, type
public _extor as 'extor' ; destination, source, type
public _extxor as 'extxor' ; destination, source, type
public _extnot as 'extnot' ; destination, type

; Binary comparison
public _extcmp as 'extcmp' ; destination, source, type
public _exticmp as 'exticmp' ; destination, source, type

section '.data' writeable ; data readable writeable for windows
; ******************* below is required *******************
multiplier rd INT_TYPE_MAX_BITS
factor     rd INT_TYPE_MAX_BITS
divisor	   rd INT_TYPE_MAX_BITS
gen_temp   rd INT_TYPE_MAX_BITS
gen_temp2  rd INT_TYPE_MAX_BITS
gen_temp3  rd INT_TYPE_MAX_BITS
gen_temp4  rd INT_TYPE_MAX_BITS

section '.text' executable ; code readable executable for windows
_extassign: ; destination, type, dword_count, ...
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	push esi
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]
	
	mov eax, 0h
	rep stosd
	
	mov ecx, dword [ebp + 010h]
	lea esi, dword [ebp + 014h]
	mov edi, dword [ebp + 08h]
	lea edi, dword [edi + ecx * 4 - 4]
	
.ltop:
	mov eax, dword [esi]
	mov dword [edi], eax
	add esi, 04h
	sub edi, 04h
	loopd .ltop
	
	pop esi
	pop edi
	pop ecx
	
	pop ebp
	ret
	
_extassign_zero:
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]
	mov eax, 0h
	
	rep stosd
	
	pop edi
	pop ecx
	
	pop ebp
	ret
	
_extassign_neg_one:
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]
	mov eax, 0FFFFFFFFh
	
	rep stosd
	
	pop edi
	pop ecx
	
	pop ebp
	ret
	
_extadd: ; balance stack using: add esp, 0Ch
	push ebp
	mov ebp, esp
	
	push edi
	push esi
	push ecx
	
	mov edi, dword [ebp + 08h] ; destination
	mov esi, dword [ebp + 0Ch] ; source
	mov ecx, dword [ebp + 010h] ; type
	
	clc
.ltop:
	mov eax, dword [esi]
	adc eax, dword [edi]
	pushfd
	mov dword [edi], eax
	add esi, 04h
	add edi, 04h
	popfd
	loopd .ltop
	
	; cf is set if there is overflow
	jnc .no_carry
	mov eax, 01h
	jmp .done
.no_carry:	
	mov eax, 0h
	
.done:	
	pop ecx
	pop esi
	pop edi
	
	pop ebp
	ret
	
_extsub:
	push ebp
	mov ebp, esp
	
	push edi
	push esi
	push ecx
	
	mov edi, dword [ebp + 08h] ; destination
	mov esi, dword [ebp + 0Ch] ; source
	mov ecx, dword [ebp + 010h] ; type
	
	clc
.ltop:
	mov eax, dword [edi]
	sbb eax, dword [esi]
	pushfd
	mov dword [edi], eax
	add esi, 04h
	add edi, 04h
	popfd
	loopd .ltop
	
	jnc .no_borrow
	mov eax, 01h
	jmp .done
.no_borrow:
	mov eax, 0h
	
.done:
	pop ecx
	pop esi
	pop edi
	
	pop ebp
	ret

_extneg: ; destination, type
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]
	
.ltop:
	not dword [edi]
	add edi, 04h
	loopd .ltop
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]

.tsc:
	adc dword [edi], 0h
	jnc .done
	add edi, 04h
	loopd .tsc
	
.done:
	pop edi
	pop ecx
	
	pop ebp
	ret

_extinc:
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]
	
.ltop:
	adc dword [edi], 0h
	jnc .done
	add edi, 04h
	loopd .ltop
	
.done:	
	pop edi
	pop ecx
	
	pop ebp
	ret
	
_extdec:
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]
	
.ltop:
	sbb dword [edi], 0h
	jnc .done
	add edi, 04h
	loopd .ltop
	
.done:
	pop edi
	pop ecx
	
	pop ebp
	ret

_extdiv: ; quotient, residue, source, divisor, type
	push ebp
	mov ebp, esp
	sub esp, 04h
	
	push ecx
	push edi
	push esi
	
	label .divisor_shift at ebp - 04h
	
	cld
	; fail silently if we are dividing by 0
	mov eax, 0h
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 014h]
	repe scasd
	cmp ecx, 0h
	je .done ; divide by 0: do nothing
	
	; check for division by 1
	mov edi, dword [ebp + 014h]
	cmp dword [edi], 01h
	jne .no_mul_one
	add edi, 04h
	mov ecx, dword [ebp + 018h]
	dec ecx ; advance from least but one significant dword
	mov eax, 0h
	
	; if ecx = 0 then we are multiplying by 1
	repe scasd
	cmp ecx, 0h
	jne .no_mul_one
	
	; multiplication by 1 hence copy and leave
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 0Ch] ; no residue
	rep stosd
	
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 08h]
	mov esi, dword [ebp + 010h]
	rep movsd
	jmp .done

.no_mul_one:
	mov eax, 0h
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 08h]
	rep stosd ; set quotient to 0
	
	mov ecx, dword [ebp + 018h]
	mov esi, dword [ebp + 010h]
	mov edi, dword [ebp + 0Ch]
	rep movsd ; store starting residue
	
	; get the highest set bit position in the divisor
	invoked _ext_loc_high_bit, dword [ebp + 014h], dword [ebp + 018h]
	add esp, 08h
	mov dword [.divisor_shift], eax

.ltop:
	invoked _extcmp, dword [ebp + 0Ch], dword [ebp + 014h], dword [ebp + 018h]
	add esp, 0Ch
	cmp eax, 0h
	jl .done
	invoked _ext_loc_high_bit, dword [ebp + 0Ch], dword [ebp + 018h]
	add esp, 08h
	sub eax, dword [.divisor_shift]
	push eax
	invoked _extshl, divisor, dword [ebp + 014h], eax, dword [ebp + 018h]
	add esp, 010h
	invoked _extcmp, dword [ebp + 0Ch], divisor, dword [ebp + 018h]
	add esp, 0Ch
	cmp eax, 0h
	jge .sbtr
	pop eax
	dec eax
	push eax
	invoked _extshr_single, divisor, dword [ebp + 018h]
	add esp, 08h
.sbtr:
	pop eax
	invoked _ext_add2expn, dword [ebp + 08h], eax, dword [ebp + 018h]
	add esp, 0Ch	
	invoked _extsub, dword [ebp + 0Ch], divisor, dword [ebp + 018h]
	add esp, 0Ch
	jmp .ltop
	
.done:
	pop esi
	pop edi
	pop ecx

	add esp, 04h
	pop ebp
	ret

_extidiv: ; quotient, residue, source, divisor, type
	push ebp
	mov ebp, esp
	sub esp, 08h
	
	push ecx
	push edi
	push esi
	
	label .divisor_shift at ebp - 04h
	label .sign at ebp - 08h
	
	cld

	; fail silently if we are dividing by 0
	mov eax, 0h
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 014h]
	repe scasd
	cmp ecx, 0h
	je .done ; divide by 0: do nothing
	
	mov ecx, dword [ebp + 018h]
	mov esi, dword [ebp + 010h]
	mov edi, gen_temp3
	rep movsd
	
	mov ecx, dword [ebp + 018h]
	mov esi, dword [ebp + 014h]
	mov edi, gen_temp4
	rep movsd
	
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 010h]
	lea edi, dword [edi + ecx * 4 - 04h]
	mov eax, dword [edi]
	test eax, 080000000h
	je .f_non
	invoked _extneg, dword [ebp + 010h], dword [ebp + 018h]
	add esp, 08h
.f_non:	
	mov edi, dword [ebp + 014h]
	lea edi, dword [edi + ecx * 4 - 04h]
	xor eax, dword [edi]
	mov dword [.sign], eax
	test dword [edi], 080000000h
	je .f2_non
	invoked _extneg, dword [ebp + 014h], dword [ebp + 018h]
	add esp, 08h
.f2_non:
	; check for division by 1
	mov edi, dword [ebp + 014h]
	cmp dword [edi], 01h
	jne .no_mul_one
	add edi, 04h
	mov ecx, dword [ebp + 018h]
	dec ecx ; advance from least but one significant dword
	mov eax, 0h
	
	; if ecx = 0 then we are multiplying by 1
	repe scasd
	cmp ecx, 0h
	jne .no_mul_one
	
	; multiplication by 1 hence copy and leave
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 0Ch] ; no residue
	rep stosd
	
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 08h]
	mov esi, dword [ebp + 010h]
	rep movsd
	jmp .done

.no_mul_one:
	mov eax, 0h
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 08h]
	rep stosd ; set quotient to 0
	
	mov ecx, dword [ebp + 018h]
	mov esi, dword [ebp + 010h]
	mov edi, dword [ebp + 0Ch]
	rep movsd ; store starting residue
	
	; get the highest set bit position in the divisor
	invoked _ext_loc_high_bit, dword [ebp + 014h], dword [ebp + 018h]
	add esp, 08h
	mov dword [.divisor_shift], eax

.ltop:
	invoked _extcmp, dword [ebp + 0Ch], dword [ebp + 014h], dword [ebp + 018h]
	add esp, 0Ch
	cmp eax, 0h
	jl .done
	invoked _ext_loc_high_bit, dword [ebp + 0Ch], dword [ebp + 018h]
	add esp, 08h
	sub eax, dword [.divisor_shift]
	push eax
	invoked _extshl, divisor, dword [ebp + 014h], eax, dword [ebp + 018h]
	add esp, 010h
	invoked _extcmp, dword [ebp + 0Ch], divisor, dword [ebp + 018h]
	add esp, 0Ch
	cmp eax, 0h
	jge .sbtr
	pop eax
	dec eax
	push eax
	invoked _extshr_single, divisor, dword [ebp + 018h]
	add esp, 08h
.sbtr:
	pop eax
	invoked _ext_add2expn, dword [ebp + 08h], eax, dword [ebp + 018h]
	add esp, 0Ch	
	invoked _extsub, dword [ebp + 0Ch], divisor, dword [ebp + 018h]
	add esp, 0Ch
	jmp .ltop
	
.done:
	cld
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 010h]
	mov esi, gen_temp3
	rep movsd
	
	mov ecx, dword [ebp + 018h]
	mov edi, dword [ebp + 014h]
	mov esi, gen_temp4
	rep movsd

	test dword [.sign], 080000000h
	jz .fin
	invoked _extneg, dword [ebp + 08h], dword [ebp + 018h]
	add esp, 08h
.fin:
	pop esi
	pop edi
	pop ecx

	add esp, 08h
	pop ebp
	ret

_extmul: ; desination, source, multiplier, type
	push ebp
	mov ebp, esp
	sub esp, 04h
	
	push ebx
	push ecx
	push edx
	push edi
	push esi
	
	label .count at ebp - 04h
	
	cld
	mov dword [.count], 0h
	
	mov edi, multiplier
	mov esi, dword [ebp + 010h]
	mov ecx, dword [ebp + 014h]
	rep movsd
	
	mov edi, factor
	mov esi, dword [ebp + 0Ch]
	mov ecx, dword [ebp + 014h]
	rep movsd
	
	mov edi, dword [ebp + 08h]
	mov eax, 0h
	mov ecx, dword [ebp + 014h]
	rep stosd
	
	mov edx, multiplier
	mov ecx, dword [ebp + 014h]
	shl ecx, 05h
	
	mov ebx, 01h
.ltop:
	test dword [edx], 01h
	; if true then, shift and add, otherwise shift and continue
	je .prcd
	invoked _extadd, dword [ebp + 08h], factor, dword [ebp + 014h]
	add esp, 0Ch
.prcd:
	invoked _extshl, factor, dword [ebp + 0Ch], ebx, INT_TYPE_MAX_BITS
	add esp, 010h
	inc ebx
	inc dword [.count]
	shr dword [edx], 01h
	cmp dword [.count], 020h ; possibly test for 0 then fix the factor
	jne .advc
	add edx, 04h
	mov dword [.count], 0h
.advc:	
	loopd .ltop
	
	; clean up
	mov eax, 0h
	mov ecx, dword [ebp + 014h]
	mov edi, multiplier
	stosd
	
	mov ecx, dword [ebp + 014h]
	mov edi, factor
	stosd
	
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	
	add esp, 04h
	pop ebp
	ret

_extimul: ; desination, source, multiplier, type
	push ebp
	mov ebp, esp
	sub esp, 08h
	
	push ebx
	push ecx
	push edx
	push edi
	push esi
	
	label .count at ebp - 04h
	label .sign at ebp - 08h
	
	cld
	mov dword [.count], 0h
	
	mov edi, multiplier
	mov esi, dword [ebp + 010h]
	mov ecx, dword [ebp + 014h]
	rep movsd
	
	mov eax, dword [edi - 04h] ; get high dword
	bt eax, 01Fh
	jnc .nxt
	
	invoked _extneg, multiplier, dword [ebp + 014h]
	add esp, 08h

.nxt:	
	mov edi, factor
	mov esi, dword [ebp + 0Ch]
	mov ecx, dword [ebp + 014h]
	rep movsd
	
	xor eax, dword [edi - 04h] ; get overall sign bit
	and eax, 080000000h ; isolate sign bit
	mov dword [.sign], eax
	
	bt dword [edi - 04h], 01Fh
	jnc .nxt1
	
	invoked _extneg, factor, dword [ebp + 014h]
	add esp, 08h
	
.nxt1:	
	mov edi, dword [ebp + 08h]
	mov eax, 0h
	mov ecx, dword [ebp + 014h]
	rep stosd
	
	mov edx, multiplier
	mov ecx, dword [ebp + 014h]
	shl ecx, 05h
	
	mov ebx, 01h
.ltop:
	test dword [edx], 01h
	; if true then, shift and add, otherwise shift and continue
	je .prcd
	invoked _extadd, dword [ebp + 08h], factor, dword [ebp + 014h]
	add esp, 0Ch
.prcd:
	invoked _extshl, factor, dword [ebp + 0Ch], ebx, INT_TYPE_MAX_BITS
	add esp, 010h
	inc ebx
	inc dword [.count]
	shr dword [edx], 01h
	cmp dword [.count], 020h ; possibly test for 0 then fix the factor
	jne .advc
	add edx, 04h
	mov dword [.count], 0h
.advc:	
	loopd .ltop
	
	cmp dword [.sign], 0h
	je .clean
	
	invoked _extneg, dword [ebp + 08h], dword [ebp + 014h]
	add esp, 08h
	
.clean:	
	; clean up
	mov eax, 0h
	mov ecx, dword [ebp + 014h]
	mov edi, multiplier
	rep stosd
	
	mov ecx, dword [ebp + 014h]
	mov edi, factor
	rep stosd
	
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	
	add esp, 08h
	pop ebp
	ret

_extmul_auto_speed:
	push ebp
	mov ebp, esp
	
	push ebx
	push edx
	
	lea ebx, dword [ebp + 0Ch]
	lea edx, dword [ebp + 010h]
	invoked _extcmp, ebx, edx, dword [ebp + 014h]
	add esp, 0Ch
	cmp eax, 0h
	jge .call_mult_ns
	xchg ebx, edx
.call_mult_ns:	
	invoked _extmul, dword [ebp + 08h], ebx, edx, dword [ebp + 014h]
	add esp, 010h
	
	pop edx
	pop ebx
	
	pop ebp
	ret

_extimul_auto_speed:
	push ebp
	mov ebp, esp
	
	push ebx
	push edx
	
	lea ebx, dword [ebp + 0Ch]
	lea edx, dword [ebp + 010h]
	invoked _exticmp, ebx, edx, dword [ebp + 014h]
	add esp, 0Ch
	cmp eax, 0h
	jge .call_mult_ns
	xchg ebx, edx
.call_mult_ns:	
	invoked _extimul, dword [ebp + 08h], ebx, edx, dword [ebp + 014h]
	add esp, 010h
	
	pop edx
	pop ebx
	
	pop ebp
	ret

_extshl: ; (dword) destination, (dword) source, (dword) shift, (dword) type
	push ebp
	mov ebp, esp
	
	push ebx
	push ecx
	push edx
	push edi
	push esi
	
	mov ecx, dword [ebp + 014h]
	shl ecx, 05h ; bits
	cmp ecx, dword [ebp + 010h]
	ja .cont
	
	cld
	mov eax, 0h
	mov ecx, dword [ebp + 014h]
	mov edi, dword [ebp + 08h]
	rep stosd
	jmp .done
	
.cont:
	cld
	mov esi, dword [ebp + 0Ch]
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 014h]
	rep movsd
	cmp dword [ebp + 014h], 0h ; no shift
	je .done
	
	mov edx, 0h
	mov ecx, 020h ; 32 ; get remainder
	mov eax, dword [ebp + 010h]
	div ecx
	
	;edx = final shift
	;eax = full dword moves
	mov ecx, dword [ebp + 014h]
	sub ecx, eax
	
	mov edi, dword [ebp + 08h]
	mov esi, dword [ebp + 0Ch]
	lea edi, dword [edi + eax * 4]
	rep movsd
	
	mov edi, dword [ebp + 08h]
	mov ecx, eax
	mov eax, 0h
	rep stosd ; filled with zeros
	
	; edx = final shifts..
	mov cl, dl
	mov edi, dword [ebp + 08h]
	mov ebx, dword [ebp + 014h]
	dec ebx
	lea edi, dword [edi + ebx * 4]
	mov esi, edi
	sub esi, 04h
	
.ltop:
	mov eax, dword [esi]
	shld dword [edi], eax, cl
	sub esi, 04h
	sub edi, 04h
	cmp edi, dword [ebp + 08h]
	jne .ltop
	
	shl dword [edi], cl
	
.done:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	
	pop ebp
	ret

_extshl_single:
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	push esi
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]
	
	lea edi, dword [edi + ecx * 4 - 04h]
	lea esi, dword [edi - 04h]
	
.ltop:
	mov eax, dword [esi]
	shld dword [edi], eax, 01h
	sub edi, 04h
	sub esi, 04h
	cmp edi, dword [ebp + 08h]
	jne .ltop
	
	shl dword [edi], 01h
	
	pop esi
	pop edi
	pop ecx
	
	pop ebp
	ret
	
_extshr: ; destination, source, shift, type !!!! DESTROYS SOURCE !!!! (test inputs: 0000FFFF FFFFFFFF shifted right by 16
	push ebp
	mov ebp, esp
	
	push ebx
	push ecx
	push edx
	push edi
	push esi
	
	mov ecx, dword [ebp + 014h]
	shl ecx, 05h ; bits = dwords * 32
	cmp ecx, dword [ebp + 010h] ; if greater then = 0
	ja .cont
	
	cld
	mov eax, 0h
	mov ecx, dword [ebp + 014h]
	mov edi, dword [ebp + 08h]
	rep stosd
	jmp .done
	
.cont:
	cld
	mov esi, dword [ebp + 0Ch]
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 014h]
	rep movsd
	cmp dword [ebp + 014h], 0h ; no shift = done
	je .done
	
	mov edx, 0h
	mov eax, dword [ebp + 010h]
	mov ecx, 020h ; divide by 32 to get amount of dwords to move
	div ecx
	
	; edx = final shift, eax = dword moves
	mov ecx, dword [ebp + 014h]
	sub ecx, eax
	
	std
	mov ebx, dword [ebp + 014h]
	dec ebx
	mov esi, dword [ebp + 0Ch]
	lea esi, dword [edi + ebx * 4]
	
	mov edi, dword [ebp + 08h]
	lea edi, dword [edi + ecx * 4 - 4]
	rep movsd
	
	mov edi, dword [ebp + 08h]
	lea edi, dword [edi + ebx * 4] ; fill with 0s
	mov ecx, eax
	mov eax, 0h
	rep stosd
	
	; dl = final right shift
	mov cl, dl
	mov edi, dword [ebp + 08h]
	mov esi, edi
	add esi, 04h
	
	mov eax, dword [ebp + 08h]
	lea ebx, dword [eax + ebx * 4]
		
.ltop:
	mov eax, dword [esi]
	shrd dword [edi], eax, cl
	add esi, 04h
	add edi, 04h
	cmp edi, ebx
	jne .ltop
	
	shr dword [edi], cl
		
.done:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	
	pop ebp
	ret

_extshr_single:
	push ebp
	mov ebp, esp
	
	push ebx
	push ecx
	push edi
	push esi
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]
	
	mov esi, edi
	add esi, 04h
	lea ebx, dword [edi + ecx * 4 - 04h]
	
.ltop:
	mov eax, dword [esi]
	shrd dword [edi], eax, 01h
	add edi, 04h
	add esi, 04h
	cmp edi, ebx
	jne .ltop
	
	shr dword [edi], 01h
	
	pop esi
	pop edi
	pop ecx
	pop ebx
	
	pop ebp
	ret

_extrol: ; destination, source, rotation, type
	push ebp
	mov ebp, esp
	sub esp, 04h
	
	push ecx
	push edx
	push edi
	push esi
	
	label .shifts at ebp - 04h
	
	; reduce rotation to set of values described by type..
	mov edx, 0h
	mov eax, dword [ebp + 010h]
	mov ecx, dword [ebp + 014h]
	shl ecx, 05h ; amount of bits
	div ecx ; edx contains rotation value within the range of values in type
		
	; store the shift for later.. if a shift needs to occur
	cmp edx, 0h ; ..no rotation needed
	jne .cont
	
	; make plain copy into destination
	cld
	mov edi, dword [ebp + 08h]
	mov esi, dword [ebp + 0Ch]
	mov ecx, dword [ebp + 014h]
	rep movsd
	
	; done now..
	jmp .done
	
.cont:
	mov eax, edx
	mov edx, 0h
	mov ecx, 020h
	div ecx
	
	mov ecx, dword [ebp + 014h]
	sub ecx, eax ; moves to make
	
	cld
	mov edi, dword [ebp + 08h]
	mov esi, dword [ebp + 0Ch]
	lea edi, dword [edi + eax * 4]
	rep movsd
	
	mov ecx, eax
	mov edi, dword [ebp + 08h]
	rep movsd
	
	; edx is equal to the final amount of shifts
	; go to msdw and extract bits
	mov ecx, dword [ebp + 014h]
	mov edi, dword [ebp + 08h]
	lea edi, dword [edi + ecx * 4 - 4]
	mov dword [.shifts], 0h
	mov eax, dword [edi]
	mov cl, dl
	shld dword [.shifts], eax, cl
	
	mov esi, edi
	sub esi, 04h
	
.ltop:
	mov eax, dword [esi]
	shld dword [edi], eax, cl
	sub edi, 04h
	sub esi, 04h
	cmp edi, dword [ebp + 08h]
	jne .ltop
	
	shl dword [edi], cl
	mov eax, dword [.shifts]
	or dword [edi], eax
	
.done:
	pop esi
	pop edi
	pop edx
	pop ecx

	add esp, 04h

	pop ebp
	ret
	
_extror: ; destination, source, rotate, type
	push ebp
	mov ebp, esp
	sub esp, 04h
	
	push ecx
	push edx
	push edi
	push esi
	
	label .shifts at ebp - 04h
	
	; reduce rotation to maximum range
	mov eax, dword [ebp + 010h]
	mov ecx, dword [ebp + 014h]
	shl ecx, 05h
	mov edx, 0h
	div ecx
	
	cmp edx, 0h
	jne .cont ; nothing to be done - make a direct copy
	
	cld
	mov edi, dword [ebp + 08h]
	mov esi, dword [ebp + 0Ch]
	mov ecx, dword [ebp + 014h]
	rep movsd
	jmp .done
	
.cont:	
	; following edx / 020h, quotient = amount of dword moves
	mov eax, edx
	mov edx, 0h
	mov ecx, 020h
	div ecx
	
	mov ecx, dword [ebp + 014h]
	mov esi, dword [ebp + 0Ch]
	lea esi, dword [esi + ecx * 4 - 4] ; last 
	mov edi, dword [ebp + 08h]
	sub ecx, eax
	lea edi, dword [edi + ecx * 4 - 4]
	
	std
	rep movsd
	
	mov ecx, dword [ebp + 014h]
	sub ecx, eax
	mov edi, dword [ebp + 08h]
	lea edi, dword [edi + ecx * 4]
	mov ecx, eax
	rep movsd
	
	; edx contains ..the final shifts :)
	; at the lsdw need to shift out
	mov eax, dword [ebp + 08h]
	mov eax, dword [eax]
	mov cl, dl
	mov dword [.shifts], 0h
	shrd dword [.shifts], eax, cl
	
	mov ecx, dword [ebp + 014h]
	mov edi, dword [ebp + 08h]
	lea edi, dword [edi + ecx * 4 - 4]
	mov esi, edi
	sub esi, 04h
	mov ecx, edx
	
.ltop:
	mov eax, dword [esi]
	shrd dword [edi], eax, cl
	sub edi, 04h
	sub esi, 04h
	cmp edi, dword [ebp + 08h]
	jne .ltop
	
	shr dword [edi], cl
	mov edx, dword [ebp + 014h]
	lea edi, dword [edi + edx * 4 - 4]
	mov eax, dword [.shifts]
	or dword [edi], eax
	
.done:
	pop esi
	pop edi
	pop edx
	pop ecx
	
	add esp, 04h
	pop ebp
	ret

_extand: ; destination, source, type
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	push esi
	
	mov edi, dword [ebp + 08h]
	mov esi, dword [ebp + 0Ch]
	mov ecx, dword [ebp + 010h]
	
.ltop:
	mov eax, dword [esi]
	and dword [edi], eax
	add edi, 04h
	add esi, 04h
	loopd .ltop
	
	pop esi
	pop edi
	pop ecx
	
	pop ebp
	ret
	
_extor: ; destination, source, type
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	push esi
	
	mov edi, dword [ebp + 08h]
	mov esi, dword [ebp + 0Ch]
	mov ecx, dword [ebp + 010h]
	
.ltop:
	mov eax, dword [esi]
	or dword [edi], eax
	add edi, 04h
	add esi, 04h
	loopd .ltop
	
	pop esi
	pop edi
	pop ecx
	
	pop ebp
	ret
	
_extxor: ; destination, source, type
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	push esi
	
	mov edi, dword [ebp + 08h]
	mov esi, dword [ebp + 0Ch]
	mov ecx, dword [ebp + 010h]
	
.ltop:
	mov eax, dword [esi]
	xor dword [edi], eax
	add edi, 04h
	add esi, 04h
	loopd .ltop
	
	pop esi
	pop edi
	pop ecx
	
	pop ebp
	ret
	
_extnot: ; destination, type
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]
	
.ltop:
	not dword [edi]
	add edi, 04h
	loopd .ltop
	
	pop edi
	pop ecx
	
	pop ebp
	ret
	
_extcmp:
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	push esi
	
	std
	mov edi, dword [ebp + 0Ch]
	mov esi, dword [ebp + 08h]
	mov ecx, dword [ebp + 010h]
	
	lea edi, dword [edi + ecx * 4 - 4]
	lea esi, dword [esi + ecx * 4 - 4]
	
	repe cmpsd
	pushfd
	
	jne .aorb
	mov eax, 0h ; 
	jmp .done

.aorb:
	jb .less
	mov eax, 01h
	jmp .done
	
.less:
	mov eax, 0FFFFFFFFh ; -1
	
.done:
	popfd
	
	pop esi
	pop edi
	pop ecx
		
	pop ebp
	ret
	
_exticmp:
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	push esi
	
	std
	mov edi, dword [ebp + 0Ch]
	mov esi, dword [ebp + 08h]
	mov ecx, dword [ebp + 010h]
	
	lea edi, dword [edi + ecx * 4 - 4]
	lea esi, dword [esi + ecx * 4 - 4]
	
	repe cmpsd
	pushfd
	
	jne .aorb
	mov eax, 0h ; 
	jmp .done

.aorb:
	jl .less
	mov eax, 01h
	jmp .done
	
.less:
	mov eax, 0FFFFFFFFh ; -1
	
.done:
	popfd
	
	pop esi
	pop edi
	pop ecx
		
	pop ebp
	ret

_ext_add2expn: ; dest, bits (n), type
	push ebp
	mov ebp, esp
	
	push eax
	push ecx
	push edi
	
	cld
	mov eax, 0h
	mov edi, gen_temp
	mov ecx, dword [ebp + 010h]
	dec ecx
	mov dword [edi], 01h
	add edi, 04h
	rep stosd
	
	invoked _extshl, gen_temp2, gen_temp, dword [ebp + 0Ch], dword [ebp + 010h]
	add esp, 010h
	
	invoked _extadd, dword [ebp + 08h], gen_temp2, dword [ebp + 010h]
	add esp, 0Ch
	
	pop edi
	pop ecx
	pop eax
	
	pop ebp
	ret

_ext_loc_high_bit:
	push ebp
	mov ebp, esp
	
	push ecx
	push edi
	push esi
	
	mov edi, dword [ebp + 08h]
	mov ecx, dword [ebp + 0Ch]
	lea edi, dword [edi + ecx * 4 - 04h]
	mov ebx, 0h
	
.ltop:
	cmp dword [edi], 0h
	je .reloop
	
	; find bits
	mov eax, dword [edi]
.ftop:	
	test eax, 080000000h
	je .no_set; not set
	jmp .done
.no_set:	
	inc ebx
	shl eax, 01h
	jmp .ftop ; will always finish
	
.reloop:
	add ebx, 020h
	sub edi, 04h
	cmp edi, dword [ebp + 08h]
	jge .ltop

.done:
	shl ecx, 05h
	dec ecx ; max position = bits - 1
	xchg ecx, ebx
	sub ebx, ecx
	mov eax, ebx
	
	pop esi
	pop edi
	pop ecx
	
	pop ebp
	ret
