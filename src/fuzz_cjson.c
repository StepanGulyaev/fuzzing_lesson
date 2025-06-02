#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "../lib/cJSON/cJSON.h"

int test_cjson(unsigned char* buf, size_t len);

__AFL_FUZZ_INIT();
int main(){
	__AFL_INIT();
	unsigned char* buf = __AFL_FUZZ_TESTCASE_BUF;
	while(__AFL_LOOP(1000)) {
		size_t len = __AFL_FUZZ_TESTCASE_LEN;
		test_cjson(buf,len);
	}
}

int test_cjson(unsigned char* buf, size_t len) {
	cJSON* root = cJSON_Parse(buf);
	
	cJSON* foo = cJSON_GetObjectItem(root,"foo");

	cJSON_Delete(root);
	return 0;
}
