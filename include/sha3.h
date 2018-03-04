#ifndef _SHA3__
#define _SHA3__
#define DIGEST_SIZE 32 
void sha3_update(const unsigned char *input, unsigned int length);
void sha3_final(unsigned char *hash, unsigned int size);
#endif
