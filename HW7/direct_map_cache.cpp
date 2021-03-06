#include <iostream>
#include <cstdio>
#include <cmath>
#include <queue>
#include <algorithm>
#define DEBUG

using namespace std;

struct cache_content {
	bool v;
	unsigned int tag;
    unsigned int pre_instr;
};

const int K = 1024;

void simulate(int cache_size, int block_size, int associative) {
	unsigned int tag, index, x;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/associative/block_size);
	int line = cache_size>>(offset_bit);

	cache_content *cache = new cache_content[line];
    
	for(int j=0;j<line;j++) {
		cache[j].v=false;
        for (int i = 0; i < 16; ++i)
            cache[j].pre_instr = 0;
    }
	
#ifdef DEBUG
    FILE* fp = fopen("Trace1.txt","r");					//read file
#else
    FILE* fp = fopen("Trace.txt","r");					//read file
#endif
	
    int miss = 0, hit = 0, instr = 1;
    queue<int> hit_instr, miss_instr;

	while(fscanf(fp, "%x", &x) != EOF) {
		index = (x>>offset_bit) & (line/associative-1);
		tag = x>>(index_bit+offset_bit);
        int oldest = 0xfffffff, oldest_block = 0;
        bool end = false;
        for (int i = 0; i < associative; ++i) {
            if (cache[index*associative+i].v == false) {
                ++miss;
                miss_instr.push(instr);
                cache[index*associative+i].pre_instr = instr;
                cache[index*associative+i].tag = tag;
                cache[index*associative+i].v = true;
                end = true;
                break;
            }
            else if (cache[index*associative+i].tag == tag) {
                ++hit;
                hit_instr.push(instr);
                cache[index*associative+i].pre_instr = instr;
                end = true;
                break;
            }
            else {
                if (cache[index*associative+i].pre_instr < oldest) {
                    oldest = cache[index*associative+i].pre_instr;
                    oldest_block = index*associative+i;
                }
            }
        }

        if (!end) { // kick one block out!
            ++miss;
            miss_instr.push(instr);
            cache[oldest_block].pre_instr = instr;
            cache[oldest_block].tag = tag;
        }
        ++instr;
	}
	fclose(fp);

	delete [] cache;

    cout << "Hits intructions: ";
    if (!hit_instr.empty()) {
        cout << hit_instr.front();
        hit_instr.pop();
    }
    while (!hit_instr.empty()) {
        cout << "," << hit_instr.front();
        hit_instr.pop();
    }
    cout << endl;

    cout << "Miss intructions: ";
    if (!miss_instr.empty()) {
        cout << miss_instr.front();
        miss_instr.pop();
    }
    while (!miss_instr.empty()) {
        cout << "," << miss_instr.front();
        miss_instr.pop();
    }
    cout << endl;

    cout << "Miss rate: " << miss/(double)(miss + hit)*100 << "%\n" << endl;
}

int main() {
    int cache_size, block_size, associative;
    cout << "Cache size = ";
    cin >> cache_size;
    while (!cin.eof()) {
        cout << "Block size = ";
        cin >> block_size;
        cout << "Associativity = ";
        cin >> associative;
        simulate(cache_size, block_size, associative);
        cout << "Cache size = ";
        cin >> cache_size;
    }
}
