open Asm

external gethi : float -> int32 = "gethi"
external getlo : float -> int32 = "getlo"

(* create_arrayなどのライブラリ関数をハードコーディング *)
let define_library oc =
Printf.fprintf oc "
!#####################################################################
! * ここからライブラリ関数
!#####################################################################

! * create_array
min_caml_create_array:
	slli %%g3, %%g3, 2
	add %%g5, %%g3, %%g2
	mov %%g3, %%g2
CREATE_ARRAY_LOOP:
	jlt %%g5, %%g2, CREATE_ARRAY_END
	jeq %%g5, %%g2, CREATE_ARRAY_END
	st %%g4, %%g2, 0
	addi %%g2, %%g2, 4
	jmp CREATE_ARRAY_LOOP
CREATE_ARRAY_END:
	return

! * create_float_array
min_caml_create_float_array:
	slli %%g3, %%g3, 2
	add %%g4, %%g3, %%g2
	mov %%g3, %%g2
CREATE_FLOAT_ARRAY_LOOP:
	jlt %%g4, %%g2, CREATE_FLOAT_ARRAY_END
	jeq %%g4, %%g2, CREATE_ARRAY_END
	fst %%f0, %%g2, 0
	addi %%g2, %%g2, 4
	jmp CREATE_FLOAT_ARRAY_LOOP
CREATE_FLOAT_ARRAY_END:
	return

!#####################################################################
! * ここまでライブラリ関数
!#####################################################################

";;

let stackset = ref S.empty (* すでにSaveされた変数の集合 (caml2html: emit_stackset) *)
let stackmap = ref [] (* Saveされた変数の、スタックにおける位置 (caml2html: emit_stackmap) *)
let save x =
  stackset := S.add x !stackset;
  if not (List.mem x !stackmap) then
    stackmap := !stackmap @ [x]
let savef x =
  stackset := S.add x !stackset;
  if not (List.mem x !stackmap) then
    stackmap := !stackmap @ [x]
  (*
  if not (List.mem x !stackmap) then
    (let pad =
      if List.length !stackmap mod 2 = 0 then [] else [Id.gentmp Type.Int] in
    stackmap := !stackmap @ pad @ [x; x])*)
let locate x =
  let rec loc = function
    | [] -> []
    | y :: zs when x = y -> 0 :: List.map succ (loc zs)
    | y :: zs -> List.map succ (loc zs) in
  loc !stackmap
let offset x = 4 * List.hd (locate x)
let stacksize () = align ((List.length !stackmap + 1) * 4)

let pp_id_or_imm = function
  | V(x) -> x
  | C(i) -> string_of_int i

