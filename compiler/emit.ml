open Asm

external gethi : float -> int32 = "gethi"
external getlo : float -> int32 = "getlo"

let global_vars = ref M.empty
let global_flg = ref true
(* 現在見ている関数の名前 *)
let current_fun = ref ""
(* 各関数がスタックに変数を積みうるか。絶対に積まないなら、その変数を呼ぶときスタックを上下させる必要はない *)
let save_env = ref M.empty
let add_save_env () = save_env := M.add !current_fun true !save_env
let find_save_env x = true(*if M.mem x !save_env then M.find x !save_env else true*)

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
let locate x =
  let rec loc = function
    | [] -> []
    | y :: zs when x = y -> 0 :: List.map succ (loc zs)
    | y :: zs -> List.map succ (loc zs) in
  loc !stackmap
let offset x = 
	let loc = locate x in
	if List.length loc <= 0 then (Printf.eprintf "OFFSET x = %s\n" x; assert false) else 4 * List.hd loc
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

(* NonTailの引数は演算結果の代入先 *)
type dest = Tail | NonTail of Id.t (* 末尾かどうかを表すデータ型 (caml2html: emit_dest) *)
let rec g oc = function (* 命令列のアセンブリ生成 (caml2html: emit_g) *)
  | dest, Ans(exp) -> g' oc (dest, exp)
  | dest, Let((x, t), exp, e) ->
      g' oc (NonTail(x), exp);
      g oc (dest, e)
  | dest, Forget(_, _) -> assert false
and g' oc = function (* 各命令のアセンブリ生成 (caml2html: emit_gprime) *)
  (* 末尾でなかったら計算結果をdestにセット (caml2html: emit_nontail) *)
  | NonTail(_), Nop -> ()

