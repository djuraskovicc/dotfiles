#include "../slstatus.h"
#include "../util.h"
#include <dirent.h>
#include <stdio.h>
#include <string.h>

#define MAX_PATH_LEN 256
#define BASE_DIR "/sys/class/backlight/"

static char path[MAX_PATH_LEN];
static char full_path[MAX_PATH_LEN];
static char max_path[MAX_PATH_LEN];
static int max = -1;

static int get_backlight_path(char *path, size_t size) {
  DIR *dir = opendir(BASE_DIR);
  if (!dir)
    return -1;

  struct dirent *entry;
  while ((entry = readdir(dir)) != NULL) {
    if (entry->d_name[0] == '.')
      continue;

    if (snprintf(path, size, BASE_DIR "%s", entry->d_name) >= (int)size) {
      closedir(dir);
      return -2;
    }

    break;
  }

  closedir(dir);
  return path[0] ? 0 : -3;
}

static int read_int_from_file(const char *filepath, int *out) {
  FILE *fp = fopen(filepath, "r");
  if (!fp)
    return -1;

  int result = fscanf(fp, "%i", out);
  fclose(fp);
  return result == 1 ? 0 : -2;
}

static int build_path(char *dest, size_t size, const char *dir, const char *file) {
  return snprintf(dest, size, "%s/%s", dir, file) < (int)size ? 0 : -1;
}

const char *brightness(const char *unused) {
  int bright;

  if (path[0] == '\0') {
    int status = get_backlight_path(path, sizeof(path));
    if (status == -1) return bprintf("ERROR: not a dir");
    if (status == -2) return bprintf("ERROR: path overflow");
    if (status == -3) return bprintf("ERROR: no entry");
  }

  if (max == -1) {
    if (build_path(max_path, sizeof(max_path), path, "max_brightness") != 0)
      return bprintf("ERROR: max_path overflow");

    if (read_int_from_file(max_path, &max) != 0)
      return bprintf("ERROR: failed to read MAX");
  }

  if (full_path[0] == '\0') {
    if (build_path(full_path, sizeof(full_path), path, "brightness") != 0)
      return bprintf("ERROR: full_path overflow");
  }

  if (read_int_from_file(full_path, &bright) != 0)
    return bprintf("ERROR: failed to read BRIGHT");

  return bprintf("%i", bright * 100 / max);
}
