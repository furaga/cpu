import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.io.*;

class Merge {
	public static void main(String args[]) {
		if (args.length < 2) {
			System.out.println("usage: java Merge [outfile] [infile1] [infile2] ・・・");
		}
		System.out.println("output files : " + args[0]);
		System.out.print("input files : ");
		for (int i = 1; i < args.length; i++) {
			System.out.print(args[i] + " ");
		}
		System.out.print("\n");

		try {
			BufferedReader[] in = new BufferedReader[args.length - 1];
        	FileOutputStream outf = new FileOutputStream(args[0]);
		    OutputStreamWriter out = new OutputStreamWriter(outf, "UTF-8");

			for (int i = 1; i < args.length; i++) {
				FileInputStream inf = new FileInputStream(args[i]);
				in[i - 1] = new BufferedReader(new InputStreamReader(inf, "UTF-8"));
			}

			// init_heap_size XXX を読み込む
			int heap_sum_size = 0;
			int[] heap_sizes = new int[args.length - 1];
			for (int i = 0; i < args.length - 1; i++) {
				String s = in[i].readLine();
				System.out.print(s + " => ");
				Matcher m = Pattern.compile("(\\d+)").matcher(s);
				if (m.find()) {
					System.out.println(m.group(1));
					heap_sizes[i] = Integer.parseInt(m.group(1));
					heap_sum_size += heap_sizes[i];
				}
				else {
					System.out.println("couldn't get heap size");
				}
			}

			System.out.println(".init_heap_size\t" + heap_sum_size + "\n");
			out.write(".init_heap_size\t" + heap_sum_size + "\n");

			// 各ファイルのヒープ初期化部分を書き込む
			for (int i = 0; i < args.length - 1; i++) {
				while (heap_sizes[i] > 0) {
					String s = in[i].readLine();
					if (s == null) {
						System.out.println("heap size not matches");
						break;
					}	
					out.write(s + "\n");
					if (s.trim().startsWith(".long") ||
						s.trim().startsWith(".float") ||
						s.trim().startsWith(".int")) {
						heap_sizes[i] -= 32;
					}
				}
			}

			out.write("\tjmp\tmin_caml_start\n");
			
			// その他の部分の書き込み
			for (int i = 0; i < args.length - 1; i++) {
				while (true) {
					String s = in[i].readLine();
					if (s == null) break;
					if (s.trim().startsWith("jmp\tmin_caml_start")) continue;
					out.write(s + "\n");
				}
				in[i].close();
			}

			out.close();
		}
		catch (IOException e) {
			System.out.println(e);
		}
	}
}
/*


class JSample1_1{


  public static void main(String args[]){
      String str1 = "Hello";
	      String str2 = "Hey";

		      String regex = "e.*o";
			      Pattern p = Pattern.compile(regex);

				      Matcher m1 = p.matcher(str1);

					      System.out.print(str1 + " は");
						      if (m1.find()){
							        System.out.println("マッチします");
									    }else{
										      System.out.println("マッチしません");
											      }

												      Matcher m2 = p.matcher(str2);

													      System.out.print(str2 + " は");
														      if (m2.find()){
															        System.out.println("マッチします");
																	    }else{
																		      System.out.println("マッチしません");
																			      }
																				    }
																					}*/
