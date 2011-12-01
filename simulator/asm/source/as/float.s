.init_heap_size	672
FLOAT_ZERO:		! 0.0
	.long 0x0
FLOAT_ONE:		! 1.0
	.long 0x3f800000
FLOAT_MONE:		! -1.0
	.long 0xbf800000
FLOAT_MAGICI:	! 8388608
	.long 0x800000
FLOAT_MAGICF:	! 8388608.0
	.long 0x4b000000
FLOAT_MAGICFHX:	! 1258291200
	.long 0x4b000000
l.1810:	! 48.300300
	.long	0x42413381
l.1808:	! 4.500000
	.long	0x40900000
l.1806:	! 3.000000
	.long	0x40400000
l.1804:	! 5.000000
	.long	0x40a00000
l.1802:	! 9.000000
	.long	0x41100000
l.1800:	! 7.000000
	.long	0x40e00000
l.1798:	! 1.000000
	.long	0x3f800000
l.1795:	! 1.570796
	.long	0x3fc90fda
l.1793:	! 12.300000
	.long	0x4144ccc4
l.1791:	! 1.570796
	.long	0x3fc90fda
l.1789:	! 0.500000
	.long	0x3f000000
l.1787:	! 6.283185
	.long	0x40c90fda
l.1785:	! 2.000000
	.long	0x40000000
l.1783:	! 3.141593
	.long	0x40490fda
l.1778:	! 0.000000
	.long	0x0
	jmp	min_caml_start

!#####################################################################
!
! 		↓　ここから lib_asm.s
!
!#####################################################################

! * create_array
min_caml_create_array:
	slli %g3, %g3, 2
	add %g5, %g3, %g2
	mov %g3, %g2
CREATE_ARRAY_LOOP:
	jlt %g5, %g2, CREATE_ARRAY_END
	jeq %g5, %g2, CREATE_ARRAY_END
	st %g4, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_ARRAY_LOOP
CREATE_ARRAY_END:
	return

! * create_float_array
min_caml_create_float_array:
	slli %g3, %g3, 2
	add %g4, %g3, %g2
	mov %g3, %g2
CREATE_FLOAT_ARRAY_LOOP:
	jlt %g4, %g2, CREATE_FLOAT_ARRAY_END
	jeq %g4, %g2, CREATE_ARRAY_END
	fst %f0, %g2, 0
	addi %g2, %g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return
	
! * floor		%f0 + MAGICF - MAGICF
min_caml_floor:
	fmov %f1, %f0
	! %f4 = 0.0
	setL %g3, FLOAT_ZERO
	fld %f4, %g3, 0
	fjlt %f4, %f0, FLOOR_POSITIVE	! if (%f4 <= %f0) goto FLOOR_PISITIVE
	fjeq %f4, %f0, FLOOR_POSITIVE
FLOOR_NEGATIVE:
	fneg %f0, %f0
	setL %g3, FLOAT_MAGICF
	! %f2 = FLOAT_MAGICF
	fld %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_NEGATIVE_MAIN
	fjeq %f0, %f2, FLOOR_NEGATIVE_MAIN
	fneg %f0, %f0
	return
FLOOR_NEGATIVE_MAIN:
	fadd %f0, %f0, %f2
	fsub %f0, %f0, %f2
	fneg %f1, %f1
	fjlt %f1, %f0, FLOOR_RET2
	fjeq %f1, %f0, FLOOR_RET2
	fadd %f0, %f0, %f2
	! %f3 = 1.0
	setL %g3, FLOAT_ONE
	fld %f3, %g3, 0
	fadd %f0, %f0, %f3
	fsub %f0, %f0, %f2
	fneg %f0, %f0
	return
FLOOR_POSITIVE:
	setL %g3, FLOAT_MAGICF
	fld %f2, %g3, 0
	fjlt %f0, %f2, FLOOR_POSITIVE_MAIN
	fjeq %f0, %f2, FLOOR_POSITIVE_MAIN
	return
FLOOR_POSITIVE_MAIN:
	fmov %f1, %f0
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g4, %g1, 0
	fsub %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g4, %g1, 0
	fjlt %f0, %f1, FLOOR_RET
	fjeq %f0, %f1, FLOOR_RET
	setL %g3, FLOAT_ONE
	fld %f3, %g3, 0
	fsub %f0, %f0, %f3
FLOOR_RET:
	return
FLOOR_RET2:
	fneg %f0, %f0
	return
	
min_caml_ceil:
	fneg %f0, %f0
	call min_caml_floor
	fneg %f0, %f0
	return

! * float_of_int
min_caml_float_of_int:
	jlt %g0, %g3, ITOF_MAIN		! if (%g0 <= %g3) goto ITOF_MAIN
	jeq %g0, %g3, ITOF_MAIN
	sub %g3, %g0, %g3
	call ITOF_MAIN
	fneg %f0, %f0
	return
ITOF_MAIN:

	! %f1 <= FLOAT_MAGICF
	! %g4 <= FLOAT_MAGICFHX
	! %g5 <= FLOAT_MAGICI

	setL %g5, FLOAT_MAGICF
	fld %f1, %g5, 0
	setL %g5, FLOAT_MAGICFHX
	ld %g4, %g5, 0
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	jlt %g5, %g3, ITOF_BIG
	jeq %g5, %g3, ITOF_BIG
	add %g3, %g3, %g4
	st %g3, %g1, 0
	fld %f0, %g1, 0
	fsub %f0, %f0, %f1
	return
ITOF_BIG:
	setL %g4, FLOAT_ZERO
	fld %f2, %g4, 0
ITOF_LOOP:
	sub %g3, %g3, %g5
	fadd %f2, %f2, %f1
	jlt %g5, %g3, ITOF_LOOP
	jeq %g5, %g3, ITOF_LOOP
	add %g3, %g3, %g4
	st %g3, %g1, 0
	fld %f0, %g1, 0
	fsub %f0, %f0, %f1
	fadd %f0, %f0, %f2
	return

! * int_of_float
min_caml_int_of_float:
	! %f1 <= 0.0
	setL %g3, FLOAT_ZERO
	fld %f1, %g3, 0
	fjlt %f1, %f0, FTOI_MAIN			! if (0.0 <= %f0) goto FTOI_MAIN
	fjeq %f1, %f0, FTOI_MAIN
	fneg %f0, %f0
	call FTOI_MAIN
	sub %g3, %g0, %g3
	return
