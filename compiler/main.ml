let limit = ref 1000

let rec iter n e = (* 最適化処理をくりかえす (caml2html: main_iter) *)
  Format.eprintf "iteration %d@." n;
  if n = 0 then e else
  let e' = Elim.f (ConstFold.f (Inline.f (Assoc.f (Beta.f e)))) in
  if e = e' then e else
  iter (n - 1) e'

let lexbuf outchan file l = (* バッファをコンパイルしてチャンネルへ出力する (caml2html: main_lexbuf) *)
  Id.counter := 0;
(*  
  let extlist = [
  	"sin", (Type.Fun ([Type.Float], Type.Float));
  	"cos", (Type.Fun ([Type.Float], Type.Float));

  	"int_of_float", (Type.Fun ([Type.Float], Type.Int));
  	"float_of_int", (Type.Fun ([Type.Int], Type.Float));

  	"fequal", (Type.Fun ([Type.Float; Type.Float], Type.Bool));
  	"fless", (Type.Fun ([Type.Float; Type.Float], Type.Bool));

  	"fispos", (Type.Fun ([Type.Float], Type.Bool));
  	"fisneg", (Type.Fun ([Type.Float], Type.Bool));
  	"fiszero", (Type.Fun ([Type.Float], Type.Bool));

  	"xor", (Type.Fun ([Type.Bool; Type.Bool], Type.Bool));

  	"abs_float", (Type.Fun ([Type.Float], Type.Float));
  	"fabs", (Type.Fun ([Type.Float], Type.Float));
  	"fneg", (Type.Fun ([Type.Float], Type.Float));
  	"fsqr", (Type.Fun ([Type.Float], Type.Float));
  	"sqrt", (Type.Fun ([Type.Float], Type.Float));
  	"fhalf", (Type.Fun ([Type.Float], Type.Float));
  	"floor", (Type.Fun ([Type.Float], Type.Float));

  	"read_float", (Type.Fun ([Type.Unit], Type.Float));
  	"read_int", (Type.Fun ([Type.Unit], Type.Int));
	
	"create_array", (Type.Fun ([Type.Int; Type.Var()], Type.Array(Type.Float)));

  	"print_char", (Type.Fun ([Type.Int], Type.Unit));
  	"print_int", (Type.Fun ([Type.Int], Type.Unit))] in
*)
  Typing.extenv := M.empty;
 (* List.iter (fun (name, t) -> Typing.extenv := M.add name t !Typing.extenv) extlist;*)
(*external create_array : int -> 'a -> 'a array = "caml_make_vect"*)  
  Emit.f outchan
    (RegAlloc.f
       (Simm.f
	  (Virtual.f
	     (Closure.f
		(iter !limit
		   (Alpha.f
		      (KNormal.f
			 (Typing.f
			    (Parser.exp Lexer.token l)))))))))

let string s = lexbuf stdout "" (Lexing.from_string s) (* 文字列をコンパイルして標準出力に表示する (caml2html: main_string) *)

let file f = (* ファイルをコンパイルしてファイルに出力する (caml2html: main_file) *)
  let inchan = open_in (f ^ ".ml") in
  let outchan = open_out (f ^ ".s") in
  try
    lexbuf outchan f (Lexing.from_channel inchan);
    close_in inchan;
    close_out outchan;
  with e -> (close_in inchan; close_out outchan; raise e)

let () = (* ここからコンパイラの実行が開始される (caml2html: main_entry) *)
  let files = ref [] in
  Arg.parse
    [("-inline", Arg.Int(fun i -> Inline.threshold := i), "maximum size of functions inlined");
     ("-iter", Arg.Int(fun i -> limit := i), "maximum number of optimizations iterated")]
    (fun s -> files := !files @ [s])
    ("Mitou Min-Caml Compiler (C) Eijiro Sumii\n" ^
     Printf.sprintf "usage: %s [-inline m] [-iter n] ...filenames without \".ml\"..." Sys.argv.(0));
  List.iter
    (fun f -> ignore (file f))
    !files
