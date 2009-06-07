#include <stdio.h>	
#include "dll.h"
int i1 = 3;
int main() {
  printf("times2(3)= %d\n", times2(3));
	int num = 3;
	int* nump = times3(&num);
  printf("times3(3)= %d\n", num);
  printf("times3(3)= %d\n", *nump);

  struct struct1* st1 = struct_test();
  printf("st1->int1= %d\n", st1 -> int1);
  printf("st1->int2= %d\n", st1 -> int2);
	int num1 = 3;
	int* ip = &num1;
	int* ip2 = return_intp(ip);
  printf("return_intp= %d\n", *ip2);

	puts("Print List.");
	node head, curr = NULL;
	head = init_list();
	curr = head;
	while(curr) {
		printf("->%d", curr->val);
		curr = curr->next;
	}
	puts("\n");

	puts("Print phonebook.");
	phonebook headp, cur_p = NULL;
	headp = init_phonebook();
	cur_p = headp;
	while(cur_p) {
		printf("%s, %s: %s\n", cur_p->name.first, cur_p->name.last, cur_p->number);
		cur_p = cur_p->next;
	}
}
