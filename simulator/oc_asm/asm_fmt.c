
#include <string.h>
#include <stdio.h>
int _directive_is(char *line, const char* str) {
	return strstr(line, str) != NULL;
}
int is_directive(char*line, char *term0) {
	return term0[0] == '.';
}
int is_label(char*line, char *term0) {
	return strchr(line,':') != NULL;
}
int is_comment(char*line, char *term0) {
	return term0[0] == '!';
}
int set_term0(char *line, char *term0) {
	return sscanf(line, "%s", term0);
}
