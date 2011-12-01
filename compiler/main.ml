let limit = ref 1000
let print_flg = ref false

(*  [Movelet.f; ConstArg.f; ConstFold.f; Cse.f; ConstArray.f; Inline.f; Assoc.f; BetaTuple.f; Beta.f] *)
let rec iter n e = (* ��Ŭ�������򤯤꤫���� (caml2html: main_iter) *)
  Format.eprintf "iteration %d@." n;
  if n = 0 then e else
  let e' =
	(*Movelet.f !print_flg*)Elim.f (  (* Movelet�ϥХ��äƤ롣�׽���(���؎� *)
		(*ConstArg.f !print_flg*) ( (* let ar = create_array 1 f���ߤ����ʤΤ��б��Ǥ��Ƥʤ� *)
			ConstFold.f(
				Cse.f !print_flg (
					ConstArray.f !print_flg (
						Inline.f (
							Assoc.f (
								BetaTuple.f !print_flg (
									Beta.f e
								)
							)
						)
					)
				)
			)
		)
	) in
  if e = e' then e else
  iter (n - 1) e'

let lexbuf outchan l = (* �Хåե��򥳥�ѥ��뤷�ƥ����ͥ�ؽ��Ϥ��� (caml2html: main_lexbuf) *)
	Id.counter := 0;
	Typing.extenv := M.empty;
	let simm = 
		Simm.f
			(Sglobal.f
				(Virtual.f !print_flg
					(Closure.f !print_flg
						(GlobalEnv.f (* �����Х��ѿ������ *)
							(iter !limit
								(Alpha.f !print_flg
									(KNormal.f !print_flg
										(Typing.f
											(Parser.exp Lexer.token l))))))))) in
	if !Closure.exist_cls then
		(print_endline "Not Coloring";
		(* RegAlloc3�ϥ������㤬���줿�Ȥ��˥Х���Τ�RegAlloc������ *)
		Emit.f outchan 	(RegAlloc.f simm))
	else
		(print_endline "Coloring";
		let toasm = ToAsm.f (Coloring.f (Block.f simm)) in
		Printf.printf "asm -> block -> asm %s\n" (string_of_bool (simm = toasm));
		Emit.f outchan 	(RegAllocWithColoring.f toasm))

let string s = lexbuf stdout (Lexing.from_string s) (* ʸ����򥳥�ѥ��뤷��ɸ����Ϥ�ɽ������ (caml2html: main_string) *)

let file f = (* �ե�����򥳥�ѥ��뤷�ƥե�����˽��Ϥ��� (caml2html: main_file) *)
  let inchan = open_in (f ^ ".ml") in
  let outchan = open_out (f ^ ".s") in
  try
    lexbuf outchan (Lexing.from_channel inchan);
    close_in inchan;
    close_out outchan;
  with e -> (close_in inchan; close_out outchan; raise e)

let () = (* �������饳��ѥ���μ¹Ԥ����Ϥ���� (caml2html: main_entry) *)
  let files = ref [] in
  Arg.parse
    [("-inline", Arg.Int(fun i -> Inline.threshold := i), "maximum size of functions inlined");
     ("-iter", Arg.Int(fun i -> limit := i), "maximum number of optimizations iterated");
     ("-p", Arg.Unit(fun () -> print_flg := true), "print infomations for debug or not")]
    (fun s -> files := !files @ [s])
    ("Mitou Min-Caml Compiler (C) Eijiro Sumii\n" ^
     Printf.sprintf "usage: %s [-inline m] [-iter n] ...filenames without \".ml\"..." Sys.argv.(0));
  List.iter
    (fun f -> ignore (file f))
    !files