(* %r0は常に0 *)
  | NonTail(x), Set(i) -> 
	if i <= -32768 || 32768 < i then begin
	  	Output.add_stmt (Output.Mvhi (x, (i lsr 16) mod (1 lsl 16)));
	  	Output.add_stmt (Output.Mvlo (x, (i mod (1 lsl 16))))
  	end else (* 16ビットで収まるならaddi命令にする *)
	 	Output.add_stmt (Output.Addi (x, reg_0, i))
  | NonTail(x), SetL(Id.L(y)) ->
  	Output.add_stmt (Output.SetL (x, y))

  | NonTail(x), Mov(y) when x = y -> ()
  | NonTail(x), Mov(y) -> Output.add_stmt (Output.Mov (x, y))
  | NonTail(x), Neg(y) -> Output.add_stmt (Output.Sub (x, reg_0, y))
  | NonTail(x), Add(y, V(z)) -> Output.add_stmt (Output.Add (x, y, z))
  | NonTail(x), Add(y, C(z)) -> Output.add_stmt (Output.Addi (x, y, z))
  | NonTail(x), Sub(y, V(z)) -> Output.add_stmt (Output.Sub (x, y, z))
  | NonTail(x), Sub(y, C(z)) -> Output.add_stmt (Output.Subi (x, y, z))
  | NonTail(x), Mul(y, V(z)) -> Output.add_stmt (Output.Mul (x, y, z))
  | NonTail(x), Mul(y, C(z)) -> Output.add_stmt (Output.Muli (x, y, z))
  | NonTail(x), Div(y, V(z)) -> Output.add_stmt (Output.Div (x, y, z))
  | NonTail(x), Div(y, C(z)) -> Output.add_stmt (Output.Divi (x, y, z))
  | NonTail(x), SLL(y, V(z)) -> Output.add_stmt (Output.SLL (x, y, z))
  | NonTail(x), SLL(y, C(z)) when z >= 0 -> Output.add_stmt (Output.SLLi (x, y, z))
  | NonTail(x), SLL(y, C(z)) -> Output.add_stmt (Output.SRLi (x, y, -z))
  | NonTail(x), Ld(y, V z) -> Output.add_stmt (Output.Ld (x, y, z))
  | NonTail(x), Ld(y, C z) -> Output.add_stmt (Output.Ldi (x, y, z))
  | NonTail(_), St(x, y, V z) -> Output.add_stmt (Output.St (x, y, z))
  | NonTail(_), St(x, y, C z) -> Output.add_stmt (Output.Sti (x, y, z))
  | NonTail(x), FMovD(y) when x = y -> ()
  | NonTail(x), FMovD(y) -> Output.add_stmt (Output.FMov (x, y))
  | NonTail(x), FNegD(y) -> Output.add_stmt (Output.FNeg (x, y))

  | NonTail(x), FAddD(y, z) -> Output.add_stmt (Output.FAdd (x, y, z))
  | NonTail(x), FSubD(y, z) -> Output.add_stmt (Output.FSub (x, y, z))
  | NonTail(x), FMulD(y, z) -> Output.add_stmt (Output.FMul (x, y, z))
  | NonTail(x), FDivD(y, z) ->
  	begin
		if z = "%f0" then
			Output.add_stmt (Output.FDiv (x, y, z))
		else begin
			let ss = stacksize() in
			(if x <> "%f1" then
				Output.add_stmt (Output.StFi ("%f1", reg_sp, ss));
			);
			(if x <> "%f0" then
				Output.add_stmt (Output.StFi ("%f0", reg_sp, ss + 4));
			);
			Output.add_stmt (Output.FMov (reg_fsw, z));
			Output.add_stmt (Output.FMov ("%f1", y));
			Output.add_stmt (Output.FMov ("%f0", reg_fsw));
			Output.add_stmt (Output.FDiv (x, "%f1", "%f0"));
			(if x <> "%f0" then
				Output.add_stmt (Output.LdFi ("%f0", reg_sp, ss + 4))
			);
			(if x <> "%f1" then
				Output.add_stmt (Output.LdFi ("%f1", reg_sp, ss))
			)
		end
  	end
  | NonTail(x), LdDF(y, V(z)) -> Output.add_stmt (Output.LdF (x, y, z))
  | NonTail(x), LdDF(y, C(z)) -> Output.add_stmt (Output.LdFi (x, y, z))
  | NonTail(_), StDF(x, y, V(z)) -> Output.add_stmt (Output.StF (x, y, z))
  | NonTail(_), StDF(x, y, C(z)) -> Output.add_stmt (Output.StFi (x, y, z))
  
  | NonTail(_), Comment(s) -> Output.add_stmt (Output.Comment (Printf.sprintf "\t! %s\n" s))
  (* 退避の仮想命令の実装 (caml2html: emit_save) *)
  | NonTail(_), Save(x, y) when List.mem x allregs && not (S.mem y !stackset) ->
		save y;
		let offset = offset y in
		Output.add_stmt (Output.Sti (x, reg_sp, offset));
		add_save_env ()
  | NonTail(_), Save(x, y) when List.mem x allfregs && not (S.mem y !stackset) ->
		savef y;
		let offset = offset y in
		Output.add_stmt (Output.StFi (x, reg_sp, offset));
		add_save_env ()
  | NonTail(_), Save(x, y) -> (* %f16とか値が固定されているレジスタは意地でも退避しない *)
  	if S.mem y !stackset || M.mem y !global_vars || Asm.is_reg x then () else (
	  	Printf.eprintf "has saved (%s,%s)\n" x y;
	  	S.iter (Printf.eprintf "%s ") !stackset;
	  	Printf.eprintf "\n";
	  	assert false (* すでにyがセーブされている場合 *)
	)
  (* 復帰の仮想命令の実装 (caml2html: emit_restore) *)
  | NonTail(x), Restore(y) when List.mem x allregs -> Output.add_stmt (Output.Ldi (x, reg_sp, (offset y))); add_save_env ()
  | NonTail(x), Restore(y) when List.mem x allfregs -> Output.add_stmt (Output.LdFi (x, reg_sp, (offset y))); add_save_env ()
  | NonTail(x), Restore(y) ->(* %f16とか値が固定されているレジスタは復帰しない（そもそも退避されてない） *)
  	  assert (Asm.is_reg x); ()
      
  (* 末尾だったら計算結果を第一レジスタにセットしてret (caml2html: emit_tailret) *)
  | Tail, (Nop | St _ | StDF _ | Comment _ | Save _ as exp) ->
      g' oc (NonTail(Id.gentmp Type.Unit), exp);
      Output.add_stmt Output.Return
  | Tail, (Set _ | SetL _ | Mov _ | Neg _ | Add _ | Sub _ | SLL _ | Ld _ as exp) ->
      g' oc (NonTail(regs.(0)), exp);
      Output.add_stmt Output.Return
  | Tail, (FMovD _ | FNegD _ | FAddD _ | FSubD _ | FMulD _ | FDivD _ | LdDF _  as exp) ->
      g' oc (NonTail(fregs.(0)), exp);
      Output.add_stmt Output.Return
  | Tail, (Restore(x) as exp) ->
      (match locate x with
      | [i] -> g' oc (NonTail(regs.(0)), exp)
      | [i; j] when i + 1 = j -> g' oc (NonTail(fregs.(0)), exp)
      | _ -> assert false);
      Output.add_stmt Output.Return

