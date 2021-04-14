#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  // tag index offset
  std::vector< SimpleCacheBlock > blockvector = _cache[index];
  SimpleCacheBlock *block = nullptr;

  for (int i = 0; i < blockvector.size(); i++){
    if (blockvector[i].tag() == tag && blockvector[i].valid()) {
      block = &blockvector[i];
    }
  }
  
  if (block == nullptr){
    return 0xdeadbeef;
  }

  return (block->get_byte(block_offset));
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign (see "C++ Rule of Three")
  std::vector< SimpleCacheBlock > blockvector = _cache[index];
  bool flag = false;

  for (int i = 0; i < blockvector.size(); i++){
    if (!blockvector[i].valid()) {
      blockvector[i].replace(tag, data);
      flag = true;
      break;
    }
  }

  if (!flag) {
    blockvector[0].replace(tag, data);
  }
}
