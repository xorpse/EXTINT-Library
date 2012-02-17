; --------------------------------
; Function prototypes
; --------------------------------

; Assignment
extrn 'extassign' as extassign:dword ; destination, type, dword_count, dword1, dword2, ...
extrn 'extassign_zero' as extassign_zero:dword ; destination, type
extrn 'extassign_neg_one' as extassign_neg_one:dword ; destination, type

; Simple arithmetic
extrn 'extadd' as extadd:dword ; destination, source, type
extrn 'extsub' as extsub:dword ; destination, source, type
extrn 'extneg' as extneg:dword ; destination, type
extrn 'extinc' as extinc:dword ; destination, type
extrn 'extdec' as extdec:dword ; destination, type

; Complex arithmetic
extrn 'extdiv' as extdiv:dword ; quotient, residue, source, divisor, type
extrn 'extidiv' as extidiv:dword ; quotient, residue, source,divisor, type
extrn 'extmul' as extmul:dword ; destination, source, multiplier, type
extrn 'extimul' as extimul:dword ; destination, source, multiplier, type

; Optimised complex arithmetic
extrn 'extmuls' as extmuls:dword ; destination, source, multiplier, type
extrn 'extimuls' as extimuls:dword ; destination, source, multiplier, type

; Bitwise manipulation - shifts
extrn 'extshl' as extshl:dword ; destination, source, shift, type
extrn 'extshl_single' as extshl_single:dword ; destination, type
extrn 'extshr' as extshr:dword ; destination, source, shift, type
extrn 'extshr_single' as extshr_single:dword ; destination, type

; Bitwise manipulation - rotations
extrn 'extrol' as extrol:dword ; destination, source, rotate, type
extrn 'extror' as extror:dword ; destination, source, rotate, type

; Bitwise manipulation - standard boolean algebra operations (and xor)
extrn 'extand' as extand:dword ; destination, source, type
extrn 'extor' as extor:dword ; destination, source, type
extrn 'extxor' as extxor:dword ; destination, source, type
extrn 'extnot' as extnot:dword ; destination, type

; Binary comparison
extrn 'extcmp' as extcmp:dword ; destination, source, type
extrn 'exticmp' as exticmp:dword ; destination, source, type