FTOI_MAIN:
	call min_caml_floor
	! %f2 <= FLOAT_MAGICF
	! %g4 <= FLOAT_MAGICFHX
	setL %g4, FLOAT_MAGICF
	fld %f2, %g4, 0
	setL %g4, FLOAT_MAGICFHX
	ld %g4, %g4, 0
	fjlt %f2, %f0, FTOI_BIG		! if (MAGICF <= %f0) goto FTOI_BIG
	fjeq %f2, %f0, FTOI_BIG
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g3, %g1, 0
	sub %g3, %g3, %g4
	return
FTOI_BIG:
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	mov %g3, %g0
FTOI_LOOP:
	fsub %f0, %f0, %f2
	add %g3, %g3, %g5
	fjlt %f2, %f0, FTOI_LOOP
	fjeq %f2, %f0, FTOI_LOOP
	fadd %f0, %f0, %f2
	fst %f0, %g1, 0
	ld %g5, %g1, 0
	sub %g5, %g5, %g4
	add %g3, %g5, %g3
	return
	
! * truncate
min_caml_truncate:
	jmp min_caml_int_of_float


!#####################################################################
!
! 		↑　ここまで lib_asm.s
!
!#####################################################################
sin_sub.318:
	fld	%f1, %g27, -8
	fjlt	%f1, %f0, fjge_else.2098
	fmov	%f2, %f16
	fjlt	%f0, %f2, fjge_else.2099
	return
fjge_else.2099:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2100
	fjlt	%f0, %f2, fjge_else.2101
	return
fjge_else.2101:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2102
	fjlt	%f0, %f2, fjge_else.2103
	return
fjge_else.2103:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2104
	fjlt	%f0, %f2, fjge_else.2105
	return
fjge_else.2105:
	fadd	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2104:
	fsub	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2102:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2106
	fjlt	%f0, %f2, fjge_else.2107
	return
fjge_else.2107:
	fadd	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2106:
	fsub	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2100:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2108
	fjlt	%f0, %f2, fjge_else.2109
	return
fjge_else.2109:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2110
	fjlt	%f0, %f2, fjge_else.2111
	return
fjge_else.2111:
	fadd	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2110:
	fsub	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2108:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2112
	fjlt	%f0, %f2, fjge_else.2113
	return
fjge_else.2113:
	fadd	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2112:
	fsub	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2098:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2114
	fmov	%f2, %f16
	fjlt	%f0, %f2, fjge_else.2115
	return
fjge_else.2115:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2116
	fjlt	%f0, %f2, fjge_else.2117
	return
fjge_else.2117:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2118
	fjlt	%f0, %f2, fjge_else.2119
	return
fjge_else.2119:
	fadd	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2118:
	fsub	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2116:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2120
	fjlt	%f0, %f2, fjge_else.2121
	return
fjge_else.2121:
	fadd	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2120:
	fsub	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2114:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2122
	fmov	%f2, %f16
	fjlt	%f0, %f2, fjge_else.2123
	return
fjge_else.2123:
	fadd	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2124
	fjlt	%f0, %f2, fjge_else.2125
	return
fjge_else.2125:
	fadd	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2124:
	fsub	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2122:
	fsub	%f0, %f0, %f1
	fjlt	%f1, %f0, fjge_else.2126
	fmov	%f2, %f16
	fjlt	%f0, %f2, fjge_else.2127
	return
fjge_else.2127:
	fadd	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
fjge_else.2126:
	fsub	%f0, %f0, %f1
	ld	%g26, %g27, 0
	b	%g26
div_binary_search.344:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.2128
	mov	%g3, %g5
	return
jle_else.2128:
	jlt	%g8, %g3, jle_else.2129
	jne	%g8, %g3, jeq_else.2130
	mov	%g3, %g7
	return
jeq_else.2130:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.2131
	mov	%g3, %g5
	return
jle_else.2131:
	jlt	%g8, %g3, jle_else.2132
	jne	%g8, %g3, jeq_else.2133
	mov	%g3, %g6
	return
jeq_else.2133:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.2134
	mov	%g3, %g5
	return
jle_else.2134:
	jlt	%g8, %g3, jle_else.2135
	jne	%g8, %g3, jeq_else.2136
	mov	%g3, %g7
	return
jeq_else.2136:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.2137
	mov	%g3, %g5
	return
jle_else.2137:
	jlt	%g8, %g3, jle_else.2138
	jne	%g8, %g3, jeq_else.2139
	mov	%g3, %g6
	return
jeq_else.2139:
	jmp	div_binary_search.344
jle_else.2138:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.344
jle_else.2135:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.2140
	mov	%g3, %g7
	return
jle_else.2140:
	jlt	%g8, %g3, jle_else.2141
	jne	%g8, %g3, jeq_else.2142
	mov	%g3, %g5
	return
jeq_else.2142:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.344
jle_else.2141:
	jmp	div_binary_search.344
jle_else.2132:
	add	%g5, %g6, %g7
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g7, %g6
	jlt	%g28, %g9, jle_else.2143
	mov	%g3, %g6
	return
jle_else.2143:
	jlt	%g8, %g3, jle_else.2144
	jne	%g8, %g3, jeq_else.2145
	mov	%g3, %g5
	return
jeq_else.2145:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.2146
	mov	%g3, %g6
	return
jle_else.2146:
	jlt	%g8, %g3, jle_else.2147
	jne	%g8, %g3, jeq_else.2148
	mov	%g3, %g7
	return
jeq_else.2148:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.344
jle_else.2147:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.344
jle_else.2144:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.2149
	mov	%g3, %g5
	return
jle_else.2149:
	jlt	%g8, %g3, jle_else.2150
	jne	%g8, %g3, jeq_else.2151
	mov	%g3, %g6
	return
jeq_else.2151:
	jmp	div_binary_search.344
jle_else.2150:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.344
jle_else.2129:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.2152
	mov	%g3, %g7
	return
jle_else.2152:
	jlt	%g8, %g3, jle_else.2153
	jne	%g8, %g3, jeq_else.2154
	mov	%g3, %g5
	return
jeq_else.2154:
	add	%g6, %g7, %g5
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g5, %g7
	jlt	%g28, %g9, jle_else.2155
	mov	%g3, %g7
	return
jle_else.2155:
	jlt	%g8, %g3, jle_else.2156
	jne	%g8, %g3, jeq_else.2157
	mov	%g3, %g6
	return
jeq_else.2157:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.2158
	mov	%g3, %g7
	return
jle_else.2158:
	jlt	%g8, %g3, jle_else.2159
	jne	%g8, %g3, jeq_else.2160
	mov	%g3, %g5
	return
