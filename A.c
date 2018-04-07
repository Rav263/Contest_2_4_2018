#include <stdio.h>
#include <string.h>


int some(char *s1, char *s2, int len1, int len2){
  for(int i = 0; i < len1 - len2 + 1; i++){
    int s = 1;
    for(int j = 0; j < len2; j++){
//      printf("%c == %c\n", s1[i + j], s2[j]);
      if(s1[i + j] != s2[j]){
        s = 0;
        break;
      }
    }
    if(s)return 1;
  }
  return 0;
}


int main(void){
  char s1[1000];
  char s2[1000];

  scanf("%s", s1);
  scanf("%s", s2);

  int len1 = strlen(s1);
  int len2 = strlen(s2);


  if(len1 < len2){
    if(some(s2, s1, len2, len1)) printf("1 2\n");
    else printf("0\n");
  }
  else{
    if(some(s1, s2, len1, len2)) printf("2 1\n");
    else printf("0\n");
  }
  return 0;
}
