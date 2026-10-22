#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

void findFilePath(const char *basePath, const char *targetFile) {
    char path[1024];
    struct dirent *dp;
    DIR *dir = opendir(basePath);

    if (!dir) return; // Skip directories that cannot be opened (permission denied, etc.)

    while ((dp = readdir(dir)) != NULL) {
        // Skip current (.) and parent (..) directory links
        if (strcmp(dp->d_name, ".") != 0 && strcmp(dp->d_name, "..") != 0) {
            
            // Construct full path
            if (strcmp(basePath, "/") == 0) {
                snprintf(path, sizeof(path), "/%s", dp->d_name);
            } else {
                snprintf(path, sizeof(path), "%s/%s", basePath, dp->d_name);
            }

            // Check if current file matches target file name
            if (strcmp(dp->d_name, targetFile) == 0) {
                printf("Path: %s\n", path);
            }

            // Check if the entry is a directory to recurse into
            struct stat statbuf;
            if (stat(path, &statbuf) == 0 && S_ISDIR(statbuf.st_mode)) {
                findFilePath(path, targetFile);
            }
        }
    }
    closedir(dir);
}

int main() {
    char filename[256];

    printf("Enter filename to search: ");
    if (scanf("%255s", filename) != 1) return 1;

    printf("Searching system for full path...\n");
    findFilePath("/", filename); // Searches starting from system root '/'

    return 0;
}
