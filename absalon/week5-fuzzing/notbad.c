#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

void tiptop(char input[4]) { 
  int cnt=0; 
  if (input[0] == 'b') cnt++;
  if (input[1] == 'a') cnt++;
  if (input[2] == 'd') cnt++;
  if (input[3] == '!') cnt++;
  if (cnt >= 3) abort();
  printf("Checked\n");
}

int main() {

  char *buffer = NULL;
  size_t buf_cap = 0;

  ssize_t bytes_read = getline(&buffer, &buf_cap, stdin);
  if (bytes_read == -1) exit(EXIT_FAILURE);
  
  size_t len = strlen(buffer);
  if(len >= 4)
    tiptop(buffer);

  printf("Looks good\n");
  return EXIT_SUCCESS;
}

