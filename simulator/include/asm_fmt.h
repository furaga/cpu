
#ifndef __ASM_FMT_HEAD__
#define __ASM_FMT_HEAD__

#define	COL_MAX 512
#define LINE_MAX (32*1024)
#define asm_fmt_if "%s %%f%d"
#define asm_fmt_ig "%s %%g%d"
#define asm_fmt_ii "%s %d"
#define asm_fmt_il "%s %s"
#define asm_fmt_iff "%s %%f%d, %%f%d"
#define asm_fmt_ifg "%s %%f%d, %%g%d"
#define asm_fmt_igf "%s %%g%d, %%f%d"
#define asm_fmt_igg "%s %%g%d, %%g%d"
#define asm_fmt_igi "%s %%g%d, %d"
#define asm_fmt_igl "%s %%g%d, %s"
#define asm_fmt_ifff "%s %%f%d, %%f%d, %%f%d"
#define asm_fmt_iffl "%s %%f%d, %%f%d, %s"
#define asm_fmt_ifgg "%s %%f%d, %%g%d, %%g%d"
#define asm_fmt_ifgi "%s %%f%d, %%g%d, %d"
#define asm_fmt_iggg "%s %%g%d, %%g%d, %%g%d"
#define asm_fmt_iggi "%s %%g%d, %%g%d, %d"
#define asm_fmt_iggl "%s %%g%d, %%g%d, %s"

extern int is_directive(char*,char*);
extern int is_label(char*,char*);
extern int is_comment(char*,char*);
extern int _directive_is(char *line, const char* str);
extern int set_term0(char*,char*);
#endif
