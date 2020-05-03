#include<stdlib.h>
#include<stdio.h>
#include<dirent.h>
#include<string.h>

void parseBox(void);
void parseNoBox(void);
void genBP(char *file);
void echoFile(FILE *fp);
int ch;

int main() {
	DIR *dir;
	struct dirent *ent;
	char buff[256];
	
	if ((dir = opendir("./blogs/RawBlogs")) != NULL) {
		while ((ent = readdir(dir)) != NULL) {
			if (strcmp(ent->d_name, ".") && strcmp(ent->d_name, "..")) {
				printf("file = %s\n", ent->d_name);
				sprintf(buff, "./blogs/RawBlogs/");
				strcat(buff, ent->d_name);
				printf("opening, %s\n", buff);
				genBP(buff);
			}
		}
	}
	return EXIT_SUCCESS;
}

void genBP(char *file) {
	FILE *fp = fopen(file, "r");
	char buff[256];
	echoFile(fopen(file, "r"));

	//Begin parsing the file.
	ch = getc(fp);
	while (ch != EOF) {
		switch (ch) {
			case '-':
				ch = getc(fp);
				parseBox();
				break;
			case '[':
				ch = getc(fp);
				parseNoBox();
				break;
		}
		ch = getc(fp);
	}
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

void parseBox() {

}

void parseNoBox() {

}
