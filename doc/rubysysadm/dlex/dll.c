#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "dll.h"
node init_list(int num) {
  node head, curr;  
	head = NULL;
	int i;
	for(i=1;i<=num;i++) {
    curr = (node)malloc(sizeof(node));
		curr->val = i;
		curr->next = head;
		head = curr;
	}
	return head;
}
