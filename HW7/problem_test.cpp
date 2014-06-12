#include <iostream>
#include <cstdio>
#include <cmath>
#include <queue>
#include <algorithm>
#define Q2

using namespace std;

struct cache_content {
	bool v;
	unsigned int tag;
#ifdef Q2
    unsigned int pre_instr;
#endif
};

const int K = 1024;

#ifdef Q2
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
#ifdef DEBUG_detail
        cout << "\nindex: " << index << "\ttag: " << tag << "\t";
#endif
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

#ifdef print_instr
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
#endif

    cout << "Miss rate: " << miss/(double)(miss + hit)*100 << "%\n" << endl;
}
#endif

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
	
    int miss = 0, hit = 0, instr = 1;
	while(fscanf(fp, "%x", &x) != EOF) {
		index = (x>>offset_bit) & (line-1);
		tag = x>>(index_bit+offset_bit);
#ifdef DEBUG_detail
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
        ++instr;
	}
	fclose(fp);

	delete [] cache;

    cout << "Miss rate: " << miss/(double)(miss + hit)*100 << "%" << endl;
}
	
int main() {
#ifdef Q1
    int cache_size[] = {64, 128, 256, 512, 1024};
    int block_size[] = {4, 8, 16, 32};
    for (int i = 0; i < 5; ++i) {
        for (int j = 0; j < 4; ++j) {
            cout << "Cache size: " << cache_size[i] << "\tBlock size: " << block_size[j] << endl;
            simulate(cache_size[i], block_size[j]);
        }
        cout << endl;
    }
#endif
#ifdef Q2
    int cache_size[] = {1, 2, 4, 8, 16, 32};
    int block_size = 32;
    int n_way[] = {1, 2, 4, 8};
    for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < 4; ++j) {
            cout << "Cache size: " << cache_size[i] << "K\tBlock size: " << block_size << 
                "\tAssociativity: " << n_way[j] << endl;
            simulate(cache_size[i] * K, block_size, n_way[j]);
        }
    }
#endif
}
