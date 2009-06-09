#ifndef DLL_H__
#define DLL_H__
typedef struct list {
	int val;
	struct list* next;
}*node;
node init_list(int num);
#endif