jeq_else.2160:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.344
jle_else.2159:
	jmp	div_binary_search.344
jle_else.2156:
	add	%g7, %g6, %g5
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g5, %g6
	jlt	%g28, %g9, jle_else.2161
	mov	%g3, %g6
	return
jle_else.2161:
	jlt	%g8, %g3, jle_else.2162
	jne	%g8, %g3, jeq_else.2163
	mov	%g3, %g7
	return
jeq_else.2163:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.344
jle_else.2162:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.344
jle_else.2153:
	add	%g7, %g5, %g6
	srli	%g7, %g7, 1
	mul	%g8, %g7, %g4
	sub	%g9, %g6, %g5
	jlt	%g28, %g9, jle_else.2164
	mov	%g3, %g5
	return
jle_else.2164:
	jlt	%g8, %g3, jle_else.2165
	jne	%g8, %g3, jeq_else.2166
	mov	%g3, %g7
	return
jeq_else.2166:
	add	%g6, %g5, %g7
	srli	%g6, %g6, 1
	mul	%g8, %g6, %g4
	sub	%g9, %g7, %g5
	jlt	%g28, %g9, jle_else.2167
	mov	%g3, %g5
	return
jle_else.2167:
	jlt	%g8, %g3, jle_else.2168
	jne	%g8, %g3, jeq_else.2169
	mov	%g3, %g6
	return
jeq_else.2169:
	jmp	div_binary_search.344
jle_else.2168:
	mov	%g5, %g6
	mov	%g6, %g7
	jmp	div_binary_search.344
jle_else.2165:
	add	%g5, %g7, %g6
	srli	%g5, %g5, 1
	mul	%g8, %g5, %g4
	sub	%g9, %g6, %g7
	jlt	%g28, %g9, jle_else.2170
	mov	%g3, %g7
	return
jle_else.2170:
	jlt	%g8, %g3, jle_else.2171
	jne	%g8, %g3, jeq_else.2172
	mov	%g3, %g5
	return
jeq_else.2172:
	mov	%g6, %g5
	mov	%g5, %g7
	jmp	div_binary_search.344
jle_else.2171:
	jmp	div_binary_search.344
print_int.349:
	jlt	%g3, %g0, jge_else.2173
	mvhi	%g10, 1525
	mvlo	%g10, 57600
	jlt	%g10, %g3, jle_else.2174
	jne	%g10, %g3, jeq_else.2176
	addi	%g10, %g0, 1
	jmp	jeq_cont.2177
jeq_else.2176:
	addi	%g10, %g0, 0
jeq_cont.2177:
	jmp	jle_cont.2175
jle_else.2174:
	mvhi	%g10, 3051
	mvlo	%g10, 49664
	jlt	%g10, %g3, jle_else.2178
	jne	%g10, %g3, jeq_else.2180
	addi	%g10, %g0, 2
	jmp	jeq_cont.2181
jeq_else.2180:
	addi	%g10, %g0, 1
jeq_cont.2181:
	jmp	jle_cont.2179
jle_else.2178:
	addi	%g10, %g0, 2
jle_cont.2179:
jle_cont.2175:
	mvhi	%g11, 1525
	mvlo	%g11, 57600
	mul	%g11, %g10, %g11
	sub	%g3, %g3, %g11
	st	%g3, %g1, 0
	jlt	%g0, %g10, jle_else.2182
	addi	%g3, %g0, 0
	jmp	jle_cont.2183
jle_else.2182:
	addi	%g11, %g0, 48
	add	%g10, %g11, %g10
	output	%g10
	addi	%g3, %g0, 1
jle_cont.2183:
	mvhi	%g4, 152
	mvlo	%g4, 38528
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g10, %g0, 5
	mvhi	%g11, 762
	mvlo	%g11, 61568
	ld	%g12, %g1, 0
	st	%g3, %g1, 4
	jlt	%g11, %g12, jle_else.2184
	jne	%g11, %g12, jeq_else.2186
	addi	%g3, %g0, 5
	jmp	jeq_cont.2187
jeq_else.2186:
	addi	%g6, %g0, 2
	mvhi	%g11, 305
	mvlo	%g11, 11520
	jlt	%g11, %g12, jle_else.2188
	jne	%g11, %g12, jeq_else.2190
	addi	%g3, %g0, 2
	jmp	jeq_cont.2191
jeq_else.2190:
	addi	%g10, %g0, 1
	mvhi	%g11, 152
	mvlo	%g11, 38528
	jlt	%g11, %g12, jle_else.2192
	jne	%g11, %g12, jeq_else.2194
	addi	%g3, %g0, 1
	jmp	jeq_cont.2195
jeq_else.2194:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jeq_cont.2195:
	jmp	jle_cont.2193
jle_else.2192:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jle_cont.2193:
jeq_cont.2191:
	jmp	jle_cont.2189
jle_else.2188:
	addi	%g5, %g0, 3
	mvhi	%g11, 457
	mvlo	%g11, 50048
	jlt	%g11, %g12, jle_else.2196
	jne	%g11, %g12, jeq_else.2198
	addi	%g3, %g0, 3
	jmp	jeq_cont.2199
jeq_else.2198:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jeq_cont.2199:
	jmp	jle_cont.2197
jle_else.2196:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jle_cont.2197:
jle_cont.2189:
jeq_cont.2187:
	jmp	jle_cont.2185
jle_else.2184:
	addi	%g5, %g0, 7
	mvhi	%g11, 1068
	mvlo	%g11, 7552
	jlt	%g11, %g12, jle_else.2200
	jne	%g11, %g12, jeq_else.2202
	addi	%g3, %g0, 7
	jmp	jeq_cont.2203
jeq_else.2202:
	addi	%g6, %g0, 6
	mvhi	%g11, 915
	mvlo	%g11, 34560
	jlt	%g11, %g12, jle_else.2204
	jne	%g11, %g12, jeq_else.2206
	addi	%g3, %g0, 6
	jmp	jeq_cont.2207
jeq_else.2206:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jeq_cont.2207:
	jmp	jle_cont.2205
jle_else.2204:
	mov	%g3, %g12
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jle_cont.2205:
jeq_cont.2203:
	jmp	jle_cont.2201
jle_else.2200:
	addi	%g10, %g0, 8
	mvhi	%g11, 1220
	mvlo	%g11, 46080
	jlt	%g11, %g12, jle_else.2208
	jne	%g11, %g12, jeq_else.2210
	addi	%g3, %g0, 8
	jmp	jeq_cont.2211
