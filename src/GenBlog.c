#include<stdlib.h>
#include<stdio.h>
#include<dirent.h>
#include<string.h>

void parseBox(void);
void parseNoBox(void);
void genBP(char *file);
void echoFile(FILE *fp);
void next();
void append_html(char *string);

int ch;
FILE *curr;
FILE *chtml;

int main() {
	DIR *dir;
	struct dirent *ent;
	char buff[256];
	char htmlName[256];
	char link[256];
	char cat[2];
	char *c;
	int i;
	
	if ((dir = opendir("./blogs/RawBlogs")) != NULL) {
		while ((ent = readdir(dir)) != NULL) {
			if (strcmp(ent->d_name, ".") && strcmp(ent->d_name, "..")) {
				sprintf(htmlName, "./blogs/");
				sprintf(link, "");

				c = ent->d_name;
				i = 0;
				while (c[i] != '.') {
					cat[0] = c[i];
					cat[1] = '\0';
					strcat(htmlName, cat);
					strcat(link, cat);
					i++;
				}
				strcat(htmlName, ".html");

				printf("%s\n", htmlName);
				sprintf(buff, "./blogs/RawBlogs/");
				strcat(buff, ent->d_name);
				printf("opening, %s, %s, %s\n", buff, htmlName, link);
				chtml = fopen(htmlName, "a+");
				genBP(buff);
				// Add links now
				chtml = fopen("./blogs.html", "a+");
				append_html("<center><a href=");
				append_html(htmlName);
				append_html(">");
				append_html(link);
				append_html("</a></center>\n");
				fclose(chtml);
			}
		}
	}
	return EXIT_SUCCESS;
}

void genBP(char *file) {
	char buff[256];
	curr = fopen(file, "r");

	// just for debug
	//echoFile(fopen(file, "r"));

	//Begin parsing the file.
	next();
	while (ch != EOF) {
		switch (ch) {
			case '(':
				next();
				parseBox();
				next();
				break;
			case '[':
				next();
				parseNoBox();
				next();
				break;
		}
		next();
	}
	fclose(curr);
	fclose(chtml);
}

void echoFile(FILE *fp) {
	char line[256] = "";
	char cat[2];
	ch = getc(fp);

	printf("Echo file\n");
	while (ch != EOF) {
		if (ch != '\n') {
			cat[0] = ch;
			cat[1] = '\0';
			strcat(line, cat);
		} else {
			printf("%s\n", line);
			sprintf(line, "");
		}
		ch = getc(fp);
	}
	fclose(fp);
}

void next() {
	ch = getc(curr);
}

void parseBox() {
	int i = 0;
	int j;
	char *tb =    "+-------------------------------------------------------+\n";
	char *empty = "|                                                       |\n";
	char line[256];
	char cat[2];
	
	append_html(tb);
	append_html(empty);

	while (ch != ')' && ch != EOF) {
		if (ch == '\n') {
			next();
			if (ch == ')') {
				break;
			}
		}
		if (!i) {
			append_html("|   ");
		} else if ( i < 47) {
			//print char
			cat[0] = ch;
			cat[1] = '\0';
			append_html(cat);
			next();
		} else {
			//setup newline
			i = -1;
			append_html("-    |");
		}
		i++;
	}

	for (j = 0; j < (53-i); j++) {
		line[j] = ' ';
	}
	
	line[j++] = '|';
	line[j] = '\0';
	append_html(line);
	append_html("\n");
	append_html(empty);
	append_html(tb);
}

void parseNoBox() {
	char cat[2];
	int i = 0;
	char *nl = "\n";
	int flag = 0;

	append_html("   ");
	while (ch != ']' && ch != EOF) {
		cat[0] = ch;
		cat[1] = '\0';
		if (ch == '\n') {
			i = 0;
		}

		if (i > 61) {
			if (ch != ',' && ch != ' ') {
				i = 0;
				if (!flag) {
					append_html("-");
					flag = 0;
				}
				append_html(nl);
			} else {
				flag = 1;
			}
		}

		append_html(cat);
		next();
		i++;
	}
	append_html("\n");
}

void append_html(char *str) {
	fputs(str, chtml);
}
