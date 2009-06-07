#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "dll.h"
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
int* return_intp(int* ip) {
  *ip = *ip + 1;
  return ip;
}
node init_list() {
  node head, curr;  
	int i;
	head = NULL;
	for(i=1;i<=10;i++) {
    curr = (node)malloc(sizeof(node));
		curr->val = i;
		curr->next = head;
		head = curr;
	}
	return head;
}
phonebook init_phonebook() {
  name n1 = {"Robert", "Lee"};
	phonebook head = NULL;
	phonebook cur = (phonebook)malloc(sizeof(phonebook));
	cur->name = n1;
	cur->number = "3391024\0";
	cur->next = head;
	head = cur;
	return head;
}
