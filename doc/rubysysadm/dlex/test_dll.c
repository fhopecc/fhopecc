#include <stdio.h>	
#include "dll.h"
int main() {
	int num;
	printf("Enter the number of a list:");
	scanf("%d", &num);
	node head, curr;
	curr = NULL;
	head = init_list(num);
	curr = head;
	while(curr) {
		printf("->%d", curr->val);
		curr = curr->next;
	}
	puts("");
}
