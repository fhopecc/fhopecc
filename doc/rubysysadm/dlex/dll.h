#ifndef MINGW_DLL_H__
#define MINGW_DLL_H__

struct STRUCT_DLL {
   int  count_int;
   int* ints;
};


int func_dll(
    int                an_int,
    char*              string_filled_in_dll,
    struct STRUCT_DLL* struct_dll
);

int times2(int num);

int* times3(int* num);

struct struct1 {
	int int1;
	int int2;
};

struct struct1* struct_test();
#endif
