#include "utils.h"
#include <math.h>

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t tagBits = cache_config.get_num_tag_bits();
  return address >> (32 - tagBits);
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t tagBits = cache_config.get_num_tag_bits();
  uint32_t indexBits = cache_config.get_num_index_bits();
  return (address >> (32 - tagBits - indexBits)) % (int)pow(2, indexBits);
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t offsetBits = cache_config.get_num_block_offset_bits();
  return address % (int) pow(2, offsetBits);
}