jeq_else.2210:
	mov	%g6, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jeq_cont.2211:
	jmp	jle_cont.2209
jle_else.2208:
	mov	%g5, %g10
	mov	%g3, %g12
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jle_cont.2209:
jle_cont.2201:
jle_cont.2185:
	mvhi	%g10, 152
	mvlo	%g10, 38528
	mul	%g10, %g3, %g10
	sub	%g10, %g12, %g10
	jlt	%g0, %g3, jle_else.2212
	ld	%g11, %g1, 4
	jne	%g11, %g0, jeq_else.2214
	addi	%g3, %g0, 0
	jmp	jeq_cont.2215
jeq_else.2214:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2215:
	jmp	jle_cont.2213
jle_else.2212:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2213:
	mvhi	%g4, 15
	mvlo	%g4, 16960
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 76
	mvlo	%g12, 19264
	st	%g3, %g1, 8
	jlt	%g12, %g10, jle_else.2216
	jne	%g12, %g10, jeq_else.2218
	addi	%g3, %g0, 5
	jmp	jeq_cont.2219
jeq_else.2218:
	addi	%g6, %g0, 2
	mvhi	%g12, 30
	mvlo	%g12, 33920
	jlt	%g12, %g10, jle_else.2220
	jne	%g12, %g10, jeq_else.2222
	addi	%g3, %g0, 2
	jmp	jeq_cont.2223
jeq_else.2222:
	addi	%g11, %g0, 1
	mvhi	%g12, 15
	mvlo	%g12, 16960
	jlt	%g12, %g10, jle_else.2224
	jne	%g12, %g10, jeq_else.2226
	addi	%g3, %g0, 1
	jmp	jeq_cont.2227
jeq_else.2226:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jeq_cont.2227:
	jmp	jle_cont.2225
jle_else.2224:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jle_cont.2225:
jeq_cont.2223:
	jmp	jle_cont.2221
jle_else.2220:
	addi	%g5, %g0, 3
	mvhi	%g12, 45
	mvlo	%g12, 50880
	jlt	%g12, %g10, jle_else.2228
	jne	%g12, %g10, jeq_else.2230
	addi	%g3, %g0, 3
	jmp	jeq_cont.2231
jeq_else.2230:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jeq_cont.2231:
	jmp	jle_cont.2229
jle_else.2228:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jle_cont.2229:
jle_cont.2221:
jeq_cont.2219:
	jmp	jle_cont.2217
jle_else.2216:
	addi	%g5, %g0, 7
	mvhi	%g12, 106
	mvlo	%g12, 53184
	jlt	%g12, %g10, jle_else.2232
	jne	%g12, %g10, jeq_else.2234
	addi	%g3, %g0, 7
	jmp	jeq_cont.2235
jeq_else.2234:
	addi	%g6, %g0, 6
	mvhi	%g12, 91
	mvlo	%g12, 36224
	jlt	%g12, %g10, jle_else.2236
	jne	%g12, %g10, jeq_else.2238
	addi	%g3, %g0, 6
	jmp	jeq_cont.2239
jeq_else.2238:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jeq_cont.2239:
	jmp	jle_cont.2237
jle_else.2236:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jle_cont.2237:
jeq_cont.2235:
	jmp	jle_cont.2233
jle_else.2232:
	addi	%g11, %g0, 8
	mvhi	%g12, 122
	mvlo	%g12, 4608
	jlt	%g12, %g10, jle_else.2240
	jne	%g12, %g10, jeq_else.2242
	addi	%g3, %g0, 8
	jmp	jeq_cont.2243
jeq_else.2242:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jeq_cont.2243:
	jmp	jle_cont.2241
jle_else.2240:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 16
	call	div_binary_search.344
	addi	%g1, %g1, 16
jle_cont.2241:
jle_cont.2233:
jle_cont.2217:
	mvhi	%g11, 15
	mvlo	%g11, 16960
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2244
	ld	%g11, %g1, 8
	jne	%g11, %g0, jeq_else.2246
	addi	%g3, %g0, 0
	jmp	jeq_cont.2247
jeq_else.2246:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2247:
	jmp	jle_cont.2245
jle_else.2244:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2245:
	mvhi	%g4, 1
	mvlo	%g4, 34464
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 7
	mvlo	%g12, 41248
	st	%g3, %g1, 12
	jlt	%g12, %g10, jle_else.2248
	jne	%g12, %g10, jeq_else.2250
	addi	%g3, %g0, 5
	jmp	jeq_cont.2251
jeq_else.2250:
	addi	%g6, %g0, 2
	mvhi	%g12, 3
	mvlo	%g12, 3392
	jlt	%g12, %g10, jle_else.2252
	jne	%g12, %g10, jeq_else.2254
	addi	%g3, %g0, 2
	jmp	jeq_cont.2255
jeq_else.2254:
	addi	%g11, %g0, 1
	mvhi	%g12, 1
	mvlo	%g12, 34464
	jlt	%g12, %g10, jle_else.2256
	jne	%g12, %g10, jeq_else.2258
	addi	%g3, %g0, 1
	jmp	jeq_cont.2259
jeq_else.2258:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jeq_cont.2259:
	jmp	jle_cont.2257
jle_else.2256:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jle_cont.2257:
jeq_cont.2255:
	jmp	jle_cont.2253
jle_else.2252:
	addi	%g5, %g0, 3
	mvhi	%g12, 4
	mvlo	%g12, 37856
	jlt	%g12, %g10, jle_else.2260
	jne	%g12, %g10, jeq_else.2262
	addi	%g3, %g0, 3
	jmp	jeq_cont.2263
jeq_else.2262:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jeq_cont.2263:
	jmp	jle_cont.2261
jle_else.2260:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jle_cont.2261:
jle_cont.2253:
jeq_cont.2251:
	jmp	jle_cont.2249
jle_else.2248:
	addi	%g5, %g0, 7
	mvhi	%g12, 10
	mvlo	%g12, 44640
	jlt	%g12, %g10, jle_else.2264
	jne	%g12, %g10, jeq_else.2266
	addi	%g3, %g0, 7
	jmp	jeq_cont.2267
jeq_else.2266:
	addi	%g6, %g0, 6
	mvhi	%g12, 9
	mvlo	%g12, 10176
	jlt	%g12, %g10, jle_else.2268
	jne	%g12, %g10, jeq_else.2270
	addi	%g3, %g0, 6
	jmp	jeq_cont.2271
jeq_else.2270:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jeq_cont.2271:
	jmp	jle_cont.2269