(* 関数呼び出しのために引数を並べ替える(register shuffling) (caml2html: emit_shuffle) *)
let rec shuffle sw xys =
  (* remove identical moves *)
  let _, xys = List.partition (fun (x, y) -> x = y) xys in
  (* find acyclic moves *)
  match List.partition (fun (_, y) -> List.mem_assoc y xys) xys with
  | [], [] -> []
  | (x, y) :: xys, [] -> (* no acyclic moves; resolve a cyclic move *)
      (y, sw) :: (x, y) :: shuffle sw (List.map
					 (function
					   | (y', z) when y = y' -> (sw, z)
					   | yz -> yz)
					 xys)
  | xys, acyc -> acyc @ shuffle sw xys

type dest = Tail | NonTail of Id.t (* 末尾かどうかを表すデータ型 (caml2html: emit_dest) *)
let rec g oc = function (* 命令列のアセンブリ生成 (caml2html: emit_g) *)
  | dest, Ans(exp) -> g' oc (dest, exp)
  | dest, Let((x, t), exp, e) ->
      g' oc (NonTail(x), exp);
      g oc (dest, e)
and g' oc = function (* 各命令のアセンブリ生成 (caml2html: emit_gprime) *)
  (* 末尾でなかったら計算結果をdestにセット (caml2html: emit_nontail) *)
  | NonTail(_), Nop -> ()

(*  | NonTail(x), Set(i) -> Printf.fprintf oc "\tset\t%d, %s\n" i x*)
(* %r0は常に0 *)
  | NonTail(x), Set(i) ->
  	Printf.fprintf oc "\tmvhi\t%s, %d\n" x ((i lsr 16) mod (1 lsl 16));
  	Printf.fprintf oc "\tmvlo\t%s, %d\n" x (i mod (1 lsl 16))

(*  | NonTail(x), SetL(Id.L(y)) -> Printf.fprintf oc "\tset\t%s, %s\n" y x*) (* ラベルのコピー *)
  | NonTail(x), SetL(Id.L(y)) ->
  		Printf.fprintf oc "\tsetL %s, %s\n" x y (* ラベルのコピー *)

  | NonTail(x), Mov(y) when x = y -> ()
  | NonTail(x), Mov(y) -> Printf.fprintf oc "\tmov\t%s, %s\n" x y

(*  | NonTail(x), Neg(y) -> Printf.fprintf oc "\tneg\t%s, %s\n" y x*)
  | NonTail(x), Neg(y) -> Printf.fprintf oc "\tsub\t%s, %%g0, %s\n" x y

(*  | NonTail(x), Add(y, z') -> Printf.fprintf oc "\tadd\t%s, %s, %s\n" y (pp_id_or_imm z') x*)
  | NonTail(x), Add(y, V(z)) -> Printf.fprintf oc "\tadd\t%s, %s, %s\n" x y (pp_id_or_imm (V(z)))
  | NonTail(x), Add(y, C(z)) -> Printf.fprintf oc "\taddi\t%s, %s, %s\n" x y (pp_id_or_imm (C(z)))	(*即値*)

(*  | NonTail(x), Sub(y, z') -> Printf.fprintf oc "\tsub\t%s, %s, %s\n" y (pp_id_or_imm z') x*)
  | NonTail(x), Sub(y, V(z)) -> Printf.fprintf oc "\tsub\t%s, %s, %s\n" x y (pp_id_or_imm (V(z)))
  | NonTail(x), Sub(y, C(z)) -> Printf.fprintf oc "\tsubi\t%s, %s, %s\n" x y (pp_id_or_imm (C(z)))	(*即値*)

  | NonTail(x), Mul(y, V(z)) -> Printf.fprintf oc "\tmul\t%s, %s, %s\n" x y (pp_id_or_imm (V(z)))
  | NonTail(x), Mul(y, C(z)) -> Printf.fprintf oc "\tmuli\t%s, %s, %s\n" x y (pp_id_or_imm (C(z)))	(*即値*)

  | NonTail(x), Div(y, V(z)) -> Printf.fprintf oc "\tdiv\t%s, %s, %s\n" x y (pp_id_or_imm (V(z)))
  | NonTail(x), Div(y, C(z)) -> Printf.fprintf oc "\tdivi\t%s, %s, %s\n" x y (pp_id_or_imm (C(z)))	(*即値*)

(*  | NonTail(x), SLL(y, z') -> Printf.fprintf oc "\tsll\t%s, %s, %s\n" y (pp_id_or_imm z') x*)
  | NonTail(x), SLL(y, V(z)) -> Printf.fprintf oc "\tsll\t%s, %s, %s\n" x (pp_id_or_imm (V(z))) y
  | NonTail(x), SLL(y, C(z)) ->
	 Printf.fprintf oc "\tslli\t%s, %s, %s\n" x y (pp_id_or_imm (C(z))) (*即値 *)

  | NonTail(x), Ld(y, V z) ->
   	begin
  		let z' = pp_id_or_imm (V z) in
(*	  	Printf.fprintf oc "\tsub\t%s, %s, %s\n" y y z';*)
	  	Printf.fprintf oc "\tadd\t%s, %s, %s\n" y y z';
	  	Printf.fprintf oc "\tld\t%s, %s, 0\n" x y
  	end
  | NonTail(x), Ld(y, C z) -> let z' = C z in Printf.fprintf oc "\tld\t%s, %s, %s\n" x y (pp_id_or_imm z')
  | NonTail(_), St(x, y, V z) ->
   	begin
  		let z' = pp_id_or_imm (V z) in
(*	  	Printf.fprintf oc "\tsub\t%s, %s, %s\n" y y z';*)
	  	Printf.fprintf oc "\tadd\t%s, %s, %s\n" y y z';
	  	Printf.fprintf oc "\tst\t%s, %s, 0\n" x y
  	end
  | NonTail(_), St(x, y, C z) -> let z' = C z in Printf.fprintf oc "\tst\t%s, %s, %s\n" x y (pp_id_or_imm z')

  | NonTail(x), FMovD(y) when x = y -> ()
(* なんで二回fmovsを呼ぶのは倍精度で計算しているから *)
(* ちょっとあやしい *)
  | NonTail(x), FMovD(y) ->
      Printf.fprintf oc "\tfmov\t%s, %s\n" x y
(*      Printf.fprintf oc "\tfmovs\t%s, %s\n" x y;
      Printf.fprintf oc "\tfmovs\t%s, %s\n" (co_freg x) (co_freg y)*)
  | NonTail(x), FNegD(y) ->
      Printf.fprintf oc "\tfneg\t%s, %s\n" x y
(*      Printf.fprintf oc "\tfnegs\t%s, %s\n" y x;*)
(*      if x <> y then Printf.fprintf oc "\tfmovs\t%s, %s\n" (co_freg x) (co_freg y)*)

(*  | NonTail(x), FAddD(y, z) -> Printf.fprintf oc "\tfaddd\t%s, %s, %s\n" y z x
  | NonTail(x), FSubD(y, z) -> Printf.fprintf oc "\tfsubd\t%s, %s, %s\n" y z x
  | NonTail(x), FMulD(y, z) -> Printf.fprintf oc "\tfmuld\t%s, %s, %s\n" y z x
  | NonTail(x), FDivD(y, z) -> Printf.fprintf oc "\tfdivd\t%s, %s, %s\n" y z x*)
  | NonTail(x), FAddD(y, z) -> Printf.fprintf oc "\tfadd\t%s, %s, %s\n" x y z
  | NonTail(x), FSubD(y, z) -> Printf.fprintf oc "\tfsub\t%s, %s, %s\n" x y z
  | NonTail(x), FMulD(y, z) -> Printf.fprintf oc "\tfmul\t%s, %s, %s\n" x y z
  | NonTail(x), FDivD(y, z) -> Printf.fprintf oc "\tfdiv\t%s, %s, %s\n" x y z
  
(*  | NonTail(x), LdDF(y, z') -> Printf.fprintf oc "\tldd\t[%s + %s], %s\n" y (pp_id_or_imm z') x
  | NonTail(_), StDF(x, y, z') -> Printf.fprintf oc "\tstd\t%s, [%s + %s]\n" x y (pp_id_or_imm z')*)
  | NonTail(x), LdDF(y, V(z)) ->
  	begin
  		let z' = pp_id_or_imm (V(z)) in
	  	Printf.fprintf oc "\tsub\t%s, %s, %s\n" y y z';
	  	Printf.fprintf oc "\tfld\t%s, %s, 0\n" x y
  	end
  | NonTail(x), LdDF(y, C(z)) -> Printf.fprintf oc "\tfld\t%s, %s, %s\n" x y (pp_id_or_imm (C(z)))
  | NonTail(_), StDF(x, y, V(z)) ->
  	begin
  		let z' = pp_id_or_imm (V(z)) in
	  	Printf.fprintf oc "\tsub\t%s, %s, %s\n" y y z';
	  	Printf.fprintf oc "\tfst\t%s, %s, 0\n" x y
  	end
  | NonTail(_), StDF(x, y, C(z)) -> Printf.fprintf oc "\tfst\t%s, %s, %s\n" x y (pp_id_or_imm (C(z)))
  
  | NonTail(_), Comment(s) -> Printf.fprintf oc "\t! %s\n" s
  (* 退避の仮想命令の実装 (caml2html: emit_save) *)
  | NonTail(_), Save(x, y) when List.mem x allregs && not (S.mem y !stackset) ->
      save y;
      Printf.fprintf oc "\tst\t%s, %s, %d\n" x reg_sp (offset y)
  | NonTail(_), Save(x, y) when List.mem x allfregs && not (S.mem y !stackset) ->
      savef y;
      Printf.fprintf oc "\tfst\t%s, %s, %d\n" x reg_sp (offset y)
  | NonTail(_), Save(x, y) -> assert (S.mem y !stackset); ()
  (* 復帰の仮想命令の実装 (caml2html: emit_restore) *)
  | NonTail(x), Restore(y) when List.mem x allregs ->
(*      Printf.fprintf oc "\tld\t[%s + %d], %s\n" reg_sp (offset y) x*)
      Printf.fprintf oc "\tld\t%s, %s, %d\n" x reg_sp (offset y)
  | NonTail(x), Restore(y) ->
      assert (List.mem x allfregs);
(*      Printf.fprintf oc "\tldd\t%s, %d, %s\n" reg_sp (offset y) x*)
      Printf.fprintf oc "\tfld\t%s, %s, %d\n" x reg_sp (offset y)
  (* 末尾だったら計算結果を第一レジスタにセットしてret (caml2html: emit_tailret) *)
  | Tail, (Nop | St _ | StDF _ | Comment _ | Save _ as exp) ->
      g' oc (NonTail(Id.gentmp Type.Unit), exp);
      Printf.fprintf oc "\treturn\n"
(*      Printf.fprintf oc "\tretl\n";*)
(*  Printf.fprintf oc "\tnop\n";*)
  | Tail, (Set _ | SetL _ | Mov _ | Neg _ | Add _ | Sub _ | SLL _ | Ld _ as exp) ->
      g' oc (NonTail(regs.(0)), exp);
      Printf.fprintf oc "\treturn\n"
(*      Printf.fprintf oc "\tretl\n";*)
(*  Printf.fprintf oc "\tnop\n";*)
  | Tail, (FMovD _ | FNegD _ | FAddD _ | FSubD _ | FMulD _ | FDivD _ | LdDF _  as exp) ->
      g' oc (NonTail(fregs.(0)), exp);
      Printf.fprintf oc "\treturn\n"
(*      Printf.fprintf oc "\tretl\n";*)
(*      Printf.fprintf oc "\tnop\n"*)
  | Tail, (Restore(x) as exp) ->
      (match locate x with
      | [i] -> g' oc (NonTail(regs.(0)), exp)
      | [i; j] when i + 1 = j -> g' oc (NonTail(fregs.(0)), exp)
      | _ -> assert false);
      Printf.fprintf oc "\treturn\n"
(*      Printf.fprintf oc "\tretl\n";*)
(*      Printf.fprintf oc "\tnop\n"*)

(*
  | Tail, IfEq(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\n" x (pp_id_or_imm y');
      g'_tail_if oc e1 e2 "be" "bne"
  | Tail, IfLE(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\n" x (pp_id_or_imm y');
      g'_tail_if oc e1 e2 "ble" "bg"
  | Tail, IfGE(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\n" x (pp_id_or_imm y');
      g'_tail_if oc e1 e2 "bge" "bl"
  | Tail, IfFEq(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\n" x y;
      Printf.fprintf oc "\tnop\n";
      g'_tail_if oc e1 e2 "fbe" "fbne"
  | Tail, IfFLE(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\n" x y;
      Printf.fprintf oc "\tnop\n";
      g'_tail_if oc e1 e2 "fble" "fbg"
*)

(* 中間言語と逆の意味の命令を出力 *)
  | Tail, IfEq(x, V(y), e1, e2) ->
      g'_tail_if oc x (pp_id_or_imm (V y)) e1 e2 "jeq" "jne"
(* Simm.mlの変更により、これは出ないはず *)
  | Tail, IfEq(x, C(y), e1, e2) ->
      Printf.fprintf oc "! Tail IfEq(即値)。バグってるよ！\n"
      (*g'_tail_if oc x (pp_id_or_imm (C y)) e1 e2 "jeq" "jne" *)
      
  | Tail, IfLE(x, V(y), e1, e2) ->
      g'_tail_if oc (pp_id_or_imm (V y)) x e1 e2 "jle" "jlt"
(* Simm.mlの変更により、これは出ないはず *)
  | Tail, IfLE(x, C(y), e1, e2) ->
      Printf.fprintf oc "! Tail IfLE(即値)。バグってるよ！\n"
      (*g'_tail_if oc (pp_id_or_imm (C y)) x e1 e2 "jle" "jlt"*)
      
  | Tail, IfGE(x, V(y), e1, e2) ->
      g'_tail_if oc x (pp_id_or_imm (V y)) e1 e2 "jge" "jlt"
(* Simm.mlの変更により、これは出ないはず *)
  | Tail, IfGE(x, C(y), e1, e2) ->
      Printf.fprintf oc "! Tail IfGE(即値)。バグってるよ！\n"
      (*g'_tail_if oc x (pp_id_or_imm (C y))  e1 e2 "jge" "jlt" *)
      
(*
  | Tail, IfFEq(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\n" x y;
      Printf.fprintf oc "\tnop\n";
      g'_tail_if oc e1 e2 "fbe" "fbne"
  | Tail, IfFLE(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\n" x y;
      Printf.fprintf oc "\tnop\n";
      g'_tail_if oc e1 e2 "fble" "fbg"
*)
  | Tail, IfFEq(x, y, e1, e2) ->
      g'_tail_if oc x y e2 e1 "fjne" "fjeq"

  | Tail, IfFLE(x, y, e1, e2) ->
      g'_tail_if oc y x e1 e2 "fjge" "fjlt"

(*
  | NonTail(z), IfEq(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\n" x (pp_id_or_imm y');
      g'_non_tail_if oc (NonTail(z)) e1 e2 "be" "bne"
  | NonTail(z), IfLE(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\n" x (pp_id_or_imm y');
      g'_non_tail_if oc (NonTail(z)) e1 e2 "ble" "bg"
  | NonTail(z), IfGE(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\n" x (pp_id_or_imm y');
      g'_non_tail_if oc (NonTail(z)) e1 e2 "bge" "bl"
  | NonTail(z), IfFEq(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\n" x y;
      Printf.fprintf oc "\tnop\n";
      g'_non_tail_if oc (NonTail(z)) e1 e2 "fbe" "fbne"
  | NonTail(z), IfFLE(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\n" x y;
      Printf.fprintf oc "\tnop\n";
      g'_non_tail_if oc (NonTail(z)) e1 e2 "fble" "fbg"
*)  
  | NonTail(z), IfEq(x, V(y), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x (pp_id_or_imm (V y)) e1 e2 "jeq" "jne"
(* Simm.mlの変更により、これは出ないはず *)
  | NonTail(z), IfEq(x, C(y), e1, e2) ->
      Printf.fprintf oc "! NonTail IfEq(即値)。バグってるよ！\n"
      (*g'_non_tail_if oc (NonTail(z)) x (pp_id_or_imm (C y)) e1 e2 "jeq" "jne"*)

  | NonTail(z), IfLE(x, V(y), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) (pp_id_or_imm (V y)) x e1 e2 "jle" "jlt"
(* Simm.mlの変更により、これは出ないはず *)
  | NonTail(z), IfLE(x, C(y), e1, e2) ->
      Printf.fprintf oc "! NonTail IfLE(即値)。バグってるよ！\n"
      (*g'_non_tail_if oc (NonTail(z)) (pp_id_or_imm (C y)) x e1 e2 "jle" "jlt"*)

  | NonTail(z), IfGE(x, V(y), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x (pp_id_or_imm (V y)) e1 e2 "jge" "jlt"
(* Simm.mlの変更により、これは出ないはず *)
  | NonTail(z), IfGE(x, C(y), e1, e2) ->
      Printf.fprintf oc "! NonTail IfGE(即値)。バグってるよ！\n"
      (*g'_non_tail_if oc (NonTail(z)) x (pp_id_or_imm (C y)) e1 e2 "bge" "blt"*)
(*
  | NonTail(z), IfFEq(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\n" x y;
      Printf.fprintf oc "\tnop\n";
      g'_non_tail_if oc (NonTail(z)) e1 e2 "fbe" "fbne"
  | NonTail(z), IfFLE(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\n" x y;
      Printf.fprintf oc "\tnop\n";
      g'_non_tail_if oc (NonTail(z)) e1 e2 "fble" "fbg"
*)    
  | NonTail(z), IfFEq(x, y, e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x y e2 e1 "fjne" "fjeq"
  | NonTail(z), IfFLE(x, y, e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) y x e1 e2 "fjge" "fjlt"

  (* 関数呼び出しの仮想命令の実装 (caml2html: emit_call) *)
(*jmp : 即値でジャンプ先を指定*)
(*b : レジスタでジャンプ先を指定*)
  | Tail, CallCls(x, ys, zs) -> (* 末尾呼び出し (caml2html: emit_tailcall) *)
		g'_args oc [(x, reg_cl)] ys zs;
		Printf.fprintf oc "\tld\t%s, %s, 0\n" reg_sw reg_cl;
		Printf.fprintf oc "\tb\t%s\n" reg_sw		(*指定されたレジスタが指す位置へ飛ぶ *)

  | Tail, CallDir(Id.L(x), ys, zs) -> (* 末尾呼び出し *)
		(match x with
		  	| "min_caml_print_newline" ->
				begin
					g'_args oc [] ys zs;
					Printf.fprintf oc "\tmvhi\t%%g3, 0\n";
					Printf.fprintf oc "\tmvlo\t%%g3, 10\n";
					Printf.fprintf oc "\toutput\t%%g3\n";
					Printf.fprintf oc "\treturn\n"
		  		end
		  	| "min_caml_print_float" ->(* TODO *) 
		  		begin
					g'_args oc [] ys zs;
					let ss = stacksize () in
					Printf.fprintf oc "\tfst\t%%f0, %s, %d\n" reg_sp (ss - 4);
					Printf.fprintf oc "\tst\t%%g3, %s, %d\n" reg_sp (ss);
					Printf.fprintf oc "\tld\t%%g3, %s, %d\n" reg_sp (ss - 4);
					Printf.fprintf oc "\toutput\t%%g3\n";
					Printf.fprintf oc "\tld\t%%g3, %s, %d\n" reg_sp (ss);
					Printf.fprintf oc "\treturn\n"
				end
		  	| "min_caml_print_char"
		  	| "min_caml_write" ->
		  		begin
					g'_args oc [] ys zs;
				  	Printf.fprintf oc "\toutput\t%%g3\n";
					Printf.fprintf oc "\treturn\n"
		  		end
			| "min_caml_input_char"
			| "min_caml_read_char" ->
		  		begin
					g'_args oc [] ys zs;
				  	Printf.fprintf oc "\tinput\t%%g3\n";
					Printf.fprintf oc "\treturn\n"
		  		end
		  	| _ ->
		  		begin
				  g'_args oc [] ys zs;
				  Printf.fprintf oc "\tjmp\t%s\n" x
			(*      Printf.fprintf oc "\tnop\n"*)
				end)
  | NonTail(a), CallCls(x, ys, zs) -> (* レジスタで飛ぶジャンプ *)
		g'_args oc [(x, reg_cl)] ys zs;
		let ss = stacksize () in
		Printf.fprintf oc "\tst\t%s, %s, %d\n" reg_ra reg_sp (ss - 4);
		Printf.fprintf oc "\tld\t%s, %s, 0\n" reg_sw reg_cl;
		Printf.fprintf oc "\tsubi\t%s, %s, %d\n" reg_sp reg_sp ss;
		Printf.fprintf oc "\tcallR\t%s\n" reg_sw;
		Printf.fprintf oc "\taddi\t%s, %s, %d\n" reg_sp reg_sp ss;
		Printf.fprintf oc "\tld\t%s, %s, %d\n" reg_ra reg_sp (ss - 4);
		if List.mem a allregs && a <> regs.(0) then
		Printf.fprintf oc "\tmov\t%s, %s\n" a regs.(0)
		else if List.mem a allfregs && a <> fregs.(0) then
		(Printf.fprintf oc "\tfmov\t%s, %s\n" a fregs.(0))

  | NonTail(a), CallDir(Id.L(x), ys, zs) -> (* ラベルで飛ぶジャンプ *)
	  	(match x with
	  		| "min_caml_sqrt" ->
		  		begin
					g'_args oc [] ys zs;
					Printf.fprintf oc "\tfsqrt\t%%g3, %%g3\n";
					if List.mem a allregs && a <> regs.(0) then
						Printf.fprintf oc "\tmov\t%s, %s\n" a regs.(0)
					else if List.mem a allfregs && a <> fregs.(0) then
						(Printf.fprintf oc "\tfmov\t%s, %s, 0\n" a fregs.(0))
				end
		  	| "min_caml_print_newline" ->
		  		begin
					let ss = stacksize () in
					Printf.fprintf oc "\tst\t%%g3, %s, %d\n" reg_sp (ss);
					Printf.fprintf oc "\tmvhi\t%%g3, 0\n";
					Printf.fprintf oc "\tmvlo\t%%g3, 10\n";
					Printf.fprintf oc "\toutput\t%%g3\n";
					Printf.fprintf oc "\tld\t%%g3, %s, %d\n" reg_sp (ss);
				end
		  	| "min_caml_print_float" ->(* TODO *) 
		  		begin
					g'_args oc [] ys zs;
					let ss = stacksize () in
					Printf.fprintf oc "\tfst\t%%f0, %s, %d\n" reg_sp (ss - 4);
					Printf.fprintf oc "\tst\t%%g3, %s, %d\n" reg_sp (ss);
					Printf.fprintf oc "\tld\t%%g3, %s, %d\n" reg_sp (ss - 4);
					Printf.fprintf oc "\toutput\t%%g3\n";
					Printf.fprintf oc "\tld\t%%g3, %s, %d\n" reg_sp (ss);

					if List.mem a allregs && a <> regs.(0) then
						Printf.fprintf oc "\tmov\t%s, %s\n" a regs.(0)
					else if List.mem a allfregs && a <> fregs.(0) then
						(Printf.fprintf oc "\tfmov\t%s, %s, 0\n" a fregs.(0))
				end
		  	| "min_caml_print_char"
		  	| "min_caml_write" ->
	  		begin
					g'_args oc [] ys zs;
					Printf.fprintf oc "\toutput\t%%g3\n";
					if List.mem a allregs && a <> regs.(0) then
					Printf.fprintf oc "\tmov\t%s, %s\n" a regs.(0)
					else if List.mem a allfregs && a <> fregs.(0) then
					(Printf.fprintf oc "\tfmov\t%s, %s, 0\n" a fregs.(0))
				end
			| "min_caml_input_char"
			| "min_caml_read_char" ->
		  		begin
					g'_args oc [] ys zs;
					Printf.fprintf oc "\tinput\t%%g3\n";
					if List.mem a allregs && a <> regs.(0) then
					Printf.fprintf oc "\tmov\t%s, %s\n" a regs.(0)
					else if List.mem a allfregs && a <> fregs.(0) then
					(Printf.fprintf oc "\tfmov\t%s, %s, 0\n" a fregs.(0))
				end
		  	| _ ->
		  		begin
				  g'_args oc [] ys zs;
				  let ss = stacksize () in
				  Printf.fprintf oc "\tst\t%s, %s, %d\n" reg_ra reg_sp (ss - 4);
				  Printf.fprintf oc "\tsubi\t%s, %s, %d\n" reg_sp reg_sp ss;
				  Printf.fprintf oc "\tcall\t%s\n" x;
				  Printf.fprintf oc "\taddi\t%s, %s, %d\n" reg_sp reg_sp ss;
				  Printf.fprintf oc "\tld\t%s, %s, %d\n" reg_ra reg_sp (ss - 4);
				  if List.mem a allregs && a <> regs.(0) then
			   	  	Printf.fprintf oc "\tmov\t%s, %s\n" a regs.(0)
				  else if List.mem a allfregs && a <> fregs.(0) then
				  (Printf.fprintf oc "\tfmov\t%s, %s, 0\n" a fregs.(0))
				end)
  | _ -> 
		Printf.fprintf oc "unmatched\n"

and g'_tail_if oc x y e1 e2 b bn =
  let b_else = Id.genid (b ^ "_else") in
  Printf.fprintf oc "\t%s\t%s, %s, %s\n" bn x y b_else;
(*  Printf.fprintf oc "\tnop\n";*)
  let stackset_back = !stackset in
  g oc (Tail, e1);
  Printf.fprintf oc "%s:\n" b_else;
  stackset := stackset_back;
  g oc (Tail, e2)
and g'_non_tail_if oc dest x y e1 e2 b bn =
  let b_else = Id.genid (b ^ "_else") in
  let b_cont = Id.genid (b ^ "_cont") in
  Printf.fprintf oc "\t%s\t%s, %s, %s\n" bn x y b_else;
(*  Printf.fprintf oc "\tnop\n";*)
  let stackset_back = !stackset in
  g oc (dest, e1);
  let stackset1 = !stackset in
  Printf.fprintf oc "\tjmp\t%s\n" b_cont;
(*  Printf.fprintf oc "\tnop\n";*)
  Printf.fprintf oc "%s:\n" b_else;
  stackset := stackset_back;
  g oc (dest, e2);
  Printf.fprintf oc "%s:\n" b_cont;
  let stackset2 = !stackset in
  stackset := S.inter stackset1 stackset2

and g'_args oc x_reg_cl ys zs =
  let (i, yrs) =
    List.fold_left
      (fun (i, yrs) y -> (i + 1, (y, regs.(i)) :: yrs))
      (0, x_reg_cl)
      ys in
  List.iter
    (fun (y, r) -> Printf.fprintf oc "\tmov\t%s, %s\n" r y)
    (shuffle reg_sw yrs);
  let (d, zfrs) =
    List.fold_left
      (fun (d, zfrs) z -> (d + 1, (z, fregs.(d)) :: zfrs))
      (0, [])
      zs in
  List.iter
    (fun (z, fr) ->
      Printf.fprintf oc "\tfmov\t%s, %s\n" fr z)
(*      Printf.fprintf oc "\tfmovs\t%s, %s\n" z fr;
      Printf.fprintf oc "\tfmovs\t%s, %s\n" (co_freg z) (co_freg fr))
*)    (shuffle reg_fsw zfrs)

let h oc { name = Id.L(x); args = _; fargs = _; body = e; ret = _ } =
  Printf.fprintf oc "%s:\n" x;
  stackset := S.empty;
  stackmap := [];
  g oc (Tail, e)

let f oc (Prog(data, fundefs, e)) =
  Format.eprintf "generating assembly...@.";
(*  Printf.fprintf oc ".section\t\".rodata\"\n";
  Printf.fprintf oc ".align\t8\n";*)
  let len = List.length data in
  Printf.fprintf oc ".init_heap_size\t%d\n" (32 * len);
  List.iter
    (*TODO:fun (Id.L(x), d) ->
      Printf.fprintf oc "%s:\t! %f\n" x d;
      Printf.fprintf oc "\t.long\t0x%lx\n" (gethi d);
      Printf.fprintf oc "\t.long\t0x%lx\n" (getlo d)*)
    (fun (Id.L(x), f) ->
      Printf.fprintf oc "%s:\t! %f\n" x f;
      (* 浮動小数点fをIEEE756のビット列に変換 *)
      let hi = Int32.to_int (gethi f) in
      let lo = Int32.to_int (getlo f) in
      let s = lo lsr 31 in
      let exp = (lo lsr 20) mod (1 lsl 12) in
      let frac = lo mod (1 lsl 20) in
      if exp = 0 && frac = 0 then
      	Printf.fprintf oc "\t.long\t0x%lx\n" (Int32.of_int (s lsl 31))
	  else  
		begin
		  let exp = exp - (if s > 0 && frac <> 0 then 895 else 896) in (* 負の数だと1ずれる？ *)
		  let frac = frac lsl 3 in
		  let frac = frac + (hi lsr 29) in
		  let b = (s lsl 31) + (exp lsl 23) + frac in
		  Printf.fprintf oc "\t.long\t0x%lx\n" (Int32.of_int b)
		end)
    data;
  (*Printf.fprintf oc ".section\t\".text\"\n";*)
  Printf.fprintf oc "\tjmp\tmin_caml_start\n";
  define_library oc;
  List.iter (fun fundef -> h oc fundef) fundefs;
(*  Printf.fprintf oc ".global\tmin_caml_start\n";*)
  Printf.fprintf oc "min_caml_start:\n";
(*  Printf.fprintf oc "\tsave\t%%sp, -112, %%sp\n"; (* from gcc; why 112? *)*)
  stackset := S.empty;
  stackmap := [];
  g oc (NonTail("%g0"), e);
  Printf.fprintf oc "\thalt\n";
    
(*  Printf.fprintf oc "\tret\n";
  Printf.fprintf oc "\trestore\n"*)
  
  
