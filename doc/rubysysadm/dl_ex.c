#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "dl_ex.h"

int times2(int num) {
	return num*2;
}

int* times3(int* num) {
	*num = *num*3;
  return num;
}

struct struct1* struct_test() {
  struct struct1 * _sc1;
	_sc1 = (struct struct1*)malloc(sizeof(struct struct1));
	_sc1->int1 = 1;
	_sc1->int2 = 2;
	return _sc1;
}

int func_dll(int an_int, char* string_filled_in_dll, 
		         struct STRUCT_DLL* struct_dll) {

  int i;

  printf("\n");
  printf("func_dll called\n");
  printf("---------------\n");
  printf("  an_int=%d\n", an_int);

  strcpy(string_filled_in_dll, "String filled in DLL");

  printf("  count_int=%d: ", struct_dll->count_int);
  for (i=0; i<struct_dll->count_int; i++) {
    printf("  %d", struct_dll->ints[i]);
  }
  printf("\n");

  printf("\nreturning from func_dll\n");
  printf("-----------------------\n\n\n");

  return 2*an_int;
}
