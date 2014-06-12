#include <iostream>
#include <cstdio>
#include <cmath>
#define Q1

using namespace std;

struct cache_content {
	bool v;
	unsigned int  tag;
//	unsigned int	data[16];    
};

const int K = 1024;

void simulate(int cache_size, int block_size) {
	unsigned int tag, index, x;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/block_size);
	int line = cache_size>>(offset_bit);

	cache_content *cache = new cache_content[line];
    

	for(int j=0;j<line;j++)
		cache[j].v=false;
	
#ifdef DEBUG
    FILE* fp = fopen("Trace1.txt","r");					//read file
#else
    FILE* fp = fopen("Trace.txt","r");					//read file
#endif
	
    int miss = 0, hit = 0;
	while(fscanf(fp, "%x", &x) != EOF) {
		index = (x>>offset_bit) & (line-1);
		tag = x>>(index_bit+offset_bit);
#ifdef DEBUG
        cout << "\nindex: " << index << "\ttag: " << tag << "\t";
#endif
		if (cache[index].v && cache[index].tag == tag) {
			cache[index].v = true; 			//hit
            ++hit;
		}
		else {						
			cache[index].v = true;			//miss
			cache[index].tag = tag;
            ++miss;
		}
	}
	fclose(fp);

	delete [] cache;
    cout << "miss rate: " << miss/(double)(miss + hit) << endl;
}
	
int main() {
#ifdef Q1
    int cache_size[] = {64, 128, 256, 512, 1024};
    int block_size[] = {4, 8, 16, 32};
    for (int i = 0; i < 5; ++i) {
        for (int j = 0; j < 4; ++j) {
            cout << "Cache size: " << cache_size[i] << "\t Block size: " << block_size[j] << "\t";
            simulate(cache_size[i], block_size[j]);
        }
        cout << endl;
    }
#endif
#ifdef Q1
#endif
}
