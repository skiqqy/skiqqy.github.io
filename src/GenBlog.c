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
	char cat[2];
	char *c;
	int i;
	
	if ((dir = opendir("./blogs/RawBlogs")) != NULL) {
		while ((ent = readdir(dir)) != NULL) {
			if (strcmp(ent->d_name, ".") && strcmp(ent->d_name, "..")) {
				sprintf(htmlName, "./blogs/");

				c = ent->d_name;
				i = 0;
				while (c[i] != '.') {
					cat[0] = c[i];
					cat[1] = '\0';
					strcat(htmlName, cat);
					i++;
				}
				strcat(htmlName, ".html");
				printf("%s\n", htmlName);
				sprintf(buff, "./blogs/RawBlogs/");
				strcat(buff, ent->d_name);
				printf("opening, %s, %s|\n", buff, htmlName);
				chtml = fopen(htmlName, "a+");
				genBP(buff);
			}
		}
	}
	return EXIT_SUCCESS;
}

void genBP(char *file) {
	char buff[256];
	curr = fopen(file, "r");

	// just for debug
	echoFile(fopen(file, "r"));

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
	ch = getc(fp);

	printf("Echo file\n");
	while (ch != EOF) {
		if (ch != '\n') {
			strcat(line, &ch);
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
			append_html(&ch);
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

}

void append_html(char *str) {
	fputs(str, chtml);
}
