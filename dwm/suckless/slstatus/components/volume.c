#include "../slstatus.h"
#include "../util.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define VOL_BUFF_SIZE 16
#define MUTE_BUFF_SIZE 12

int read_mute(FILE *file, char *mute) {
  file = popen("pamixer --get-mute", "r");

  if (file == NULL) {
    return 1;
  }

  if (fgets(mute, sizeof(mute), file) == NULL) {
    pclose(file);
    return 2;
  }

  pclose(file);
  return 0;
}

int read_volume(FILE *file, char *vol) {
  file = popen("pamixer --get-volume", "r");

  if (file == NULL) {
    return 1;
  }

  if (fgets(vol, sizeof(vol), file) == NULL) {
    pclose(file);
    return 2;
  }

  pclose(file);
  return 0;
}

const char *volume(const char *unused) {
  FILE *cmd = NULL;
  char vol[VOL_BUFF_SIZE];
  char mute[MUTE_BUFF_SIZE];

  if (read_mute(cmd, mute) != 0) {
    return bprintf("Error");
  }

  mute[strcspn(mute, "\n")] = '\0';

  if (strcmp(mute, "true") == 0) {
    return bprintf("🔇");
  }

  if (read_volume(cmd, vol) != 0) {
    return bprintf("Error 2");
  }

  vol[strcspn(vol, "\n")] = '\0';
  int volume_lvl = atoi(vol);

  if (volume_lvl <= 25) {
    return bprintf("🔈 %d%%", volume_lvl);
  } else if (volume_lvl <= 65) {
    return bprintf("🔉 %d%%", volume_lvl);
  }
  return bprintf("🔊 %d%%", volume_lvl);
}
