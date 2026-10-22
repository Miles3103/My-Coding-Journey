#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

void searchFile(const char *basePath, const char *targetFile) {
    char path[1024];
    struct dirent *dp;
    DIR *dir = opendir(basePath);

    if (!dir) return;

    while ((dp = readdir(dir)) != NULL) {
        if (strcmp(dp->d_name, ".") != 0 && strcmp(dp->d_name, "..") != 0) {
            // Check if file matches
            if (strcmp(dp->d_name, targetFile) == 0) {
                printf("Found: %s/%s\n", basePath, dp->d_name);
            }

            // Construct full path for recursive subfolder search
            snprintf(path, sizeof(path), "%s/%s", basePath, dp->d_name);

            struct stat statbuf;
            if (stat(path, &statbuf) == 0 && S_ISDIR(statbuf.st_mode)) {
                searchFile(path, targetFile);
            }
        }
    }
    closedir(dir);
}

int main() {
    char filename[256];
    
    printf("Enter filename to search: ");
    if (scanf("%255s", filename) != 1) return 1;

    // "." represents the current working directory
    printf("Searching in current directory and subfolders...\n");
    searchFile(".", filename);

    return 0;
}
