#include "../include/verifier.h"
#include <stdio.h>
int main() {
	return 0;
}

int verifier_init() {
	printf("%s called\n",__func__);
}
int verifier_put() {
	printf("%s called\n",__func__);
}
int verifier_get() {
	printf("%s called\n",__func__);
} 
int verifier_compact_memtable() {
	printf("%s called\n",__func__);
}
int verifier_compaction() {
	printf("%s called\n",__func__);
}
