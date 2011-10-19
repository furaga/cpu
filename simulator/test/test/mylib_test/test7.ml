let rec mul10 x = x * 8 + x * 2 in

let rec read_int _ =
	let ans = Array.create 1 0 in
	let s = Array.create 1 0 in
	let rec read_token in_token prev =
		let c = input_char () in
		let flg = 
			if c < 48 then true
			else if c > 57 then true
			else false in
		if flg then
			(if in_token then (if s.(0) = 1 then ans.(0) else (-ans.(0))) else read_token false c)
		else
			((if s.(0) = 0 then
				(* prev == '-' *)
				(if prev = 45 then s.(0) <- (-1) else s.(0) <- (1));
			else
				());
			ans.(0) <- mul10 ans.(0) + (c - 48);
			read_token true c) in
	read_token false 32 in

let rec read_float _ =
	let i = Array.create 1 0 in
	let f = Array.create 1 0 in
	let exp = Array.create 1 1 in
	let s = Array.create 1 0 in
	let rec read_token1 in_token prev =
		let c = input_char () in
		let flg =
			if c < 48 then true
			else if c > 57 then true
			else false in
		if flg then
			(if in_token then c else read_token1 false c)
		else
			((if s.(0) = 0 then
				(* prev == '-' *)
				(if prev = 45 then s.(0) <- (-1) else s.(0) <- (1));
			else
				());
			i.(0) <- mul10 i.(0) + (c - 48);
			read_token1 true c) in
	let rec read_token2 in_token =
		let c = input_char () in
		let flg =
			if c < 48 then true
			else if c > 57 then true
			else false in
		if flg then
			(if in_token then () else read_token2 false)
		else
			(f.(0) <- mul10 f.(0) + (c - 48);
			exp.(0) <- mul10 exp.(0);
			read_token2 true) in

	let nextch = read_token1 false 32 in
	let ans =
		if nextch = 46 then (* nextch = '.' *)
			(read_token2 false; 
			(float_of_int i.(0)) +. (float_of_int f.(0)) /. (float_of_int exp.(0)))
		else
			float_of_int i.(0) in
	if s.(0) = 1 then 
		ans
	else
		-. ans in

(* test read_int *)
print_int (read_int ());
print_int (read_int ());
print_int (read_int ());

(* test read_float *)
print_float (read_float ());
print_float (read_float ());
print_float (read_float ());
