#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t numTagBits = _cache_config.get_num_index_bits();
  uint32_t numOffsetBits = _cache_config.get_num_block_offset_bits();

  return (_tag << (32 - numTagBits)) + (_index << numOffsetBits);

}
