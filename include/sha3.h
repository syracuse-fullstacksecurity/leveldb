#ifndef _SHA3__
#define _SHA3__
#define DIGEST_SIZE 32 
#define DIGEST_SIZE_SHA1 20 
void sha3_update(const unsigned char *input, unsigned int length);
void sha3_final(unsigned char *hash, unsigned int size);
void* sha1(void* message, int message_len, void* digest);//struct element_list** input, int n_ways, struct element_list* output)
#endif
