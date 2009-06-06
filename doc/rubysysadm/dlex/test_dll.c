#include <stdio.h>	
#include "dl_ex.h"

int main() {
  char              str[21];
  struct STRUCT_DLL S;
  int               i;

  S.count_int       = 10;
  S.ints            = malloc(sizeof(int) * 10);

  for (i=0; i<10; i++) {
    S.ints[i] = i;
  }


  func_dll(42, str, &S);

  printf("str: %s\n", str);

  printf("times2(3)= %d\n", times2(3));

	int num = 3;
	int* nump = times3(&num);
  printf("times3(3)= %d\n", num);
  printf("times3(3)= %d\n", *nump);

  struct struct1* st1 = struct_test();
  printf("st1->int1= %d\n", st1 -> int1);
  printf("st1->int2= %d\n", st1 -> int2);
}