jle_else.2268:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jle_cont.2269:
jeq_cont.2267:
	jmp	jle_cont.2265
jle_else.2264:
	addi	%g11, %g0, 8
	mvhi	%g12, 12
	mvlo	%g12, 13568
	jlt	%g12, %g10, jle_else.2272
	jne	%g12, %g10, jeq_else.2274
	addi	%g3, %g0, 8
	jmp	jeq_cont.2275
jeq_else.2274:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jeq_cont.2275:
	jmp	jle_cont.2273
jle_else.2272:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jle_cont.2273:
jle_cont.2265:
jle_cont.2249:
	mvhi	%g11, 1
	mvlo	%g11, 34464
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2276
	ld	%g11, %g1, 12
	jne	%g11, %g0, jeq_else.2278
	addi	%g3, %g0, 0
	jmp	jeq_cont.2279
jeq_else.2278:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2279:
	jmp	jle_cont.2277
jle_else.2276:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2277:
	addi	%g4, %g0, 10000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	mvhi	%g12, 0
	mvlo	%g12, 50000
	st	%g3, %g1, 16
	jlt	%g12, %g10, jle_else.2280
	jne	%g12, %g10, jeq_else.2282
	addi	%g3, %g0, 5
	jmp	jeq_cont.2283
jeq_else.2282:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20000
	jlt	%g12, %g10, jle_else.2284
	jne	%g12, %g10, jeq_else.2286
	addi	%g3, %g0, 2
	jmp	jeq_cont.2287
jeq_else.2286:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10000
	jlt	%g12, %g10, jle_else.2288
	jne	%g12, %g10, jeq_else.2290
	addi	%g3, %g0, 1
	jmp	jeq_cont.2291
jeq_else.2290:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jeq_cont.2291:
	jmp	jle_cont.2289
jle_else.2288:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jle_cont.2289:
jeq_cont.2287:
	jmp	jle_cont.2285
jle_else.2284:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30000
	jlt	%g12, %g10, jle_else.2292
	jne	%g12, %g10, jeq_else.2294
	addi	%g3, %g0, 3
	jmp	jeq_cont.2295
jeq_else.2294:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jeq_cont.2295:
	jmp	jle_cont.2293
jle_else.2292:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jle_cont.2293:
jle_cont.2285:
jeq_cont.2283:
	jmp	jle_cont.2281
jle_else.2280:
	addi	%g5, %g0, 7
	mvhi	%g12, 1
	mvlo	%g12, 4464
	jlt	%g12, %g10, jle_else.2296
	jne	%g12, %g10, jeq_else.2298
	addi	%g3, %g0, 7
	jmp	jeq_cont.2299
jeq_else.2298:
	addi	%g6, %g0, 6
	mvhi	%g12, 0
	mvlo	%g12, 60000
	jlt	%g12, %g10, jle_else.2300
	jne	%g12, %g10, jeq_else.2302
	addi	%g3, %g0, 6
	jmp	jeq_cont.2303
jeq_else.2302:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jeq_cont.2303:
	jmp	jle_cont.2301
jle_else.2300:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jle_cont.2301:
jeq_cont.2299:
	jmp	jle_cont.2297
jle_else.2296:
	addi	%g11, %g0, 8
	mvhi	%g12, 1
	mvlo	%g12, 14464
	jlt	%g12, %g10, jle_else.2304
	jne	%g12, %g10, jeq_else.2306
	addi	%g3, %g0, 8
	jmp	jeq_cont.2307
jeq_else.2306:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jeq_cont.2307:
	jmp	jle_cont.2305
jle_else.2304:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 24
	call	div_binary_search.344
	addi	%g1, %g1, 24
jle_cont.2305:
jle_cont.2297:
jle_cont.2281:
	addi	%g11, %g0, 10000
	mul	%g11, %g3, %g11
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2308
	ld	%g11, %g1, 16
	jne	%g11, %g0, jeq_else.2310
	addi	%g3, %g0, 0
	jmp	jeq_cont.2311
jeq_else.2310:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2311:
	jmp	jle_cont.2309
jle_else.2308:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2309:
	addi	%g4, %g0, 1000
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 5000
	st	%g3, %g1, 20
	jlt	%g12, %g10, jle_else.2312
	jne	%g12, %g10, jeq_else.2314
	addi	%g3, %g0, 5
	jmp	jeq_cont.2315
jeq_else.2314:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 2000
	jlt	%g12, %g10, jle_else.2316
	jne	%g12, %g10, jeq_else.2318
	addi	%g3, %g0, 2
	jmp	jeq_cont.2319
jeq_else.2318:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 1000
	jlt	%g12, %g10, jle_else.2320
	jne	%g12, %g10, jeq_else.2322
	addi	%g3, %g0, 1
	jmp	jeq_cont.2323
jeq_else.2322:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jeq_cont.2323:
	jmp	jle_cont.2321
jle_else.2320:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jle_cont.2321:
jeq_cont.2319:
	jmp	jle_cont.2317
jle_else.2316:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 3000
	jlt	%g12, %g10, jle_else.2324
	jne	%g12, %g10, jeq_else.2326
	addi	%g3, %g0, 3
	jmp	jeq_cont.2327
jeq_else.2326:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jeq_cont.2327:
	jmp	jle_cont.2325
jle_else.2324:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jle_cont.2325:
jle_cont.2317:
jeq_cont.2315:
	jmp	jle_cont.2313
jle_else.2312:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 7000
	jlt	%g12, %g10, jle_else.2328
	jne	%g12, %g10, jeq_else.2330
	addi	%g3, %g0, 7
	jmp	jeq_cont.2331
jeq_else.2330:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 6000
	jlt	%g12, %g10, jle_else.2332
	jne	%g12, %g10, jeq_else.2334
	addi	%g3, %g0, 6
	jmp	jeq_cont.2335
jeq_else.2334:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jeq_cont.2335:
	jmp	jle_cont.2333
jle_else.2332:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jle_cont.2333:
jeq_cont.2331:
	jmp	jle_cont.2329
jle_else.2328:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 8000
	jlt	%g12, %g10, jle_else.2336
	jne	%g12, %g10, jeq_else.2338
	addi	%g3, %g0, 8
	jmp	jeq_cont.2339
jeq_else.2338:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jeq_cont.2339:
	jmp	jle_cont.2337
jle_else.2336:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jle_cont.2337:
jle_cont.2329:
jle_cont.2313:
	muli	%g11, %g3, 1000
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2340
	ld	%g11, %g1, 20
	jne	%g11, %g0, jeq_else.2342
	addi	%g3, %g0, 0
	jmp	jeq_cont.2343