(* 中間言語と逆の意味の命令を出力 *)
  | Tail, IfEq(x, V(y), e1, e2) ->
      g'_tail_if oc x (pp_id_or_imm (V y)) e1 e2 "jeq" "jne"
  | Tail, IfEq(x, C(0), e1, e2) ->
	  g'_tail_if oc x reg_0 e1 e2 "jeq" "jne"
  | Tail, IfEq(x, C(1), e1, e2) ->
	  g'_tail_if oc x reg_p1 e1 e2 "jeq" "jne"
  | Tail, IfEq(x, C(-1), e1, e2) ->
	  g'_tail_if oc x reg_m1 e1 e2 "jeq" "jne"
  | Tail, IfEq(x, C(y), e1, e2) ->
      (Printf.eprintf "! Tail IfEq(即値)。バグってるよ！\n"; assert false)
      
  | Tail, IfLE(x, V(y), e1, e2) ->
      g'_tail_if oc (pp_id_or_imm (V y)) x e1 e2 "jle" "jlt"
  | Tail, IfLE(x, C(0), e1, e2) ->
	  g'_tail_if oc reg_0 x e1 e2 "jle" "jlt"
  | Tail, IfLE(x, C(1), e1, e2) ->
	  g'_tail_if oc reg_p1 x e1 e2 "jle" "jlt"
  | Tail, IfLE(x, C(-1), e1, e2) ->
	  g'_tail_if oc reg_m1 x e1 e2 "jle" "jlt"
  | Tail, IfLE(x, C(y), e1, e2) ->
      (Printf.eprintf "! Tail IfLE(即値)。バグってるよ！\n"; assert false)
      
  | Tail, IfGE(x, V(y), e1, e2) ->
      g'_tail_if oc x (pp_id_or_imm (V y)) e1 e2 "jge" "jlt"
  | Tail, IfGE(x, C(0), e1, e2) ->
	  g'_tail_if oc x reg_0 e1 e2 "jge" "jlt"
  | Tail, IfGE(x, C(1), e1, e2) ->
	  g'_tail_if oc x reg_p1 e1 e2 "jge" "jlt"
  | Tail, IfGE(x, C(-1), e1, e2) ->
	  g'_tail_if oc x reg_m1 e1 e2 "jge" "jlt"
  | Tail, IfGE(x, C(y), e1, e2) ->
      (Printf.eprintf "! Tail IfGE(即値)。バグってるよ！\n"; assert false)

  | Tail, IfFEq(x, y, e1, e2) ->
      g'_tail_if oc x y e2 e1 "fjne" "fjeq"

  | Tail, IfFLE(x, y, e1, e2) ->
      g'_tail_if oc y x e1 e2 "fjge" "fjlt"

  | NonTail(z), IfEq(x, V(y), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x (pp_id_or_imm (V y)) e1 e2 "jeq" "jne"
  | NonTail(z), IfEq(x, C(0), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x reg_0 e1 e2 "jeq" "jne"
  | NonTail(z), IfEq(x, C(1), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x reg_p1 e1 e2 "jeq" "jne"
  | NonTail(z), IfEq(x, C(-1), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x reg_m1 e1 e2 "jeq" "jne"
  | NonTail(z), IfEq(x, C(y), e1, e2) ->
      (Printf.eprintf "! NonTail IfEq(即値)。バグってるよ！\n"; assert false)

  | NonTail(z), IfLE(x, V(y), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) (pp_id_or_imm (V y)) x e1 e2 "jle" "jlt"
  | NonTail(z), IfLE(x, C(0), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) reg_0 x e1 e2 "jle" "jlt"
  | NonTail(z), IfLE(x, C(1), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) reg_p1 x e1 e2 "jle" "jlt"
  | NonTail(z), IfLE(x, C(-1), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) reg_m1 x e1 e2 "jle" "jlt"
  | NonTail(z), IfLE(x, C(y), e1, e2) ->
      (Printf.eprintf "! NonTail IfLE(即値)。バグってるよ！\n"; assert false)

  | NonTail(z), IfGE(x, V(y), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x (pp_id_or_imm (V y)) e1 e2 "jge" "jlt"
  | NonTail(z), IfGE(x, C(0), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x reg_0 e1 e2 "jge" "jlt"
  | NonTail(z), IfGE(x, C(1), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x reg_p1 e1 e2 "jge" "jlt"
  | NonTail(z), IfGE(x, C(-1), e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x reg_m1 e1 e2 "jge" "jlt"
  | NonTail(z), IfGE(x, C(y), e1, e2) ->
      (Printf.eprintf "! NonTail IfGE(即値)。バグってるよ！\n"; assert false)

  | NonTail(z), IfFEq(x, y, e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) x y e2 e1 "fjne" "fjeq"
  | NonTail(z), IfFLE(x, y, e1, e2) ->
      g'_non_tail_if oc (NonTail(z)) y x e1 e2 "fjge" "fjlt"

  (* 関数呼び出しの仮想命令の実装 (caml2html: emit_call) *)
(*jmp : 即値でジャンプ先を指定*)
(*b : レジスタでジャンプ先を指定*)
  | Tail, CallCls(x, ys, zs) -> (* 末尾呼び出し (caml2html: emit_tailcall) *)
		g'_args oc x [(x, reg_cl)] ys zs;
		Output.add_stmt (Output.Ldi (reg_sw, reg_cl, 0));
		Output.add_stmt (Output.B reg_sw)		(*指定されたレジスタが指す位置へ飛ぶ *)
  | Tail, CallDir(Id.L(x), ys, zs) -> (* 末尾呼び出し *)
		(match x with
	  		| "min_caml_fabs" | "min_caml_abs_float" ->
		  		begin
					Output.add_stmt (Output.FAbs ("%f0", if List.length zs  <= 0 then assert false else List.hd zs));
					Output.add_stmt Output.Return
				end
	  		| "min_caml_fdiv" ->
				begin
					Printf.printf "hello\n";
					flush(stdout);
					Output.add_stmt (Output.FDiv ("%f0", List.nth zs 0, List.nth zs 1));
					Output.add_stmt Output.Return
				end
			| "min_caml_sqrt" ->
		  		begin
					Output.add_stmt (Output.FSqrt ("%f0", if List.length zs  <= 0 then assert false else List.hd zs));
					Output.add_stmt Output.Return
				end
		  	| "min_caml_print_newline" ->
				begin
					g'_args oc x [] ys zs;
					Output.add_stmt (Output.Addi ("%g3", "%g0", 10));
					Output.add_stmt (Output.Output "%g3");
					Output.add_stmt Output.Return
		  		end
		  	| "min_caml_print_float" ->(* TODO *) 
		  		begin
					g'_args oc x [] ys zs;
					let ss = stacksize () in
					Output.add_stmt (Output.StFi ("%f0", reg_sp, ss - 4));
					Output.add_stmt (Output.Sti ("%g3", reg_sp, ss));
					Output.add_stmt (Output.Ldi ("%g3", reg_sp, ss - 4));
					Output.add_stmt (Output.Output "%g3");
					Output.add_stmt (Output.Ldi ("%g3", reg_sp, ss));
					Output.add_stmt Output.Return;
					add_save_env ()
				end
		  	| "min_caml_print_char"
		  	| "min_caml_write" ->
		  		begin
					Output.add_stmt (Output.Output (if List.length ys <= 0 then assert false else List.hd ys));
					Output.add_stmt Output.Return
		  		end
			| "min_caml_print_int" when !Global.use_binary_data ->
				begin
					Output.add_stmt (Output.OutputW (if List.length ys <= 0 then assert false else List.hd ys));
					Output.add_stmt Output.Return
				end
			| "min_caml_print_float" when !Global.use_binary_data -> 
				begin
					Output.add_stmt (Output.OutputF (if List.length zs <= 0 then assert false else List.hd zs));
					Output.add_stmt Output.Return
				end
			| "min_caml_input_char"
			| "min_caml_read_char" ->
		  		begin
					Output.add_stmt (Output.Input "%g3");
					Output.add_stmt Output.Return
		  		end
(*		 	| "min_caml_read_int" when !Global.use_binary_data ->
				begin
					Output.add_stmt (Output.InputW "%g3");
					Output.add_stmt Output.Return
				end
			| "min_caml_read_float"  when !Global.use_binary_data ->
				begin
					Output.add_stmt (Output.InputF "%f0");
					Output.add_stmt Output.Return
				end
*)		 	| _ ->
		  		begin
				  g'_args oc x [] ys zs;
				  Output.add_stmt (Output.Jmp x);
				  add_save_env ()
				end)
  | NonTail(a), CallCls(x, ys, zs) -> (* レジスタで飛ぶジャンプ *)
		g'_args oc x [(x, reg_cl)] ys zs;
		let ss = stacksize () in
		Output.add_stmt (Output.Ldi (reg_sw, reg_cl, 0));
		Output.add_stmt (Output.Subi (reg_sp, reg_sp, ss));
		Output.add_stmt (Output.CallR reg_sw);
		Output.add_stmt (Output.Addi (reg_sp, reg_sp, ss));
		(if List.mem a allregs && a <> regs.(0) then
			Output.add_stmt (Output.Mov (a, regs.(0)))
		else if List.mem a allfregs && a <> fregs.(0) then
			Output.add_stmt (Output.FMov (a, fregs.(0)))
		else ());
		add_save_env ()

  | NonTail(a), CallDir(Id.L(x), ys, zs) -> (* ラベルで飛ぶジャンプ *)
	  	(match x with
	  		| "min_caml_fabs" | "min_caml_abs_float" ->
		  		begin
					Output.add_stmt (Output.FAbs (a, if List.length zs <= 0 then assert false else List.hd zs));
				end
	  		| "min_caml_fdiv" ->
				begin
					Printf.printf "hello2\n";
					flush(stdout);
					Output.add_stmt (Output.FDiv (a, List.nth zs 0, List.nth zs 1))
				end
	  		| "min_caml_sqrt" ->
		  		begin
					Output.add_stmt (Output.FSqrt (a, if List.length zs <= 0 then assert false else List.hd zs));
				end
		  	| "min_caml_print_newline" ->
		  		begin
					let ss = stacksize () in
					Output.add_stmt (Output.Sti ("%g3", reg_sp, ss));
					Output.add_stmt (Output.Addi ("%g3", reg_0, 10));
					Output.add_stmt (Output.Output "%g3");
					Output.add_stmt (Output.Ldi ("%g3", reg_sp, ss));
					add_save_env ()
				end
		  	| "min_caml_print_float" ->(* TODO *) 
		  		begin
					g'_args oc x [] ys zs;
					let ss = stacksize () in
					Output.add_stmt (Output.StFi ("%f0", reg_sp, ss - 4));
					Output.add_stmt (Output.Sti ("%g3", reg_sp, ss));
					Output.add_stmt (Output.Ldi ("%g3", reg_sp, ss - 4));
					Output.add_stmt (Output.Output "%g3");
					Output.add_stmt (Output.Ldi ("%g3", reg_sp, ss));
					add_save_env ()
				end
		  	| "min_caml_print_char"
		  	| "min_caml_write" ->
		  		begin
				  	Output.add_stmt (Output.Output (if List.length ys <= 0 then assert false else List.hd ys))
				end
			| "min_caml_print_int" when !Global.use_binary_data ->
				begin
					Output.add_stmt (Output.OutputW (if List.length ys <= 0 then assert false else List.hd ys))
				end
			| "min_caml_print_float" when !Global.use_binary_data -> 
				begin
					Output.add_stmt (Output.OutputF (if List.length zs <= 0 then assert false else List.hd zs))
				end
			| "min_caml_input_char"
			| "min_caml_read_char" ->
		  		begin
				 	Output.add_stmt (Output.Input a)
				end
(*			| "min_caml_read_int" when !Global.use_binary_data ->
				begin
					Output.add_stmt (Output.InputW a)
				end
			| "min_caml_read_float"  when !Global.use_binary_data ->
				begin
					Output.add_stmt (Output.InputF a)
				end
*)			| _ ->
				begin
				g'_args oc x [] ys zs;
				let ss = stacksize () in
				(if find_save_env x then
					Output.add_stmt (Output.Subi (reg_sp, reg_sp, ss))
				);
				Output.add_stmt (Output.Call x);
				(if find_save_env x then (
					Output.add_stmt (Output.Addi (reg_sp, reg_sp, ss)); 
					add_save_env ())
				);
				if List.mem a allregs && a <> regs.(0) then
					Output.add_stmt (Output.Mov (a, regs.(0)))
				else if List.mem a allfregs && a <> fregs.(0) then
					Output.add_stmt (Output.FMov (a, fregs.(0)))
				end)
  | _ -> Printf.eprintf "unmatched\n"; assert false

and g'_tail_if oc x y e1 e2 b bn =
  let b_else = Id.genid (b ^ "_else") in
  Output.add_stmt (Output.JCmp (bn, x, y, b_else));
  let stackset_back = !stackset in
  g oc (Tail, e1);
  Output.add_stmt (Output.Label b_else);
  stackset := stackset_back;
  g oc (Tail, e2)
and g'_non_tail_if oc dest x y e1 e2 b bn =
  let b_else = Id.genid (b ^ "_else") in
  let b_cont = Id.genid (b ^ "_cont") in
  Output.add_stmt (Output.JCmp (bn, x, y, b_else));
  let stackset_back = !stackset in
  g oc (dest, e1);
  let stackset1 = !stackset in
  Output.add_stmt (Output.Jmp b_cont);
  Output.add_stmt (Output.Label b_else);
  stackset := stackset_back;
  g oc (dest, e2);
  Output.add_stmt (Output.Label b_cont);
  let stackset2 = !stackset in
  stackset := S.inter stackset1 stackset2

and g'_args oc name x_reg_cl ys zs =
  let (regs, fregs) =
  	try 
		let data = M.find name !fundata in
		let arg_regs = data.arg_regs in
		let (reg_ls, freg_ls) = List.partition (fun x -> List.mem x Asm.allregs) arg_regs in
		(Array.of_list reg_ls, Array.of_list freg_ls)
	with
  		| Not_found -> print_endline ("not found args: " ^ name); (Asm.regs, Asm.fregs) in

  let (i, yrs) =
    List.fold_left
      (fun (i, yrs) y -> (i + 1, (y, regs.(i)) :: yrs))
      (0, x_reg_cl)
      ys in
  List.iter
    (fun (y, r) -> Output.add_stmt (Output.Mov (r, y)))
    (shuffle reg_sw yrs);
  let (d, zfrs) =
    List.fold_left
      (fun (d, zfrs) z -> (d + 1, (z, fregs.(d)) :: zfrs))
      (0, [])
      zs in
  List.iter
    (fun (z, fr) ->
      Output.add_stmt (Output.FMov (fr, z)))
      (shuffle reg_fsw zfrs)


let print_list ls = 
	let rec print_list = function
		| [] -> ""
		| x :: [] -> x
		| x :: xs -> x ^ ", " ^ (print_list xs) in
	"[" ^ (print_list ls) ^ "]"

let h oc { name = Id.L(x); args = args; fargs = fargs; body = e; ret = ret } =
	current_fun := x;
	save_env := M.add x false !save_env;
	Output.add_stmt (Output.Comment (Printf.sprintf "\n!=============================="));
	Output.add_stmt (Output.Comment (Printf.sprintf "! args = %s" (print_list args)));
	Output.add_stmt (Output.Comment (Printf.sprintf "! fargs = %s" (print_list fargs)));
	Output.add_stmt (Output.Comment (Printf.sprintf "! use_regs = %s" (print_list (S.fold (fun x env -> x :: env) (Asm.get_use_regs x) []))));
	Output.add_stmt (Output.Comment (Printf.sprintf "! ret type = %s" (Type.string_of_type ret)));
	Output.add_stmt (Output.Comment (Printf.sprintf "!================================"));
	Output.add_stmt (Output.Label x);
	(*  Printf.printf "%s\n" x; flush stdout;*)
	stackset := S.empty;
	stackmap := [];
	g oc (Tail, e)

let f oc (Prog(data, fundefs, e)) =
  Format.eprintf "generating assembly...@.";
  let len = List.length data in
  
  Output.add_stmt (Output.Comment (Printf.sprintf ".init_heap_size\t%d" (32 * len)));
  List.iter
    (fun (Id.L(x), f) ->
      (* 浮動小数点fをIEEE756のビット列に変換 *)
      let hi = Int32.to_int (gethi f) in
      let lo = Int32.to_int (getlo f) in
      let s = lo lsr 31 in
      let exp = (lo lsr 20) mod (1 lsl 12) in
      let frac = lo mod (1 lsl 20) in
      if exp = 0 && frac = 0 then
      	Output.add_stmt (Output.Data (x, f, Int32.of_int (s lsl 31)))
	  else  
		begin
			let exp = exp - (if s > 0 && frac <> 0 then 895 else 896) in (* 負の数だと1ずれる？ *)
			let frac = frac lsl 3 in
			let frac = frac + (hi lsr 29) in
			let b = (s lsl 31) + (exp lsl 23) + frac in
			Output.add_stmt (Output.Data (x, f, Int32.of_int b))
		end)
    data;

  Output.add_stmt (Output.Jmp "min_caml_start");
  Output.add_stmt (Output.Label "min_caml_start");
  stackset := S.empty;
  stackmap := [];

  (* %g31はスタックの底を指す *)
  Output.add_stmt (Output.Mov (reg_bottom, reg_sp));
  Output.add_stmt (Output.Subi (reg_sp, reg_sp, (!GlobalEnv.offset + 8)));

  (* reg_p1, reg_m1の初期化 *)
  Output.add_stmt (Output.Addi (reg_p1, reg_0, 1));
  Output.add_stmt (Output.Addi (reg_m1, reg_0, (-1)));
  g oc (NonTail("%g0"), e);
  Output.add_stmt Output.Halt;

  global_flg := false;

  List.iter (fun fundef -> h oc fundef) fundefs;

  M.iter (Printf.eprintf "GLOBAL : %s %d\n") !global_vars;
  
(*  Output.optimize ();*)
  Output.output oc
