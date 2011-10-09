.init_heap_size 2496
! 78 * 32
FLOAT_ZERO:
	.float 0.0
FLOAT_MAGICI:
	.int 8388608
FLOAT_MAGICF:
	.float 8388608.0
FLOAT_MAGICFHX:
	.int 1258291200			! 0x4b000000
min_caml_atan_table:
	.float 0.785398163397448279
	.float 0.463647609000806094
	.float 0.244978663126864143
	.float 0.124354994546761438
	.float 0.06241880999595735
	.float 0.0312398334302682774
	.float 0.0156237286204768313
	.float 0.00781234106010111114
	.float 0.00390623013196697176
	.float 0.00195312251647881876
	.float 0.000976562189559319459
	.float 0.00048828121119489829
	.float 0.000244140620149361771
	.float 0.000122070311893670208
	.float 6.10351561742087726e-05
	.float 3.05175781155260957e-05
	.float 1.52587890613157615e-05
	.float 7.62939453110197e-06
	.float 3.81469726560649614e-06
	.float 1.90734863281018696e-06
	.float 9.53674316405960844e-07
	.float 4.76837158203088842e-07
	.float 2.38418579101557974e-07
	.float 1.19209289550780681e-07
	.float 5.96046447753905522e-08
min_caml_rsqrt_table:
	.float 1.0
	.float 0.707106781186547462
	.float 0.5
	.float 0.353553390593273731
	.float 0.25
	.float 0.176776695296636865
	.float 0.125
	.float 0.0883883476483184327
	.float 0.0625
	.float 0.0441941738241592164
	.float 0.03125
	.float 0.0220970869120796082
	.float 0.015625
	.float 0.0110485434560398041
	.float 0.0078125
	.float 0.00552427172801990204
	.float 0.00390625
	.float 0.00276213586400995102
	.float 0.001953125
	.float 0.00138106793200497551
	.float 0.0009765625
	.float 0.000690533966002487756
	.float 0.00048828125
	.float 0.000345266983001243878
	.float 0.000244140625
	.float 0.000172633491500621939
	.float 0.0001220703125
	.float 8.63167457503109694e-05
	.float 6.103515625e-05
	.float 4.31583728751554847e-05
	.float 3.0517578125e-05
	.float 2.15791864375777424e-05
	.float 1.52587890625e-05
	.float 1.07895932187888712e-05
	.float 7.62939453125e-06
	.float 5.39479660939443559e-06
	.float 3.814697265625e-06
	.float 2.6973983046972178e-06
	.float 1.9073486328125e-06
	.float 1.3486991523486089e-06
	.float 9.5367431640625e-07
	.float 6.74349576174304449e-07
	.float 4.76837158203125e-07
	.float 3.37174788087152224e-07
	.float 2.384185791015625e-07
	.float 1.68587394043576112e-07
	.float 1.1920928955078125e-07
	.float 8.42936970217880561e-08
	.float 5.9604644775390625e-08
	.float 4.21468485108940281e-08

!#####################################################################
!
! 		↓　ここから lib_asm.s
!
!#####################################################################

!#####################################################################
! * 算術関数用定数テーブル
!#####################################################################
!#####################################################################
! * floor
!#####################################################################
! floor(f) = itof(ftoi(f)) という適当仕様
! これじゃおそらく明らかに誤差るので、まだ要実装
min_caml_floor:
	call min_caml_int_of_float
	call min_caml_float_of_int
	return

!#####################################################################
! * float_of_int
!#####################################################################
min_caml_float_of_int:
	mvhi %g4, 0
	mvlo %g4, 0
	jlt %g4, %g3, ITOF_MAIN  ! if(0 < %g3) goto ITOF_MAIN
	sub %g3, %g4, %g3
	call min_caml_float_of_int
	fneg %f0, %f0
	return
ITOF_MAIN:
	! g5=mi f1=mf g7=mfhx
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	setL %g6, FLOAT_MAGICF
	fld %f1, %g6, 0
	setL %g7, FLOAT_MAGICFHX
	ld %g7, %g7, 0

	jlt %g5, %g3, ITOF_BIG	! if(%g3 <= mi) goto ITOF_BIG
	jeq %g5, %g3, ITOF_BIG

	add %g3, %g3, %g7		! g3 = g3 + mfhx
	st %g3, %g1, 0			! push g3
	fld %f0, %g1, 0			! f0 = pop
	fsub %f0, %f0, %f1		! f0 = f0 - mf

	return