jeq_else.2342:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2343:
	jmp	jle_cont.2341
jle_else.2340:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2341:
	addi	%g4, %g0, 100
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 500
	st	%g3, %g1, 24
	jlt	%g12, %g10, jle_else.2344
	jne	%g12, %g10, jeq_else.2346
	addi	%g3, %g0, 5
	jmp	jeq_cont.2347
jeq_else.2346:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 200
	jlt	%g12, %g10, jle_else.2348
	jne	%g12, %g10, jeq_else.2350
	addi	%g3, %g0, 2
	jmp	jeq_cont.2351
jeq_else.2350:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 100
	jlt	%g12, %g10, jle_else.2352
	jne	%g12, %g10, jeq_else.2354
	addi	%g3, %g0, 1
	jmp	jeq_cont.2355
jeq_else.2354:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jeq_cont.2355:
	jmp	jle_cont.2353
jle_else.2352:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jle_cont.2353:
jeq_cont.2351:
	jmp	jle_cont.2349
jle_else.2348:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 300
	jlt	%g12, %g10, jle_else.2356
	jne	%g12, %g10, jeq_else.2358
	addi	%g3, %g0, 3
	jmp	jeq_cont.2359
jeq_else.2358:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jeq_cont.2359:
	jmp	jle_cont.2357
jle_else.2356:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jle_cont.2357:
jle_cont.2349:
jeq_cont.2347:
	jmp	jle_cont.2345
jle_else.2344:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 700
	jlt	%g12, %g10, jle_else.2360
	jne	%g12, %g10, jeq_else.2362
	addi	%g3, %g0, 7
	jmp	jeq_cont.2363
jeq_else.2362:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 600
	jlt	%g12, %g10, jle_else.2364
	jne	%g12, %g10, jeq_else.2366
	addi	%g3, %g0, 6
	jmp	jeq_cont.2367
jeq_else.2366:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jeq_cont.2367:
	jmp	jle_cont.2365
jle_else.2364:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jle_cont.2365:
jeq_cont.2363:
	jmp	jle_cont.2361
jle_else.2360:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 800
	jlt	%g12, %g10, jle_else.2368
	jne	%g12, %g10, jeq_else.2370
	addi	%g3, %g0, 8
	jmp	jeq_cont.2371
jeq_else.2370:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jeq_cont.2371:
	jmp	jle_cont.2369
jle_else.2368:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 32
	call	div_binary_search.344
	addi	%g1, %g1, 32
jle_cont.2369:
jle_cont.2361:
jle_cont.2345:
	muli	%g11, %g3, 100
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2372
	ld	%g11, %g1, 24
	jne	%g11, %g0, jeq_else.2374
	addi	%g3, %g0, 0
	jmp	jeq_cont.2375
jeq_else.2374:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2375:
	jmp	jle_cont.2373
jle_else.2372:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2373:
	addi	%g4, %g0, 10
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	addi	%g11, %g0, 5
	addi	%g12, %g0, 50
	st	%g3, %g1, 28
	jlt	%g12, %g10, jle_else.2376
	jne	%g12, %g10, jeq_else.2378
	addi	%g3, %g0, 5
	jmp	jeq_cont.2379
jeq_else.2378:
	addi	%g6, %g0, 2
	addi	%g12, %g0, 20
	jlt	%g12, %g10, jle_else.2380
	jne	%g12, %g10, jeq_else.2382
	addi	%g3, %g0, 2
	jmp	jeq_cont.2383
jeq_else.2382:
	addi	%g11, %g0, 1
	addi	%g12, %g0, 10
	jlt	%g12, %g10, jle_else.2384
	jne	%g12, %g10, jeq_else.2386
	addi	%g3, %g0, 1
	jmp	jeq_cont.2387
jeq_else.2386:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.344
	addi	%g1, %g1, 40
jeq_cont.2387:
	jmp	jle_cont.2385
jle_else.2384:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.344
	addi	%g1, %g1, 40
jle_cont.2385:
jeq_cont.2383:
	jmp	jle_cont.2381
jle_else.2380:
	addi	%g5, %g0, 3
	addi	%g12, %g0, 30
	jlt	%g12, %g10, jle_else.2388
	jne	%g12, %g10, jeq_else.2390
	addi	%g3, %g0, 3
	jmp	jeq_cont.2391
jeq_else.2390:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.344
	addi	%g1, %g1, 40
jeq_cont.2391:
	jmp	jle_cont.2389
jle_else.2388:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.344
	addi	%g1, %g1, 40
jle_cont.2389:
jle_cont.2381:
jeq_cont.2379:
	jmp	jle_cont.2377
jle_else.2376:
	addi	%g5, %g0, 7
	addi	%g12, %g0, 70
	jlt	%g12, %g10, jle_else.2392
	jne	%g12, %g10, jeq_else.2394
	addi	%g3, %g0, 7
	jmp	jeq_cont.2395
jeq_else.2394:
	addi	%g6, %g0, 6
	addi	%g12, %g0, 60
	jlt	%g12, %g10, jle_else.2396
	jne	%g12, %g10, jeq_else.2398
	addi	%g3, %g0, 6
	jmp	jeq_cont.2399
jeq_else.2398:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.344
	addi	%g1, %g1, 40
jeq_cont.2399:
	jmp	jle_cont.2397
jle_else.2396:
	mov	%g3, %g10
	mov	%g26, %g6
	mov	%g6, %g5
	mov	%g5, %g26
	subi	%g1, %g1, 40
	call	div_binary_search.344
	addi	%g1, %g1, 40
jle_cont.2397:
jeq_cont.2395:
	jmp	jle_cont.2393
jle_else.2392:
	addi	%g11, %g0, 8
	addi	%g12, %g0, 80
	jlt	%g12, %g10, jle_else.2400
	jne	%g12, %g10, jeq_else.2402
	addi	%g3, %g0, 8
	jmp	jeq_cont.2403
jeq_else.2402:
	mov	%g6, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.344
	addi	%g1, %g1, 40
jeq_cont.2403:
	jmp	jle_cont.2401
jle_else.2400:
	mov	%g5, %g11
	mov	%g3, %g10
	subi	%g1, %g1, 40
	call	div_binary_search.344
	addi	%g1, %g1, 40
jle_cont.2401:
jle_cont.2393:
jle_cont.2377:
	muli	%g11, %g3, 10
	sub	%g10, %g10, %g11
	jlt	%g0, %g3, jle_else.2404
	ld	%g11, %g1, 28
	jne	%g11, %g0, jeq_else.2406
	addi	%g3, %g0, 0
	jmp	jeq_cont.2407
