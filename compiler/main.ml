let limit = ref 1000
let print_flg = ref false

let rec iter n e = (* ��Ŭ�������򤯤꤫���� (caml2html: main_iter) *)
  Format.eprintf "iteration %d@." n;
  if n = 0 then e else
  let e' = Movelet.f !print_flg (Cse.f !print_flg (ConstFold.f (Inline.f (Assoc.f (Beta.f e))))) in
  if e = e' then e else
  iter (n - 1) e'

let lexbuf outchan l = (* �Хåե��򥳥�ѥ��뤷�ƥ����ͥ�ؽ��Ϥ��� (caml2html: main_lexbuf) *)
	Id.counter := 0;
	Typing.extenv := M.empty;
	Emit.f outchan
		(RegAlloc.f
			(Simm.f
				((*ConstFold2.f !print_flg*)
					(Virtual.f !print_flg
						(Closure.f !print_flg
							(iter !limit
								(Alpha.f !print_flg
									(KNormal.f !print_flg
										(Typing.f
											(Parser.exp Lexer.token l))))))))))

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