ITOF_BIG:
	! %g3 = %g8 * mi + %g9なる%g8, %g9を求める
	div %g8, %g3, %g5
	mul %g9, %g8, %g5
	sub %g9R %g3, %g8

	st %g9, %g1, 4
	fld %f2, %g1, 4
	fsub %f2, %f2, %f1	

	st %g8, %g1, 0
	fld %f0, %g1, 0
	
	fadd %f0, %f0, %f2

	return

!#####################################################################
! * int_of_float
!#####################################################################
min_caml_int_of_float:
	setL %g3, FLOAT_ZERO
	fld %f1, %g3, 0
	fjlt %f1, %f0, FTOI_MAIN	! if (0.0 <= %f0) goto FTOI_MAIN
	fjeq %f1, %f0, FTOI_MAIN
	fneg %f0
	call min_caml_int_of_float
	sub %g3, %g0, %g3
	return
FTOI_MAIN:
	! g5=mi f2=mf g7=mfhx
	setL %g5, FLOAT_MAGICI
	ld %g5, %g5, 0
	setL %g6, FLOAT_MAGICF
	fld %f2, %g6, 0
	setL %g7, FLOAT_MAGICFHX
	ld %g7, %g7, 0
	
	fjlt %f0, %f2, FTOI_BIG	! if(%f0 <= mf) goto FTOI_BIG
	fjeq %f0, %f2, FTOI_BIG

	fadd %f0, %f0, %f2		! f0 = f0 + mf
	fst %f0, %g1, 0			! push f0
	ld %g3, %g1, 0			! g3 = pop
	sub %g3, %g3, %f1		! g3 = g3 - mfhx

	return
FTOI_BIG:
	! %f0 = %g8 * mi + %f3 なる%g8, %f3を求める
	mvhi %g8 0
	mvlo %g8 0
	fmov %f3, %f0 ! g8 = 0, f3 = $f0
FTOI_LOOP:
	addi %g8, %g8, 1 		!  %g8 += 1
	fsub %f3, %f3, %f2		! %f3 -= 8388608.0
	
	fjlt %f2, %f3, FTOI_LOOP	! if(mf <= %f3) goto FTOI_LOOP
	fjeq %f2, %f3, FTOI_LOOP

	mov %g3, %g0
FTOI_LOOP2:
	add %g3, %g3, %g5		# $i1 = $q * $mi
	subi %g8 %g8 1
	blt %g0, %g8, FTOI_LOOP2
	fadd %f3, %f3, %f2
	fst %f3, %g1, 0
	ld %g4, %g1, 0
	sub %g4, %g4, %g7
	add %g3, %g3, %g4
	return

!#####################################################################
! * read_int
! * intバイナリ読み込み
!#####################################################################
min_caml_read_int:
read_int_1:i
	! 31-24
	input %g3
	slli %g3, %g3, 24
	! 23-16
	input %g4
	slli %g4, %g4, 16
	add %g3, %g3, %g4
	! 15-8
	input %g4
	slli %g4, %g4, 8
	add %g3, %g3, %g4
	! 7-0
	input %g4
	add %g3, %g3, %g4
	return

!#####################################################################
! * read_float
! * floatバイナリ読み込み
!#####################################################################
min_caml_read_float:
	! 31-24
	input %g3
	slli %g3, %g3, 24
	! 23-16
	input %g4
	slli %g4, %g4, 16
	add %g3, %g3, %g4
	! 15-8
	input %g4
	slli %g4, %g4, 8
	add %g3, %g3, %g4
	! 7-0
	input %g4
	add %g3, %g3, %g4
	st %g3, %g1, 0		! intレジスタをfloatレジスタに移動
	fld %f0, %g1, 0
	return

!#####################################################################
! * read
! * バイト読み込み
! * 失敗してたらループ
!#####################################################################
min_caml_read:
	input %g3
	return

!#####################################################################
! * write
! * バイト出力
! * 失敗してたらループ
!####################################################################
min_caml_write:
	output %g3
	return

!#####################################################################
!
! 		↑　ここまで lib_asm.s
!
!#####################################################################