jeq_else.2406:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jeq_cont.2407:
	jmp	jle_cont.2405
jle_else.2404:
	addi	%g11, %g0, 48
	add	%g3, %g11, %g3
	output	%g3
	addi	%g3, %g0, 1
jle_cont.2405:
	addi	%g3, %g0, 48
	add	%g3, %g3, %g10
	output	%g3
	return
jge_else.2173:
	addi	%g10, %g0, 45
	st	%g3, %g1, 32
	output	%g10
	ld	%g3, %g1, 32
	sub	%g3, %g0, %g3
	jmp	print_int.349
min_caml_start:
	addi	%g28, %g0, 1
	addi	%g29, %g0, -1
	setL %g26, l.1778
	fld	%f16, %g26, 0
	setL %g26, l.1810
	fld	%f17, %g26, 0
	setL %g26, l.1808
	fld	%f18, %g26, 0
	setL %g26, l.1806
	fld	%f19, %g26, 0
	setL %g26, l.1804
	fld	%f20, %g26, 0
	setL %g26, l.1802
	fld	%f21, %g26, 0
	setL %g26, l.1800
	fld	%f22, %g26, 0
	setL %g26, l.1798
	fld	%f23, %g26, 0
	setL %g26, l.1795
	fld	%f24, %g26, 0
	setL %g26, l.1793
	fld	%f25, %g26, 0
	setL %g26, l.1791
	fld	%f26, %g26, 0
	setL %g26, l.1789
	fld	%f27, %g26, 0
	setL %g26, l.1787
	fld	%f28, %g26, 0
	setL %g26, l.1785
	fld	%f29, %g26, 0
	setL %g26, l.1783
	fld	%f30, %g26, 0
	fmov	%f0, %f30
	fmov	%f1, %f29
	fmov	%f10, %f28
	fmov	%f11, %f27
	fmov	%f12, %f26
	mov	%g3, %g2
	addi	%g2, %g2, 16
	setL %g4, sin_sub.318
	st	%g4, %g3, 0
	fst	%f10, %g3, -8
	addi	%g4, %g0, 1
	addi	%g10, %g0, 0
	st	%g3, %g1, 0
	mov	%g3, %g4
	mov	%g4, %g10
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 1
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	addi	%g3, %g0, 1
	addi	%g4, %g0, 0
	subi	%g1, %g1, 8
	call	min_caml_create_array
	addi	%g1, %g1, 8
	mov	%g10, %g3
	fmov	%f13, %f25
	fst	%f0, %g1, 4
	fsqrt	%f13, %f13
	fmov	%f14, %f24
	fsub	%f13, %f14, %f13
	fmov	%f14, %f16
	fjlt	%f13, %f14, fjge_else.2408
	fmov	%f15, %f13
	jmp	fjge_cont.2409
fjge_else.2408:
	fneg	%f15, %f13
fjge_cont.2409:
	fst	%f1, %g1, 8
	fjlt	%f10, %f15, fjge_else.2410
	fjlt	%f15, %f14, fjge_else.2412
	jmp	fjge_cont.2413
fjge_else.2412:
	fadd	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.2414
	fjlt	%f15, %f14, fjge_else.2416
	jmp	fjge_cont.2417
fjge_else.2416:
	fadd	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.2418
	fjlt	%f15, %f14, fjge_else.2420
	jmp	fjge_cont.2421
fjge_else.2420:
	fadd	%f0, %f15, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f15, %f0
fjge_cont.2421:
	jmp	fjge_cont.2419
fjge_else.2418:
	fsub	%f0, %f15, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f15, %f0
fjge_cont.2419:
fjge_cont.2417:
	jmp	fjge_cont.2415
fjge_else.2414:
	fsub	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.2422
	fjlt	%f15, %f14, fjge_else.2424
	jmp	fjge_cont.2425
fjge_else.2424:
	fadd	%f0, %f15, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f15, %f0
fjge_cont.2425:
	jmp	fjge_cont.2423
fjge_else.2422:
	fsub	%f0, %f15, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f15, %f0
fjge_cont.2423:
fjge_cont.2415:
fjge_cont.2413:
	jmp	fjge_cont.2411
fjge_else.2410:
	fsub	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.2426
	fjlt	%f15, %f14, fjge_else.2428
	jmp	fjge_cont.2429
fjge_else.2428:
	fadd	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.2430
	fjlt	%f15, %f14, fjge_else.2432
	jmp	fjge_cont.2433
fjge_else.2432:
	fadd	%f0, %f15, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f15, %f0
fjge_cont.2433:
	jmp	fjge_cont.2431
fjge_else.2430:
	fsub	%f0, %f15, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f15, %f0
fjge_cont.2431:
fjge_cont.2429:
	jmp	fjge_cont.2427
fjge_else.2426:
	fsub	%f15, %f15, %f10
	fjlt	%f10, %f15, fjge_else.2434
	fjlt	%f15, %f14, fjge_else.2436
	jmp	fjge_cont.2437
fjge_else.2436:
	fadd	%f0, %f15, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f15, %f0
fjge_cont.2437:
	jmp	fjge_cont.2435
fjge_else.2434:
	fsub	%f0, %f15, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f15, %f0
fjge_cont.2435:
fjge_cont.2427:
fjge_cont.2411:
	fld	%f2, %g1, 4
	fjlt	%f2, %f15, fjge_else.2438
	fjlt	%f14, %f13, fjge_else.2440
	addi	%g10, %g0, 0
	jmp	fjge_cont.2441
fjge_else.2440:
	addi	%g10, %g0, 1
fjge_cont.2441:
	jmp	fjge_cont.2439
fjge_else.2438:
	fjlt	%f14, %f13, fjge_else.2442
	addi	%g10, %g0, 1
	jmp	fjge_cont.2443
fjge_else.2442:
	addi	%g10, %g0, 0
fjge_cont.2443:
fjge_cont.2439:
	fjlt	%f2, %f15, fjge_else.2444
	fmov	%f13, %f15
	jmp	fjge_cont.2445
fjge_else.2444:
	fsub	%f13, %f10, %f15
fjge_cont.2445:
	fjlt	%f12, %f13, fjge_else.2446
	jmp	fjge_cont.2447
fjge_else.2446:
	fsub	%f13, %f2, %f13
