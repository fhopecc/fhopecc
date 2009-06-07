#ifndef MINGW_DLL_H__
#define MINGW_DLL_H__
typedef struct list {
	int val;
	struct list* next;
}* node;
node init_list();

typedef struct _name{
	char *first;
	char *last;
}name;

typedef struct _phonebook{
	name name;
	char *number;
	struct _phonebook* next;
}* phonebook;
phonebook init_phonebook();

int* return_intp(int*);
int times2(int num);
int* times3(int* num);
struct struct1 {
	int int1;
	int int2;
};
struct struct1* struct_test();
#endif
