#include "../include/verifier.h"
#include <iostream>
#include <stdio.h>
int main() {
	return 0;
}

int verifier_init() {
	printf("%s called\n",__func__);
}
int verifier_put(const Slice& key, const Slice& value) {
	std::cout << "verifier_put key = " << key.ToString() << std::endl;
	std::cout << "verifier_put val = " << value.ToString() << std::endl;
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