fjge_cont.2447:
	fmul	%f13, %f13, %f11
	fmov	%f15, %f23
	fmul	%f3, %f13, %f13
	fmov	%f4, %f22
	fmov	%f5, %f21
	fdiv	%f6, %f3, %f5
	fmov	%f7, %f20
	fsub	%f6, %f4, %f6
	fdiv	%f6, %f3, %f6
	fmov	%f8, %f19
	fsub	%f6, %f7, %f6
	fdiv	%f6, %f3, %f6
	fsub	%f6, %f8, %f6
	fdiv	%f3, %f3, %f6
	fsub	%f3, %f15, %f3
	fdiv	%f13, %f13, %f3
	fld	%f3, %g1, 8
	fmul	%f6, %f3, %f13
	fmul	%f13, %f13, %f13
	fadd	%f13, %f15, %f13
	fdiv	%f13, %f6, %f13
	jne	%g10, %g0, jeq_else.2448
	fneg	%f13, %f13
	jmp	jeq_cont.2449
jeq_else.2448:
jeq_cont.2449:
	fjlt	%f13, %f14, fjge_else.2450
	fmov	%f6, %f13
	jmp	fjge_cont.2451
fjge_else.2450:
	fneg	%f6, %f13
fjge_cont.2451:
	fjlt	%f10, %f6, fjge_else.2452
	fjlt	%f6, %f14, fjge_else.2454
	jmp	fjge_cont.2455
fjge_else.2454:
	fadd	%f6, %f6, %f10
	fjlt	%f10, %f6, fjge_else.2456
	fjlt	%f6, %f14, fjge_else.2458
	jmp	fjge_cont.2459
fjge_else.2458:
	fadd	%f6, %f6, %f10
	fjlt	%f10, %f6, fjge_else.2460
	fjlt	%f6, %f14, fjge_else.2462
	jmp	fjge_cont.2463
fjge_else.2462:
	fadd	%f0, %f6, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f6, %f0
fjge_cont.2463:
	jmp	fjge_cont.2461
fjge_else.2460:
	fsub	%f0, %f6, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f6, %f0
fjge_cont.2461:
fjge_cont.2459:
	jmp	fjge_cont.2457
fjge_else.2456:
	fsub	%f6, %f6, %f10
	fjlt	%f10, %f6, fjge_else.2464
	fjlt	%f6, %f14, fjge_else.2466
	jmp	fjge_cont.2467
fjge_else.2466:
	fadd	%f0, %f6, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f6, %f0
fjge_cont.2467:
	jmp	fjge_cont.2465
fjge_else.2464:
	fsub	%f0, %f6, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f6, %f0
fjge_cont.2465:
fjge_cont.2457:
fjge_cont.2455:
	jmp	fjge_cont.2453
fjge_else.2452:
	fsub	%f6, %f6, %f10
	fjlt	%f10, %f6, fjge_else.2468
	fjlt	%f6, %f14, fjge_else.2470
	jmp	fjge_cont.2471
fjge_else.2470:
	fadd	%f6, %f6, %f10
	fjlt	%f10, %f6, fjge_else.2472
	fjlt	%f6, %f14, fjge_else.2474
	jmp	fjge_cont.2475
fjge_else.2474:
	fadd	%f0, %f6, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f6, %f0
fjge_cont.2475:
	jmp	fjge_cont.2473
fjge_else.2472:
	fsub	%f0, %f6, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f6, %f0
fjge_cont.2473:
fjge_cont.2471:
	jmp	fjge_cont.2469
fjge_else.2468:
	fsub	%f6, %f6, %f10
	fjlt	%f10, %f6, fjge_else.2476
	fjlt	%f6, %f14, fjge_else.2478
	jmp	fjge_cont.2479
fjge_else.2478:
	fadd	%f0, %f6, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f6, %f0
fjge_cont.2479:
	jmp	fjge_cont.2477
fjge_else.2476:
	fsub	%f0, %f6, %f10
	ld	%g27, %g1, 0
	ld	%g26, %g27, 0
	subi	%g1, %g1, 16
	callR	%g26
	addi	%g1, %g1, 16
	fmov	%f6, %f0
fjge_cont.2477:
fjge_cont.2469:
fjge_cont.2453:
	fjlt	%f2, %f6, fjge_else.2480
	fjlt	%f14, %f13, fjge_else.2482
	addi	%g3, %g0, 0
	jmp	fjge_cont.2483
fjge_else.2482:
	addi	%g3, %g0, 1
fjge_cont.2483:
	jmp	fjge_cont.2481
fjge_else.2480:
	fjlt	%f14, %f13, fjge_else.2484
	addi	%g3, %g0, 1
	jmp	fjge_cont.2485
fjge_else.2484:
	addi	%g3, %g0, 0
fjge_cont.2485:
fjge_cont.2481:
	fjlt	%f2, %f6, fjge_else.2486
	fmov	%f10, %f6
	jmp	fjge_cont.2487
fjge_else.2486:
	fsub	%f10, %f10, %f6
fjge_cont.2487:
	fjlt	%f12, %f10, fjge_else.2488
	jmp	fjge_cont.2489
fjge_else.2488:
	fsub	%f10, %f2, %f10
fjge_cont.2489:
	fmul	%f10, %f10, %f11
	fmul	%f11, %f10, %f10
	fdiv	%f12, %f11, %f5
	fsub	%f12, %f4, %f12
	fdiv	%f12, %f11, %f12
	fsub	%f12, %f7, %f12
	fdiv	%f12, %f11, %f12
	fsub	%f12, %f8, %f12
	fdiv	%f11, %f11, %f12
	fsub	%f11, %f15, %f11
	fdiv	%f10, %f10, %f11
	fmul	%f11, %f3, %f10
	fmul	%f10, %f10, %f10
	fadd	%f10, %f15, %f10
	fdiv	%f10, %f11, %f10
	jne	%g3, %g0, jeq_else.2490
	fneg	%f10, %f10
	jmp	jeq_cont.2491
jeq_else.2490:
jeq_cont.2491:
	fmov	%f11, %f18
	fadd	%f10, %f10, %f11
	fmov	%f11, %f17
	fsub	%f10, %f10, %f11
	mvhi	%g3, 15
	mvlo	%g3, 16960
	subi	%g1, %g1, 16
	call	min_caml_float_of_int
	addi	%g1, %g1, 16
	fmul	%f0, %f10, %f0
	subi	%g1, %g1, 16
	call	min_caml_int_of_float
	addi	%g1, %g1, 16
	subi	%g1, %g1, 16
	call	print_int.349
	addi	%g1, %g1, 16
	halt
