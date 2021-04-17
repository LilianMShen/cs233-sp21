#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */
  // use cache's cacheconfig 
  // then input address + cacheconfig into utils
  // then use these to search for the block
  const CacheConfig& config = _cache->get_config();
  uint32_t tag = extract_tag(address, config);
  uint32_t index = extract_index(address, config);
  
  vector<Cache::Block*> set = _cache->get_blocks_in_set(index);
  Cache::Block *block = nullptr;

  for (int i = 0; i < set.size(); i++){
    if (set[i]->get_tag() == tag && set[i]->is_valid()) {
      block = set[i];
      _hits++;
    }
  }
  
  if (block == nullptr){
    return NULL;
  }

  return (block);
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */

  const CacheConfig& config = _cache->get_config();
  uint32_t tag = extract_tag(address, config);
  uint32_t index = extract_index(address, config);
  Cache::Block *block = nullptr;
  //Cache::Block block = Block(index, config)
  
  vector<Cache::Block*> set = _cache->get_blocks_in_set(index);

  for (int i = 0; i < set.size(); i++){
    if (!set[i]->is_valid()) {
      block = set[i];
      block ->set_tag(tag);
      block ->read_data_from_memory(_memory);
      block ->mark_as_valid();
      block ->mark_as_clean();
      
      return block;
    }
  }

  uint32_t last = set[0]->get_last_used_time();
  block = set[0];
  for (int i = 0; i < set.size(); i++){
    if (last > set[i]->get_last_used_time()){
      last = set[i]->get_last_used_time();
      block = set[i];
    }
  }
  if(block->is_dirty()){
    block->write_data_to_memory(_memory);
  }
  block ->set_tag(tag);
  block ->read_data_from_memory(_memory);
  block ->mark_as_valid();
  block ->mark_as_clean();
  return block;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  _use_clock++;
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
  const CacheConfig& config = _cache->get_config();
  uint32_t offset = extract_block_offset(address, config);
  Cache::Block* block = find_block(address);
  if (block == NULL){
    block = bring_block_into_cache(address);
  }
  block->set_last_used_time(_use_clock.get_count());
  return block->read_word_at_offset(offset);
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  _use_clock++;
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
  // Cache::Block* block = find_block(address);
  // if (block == NULL){
  //   if(_policy.is_write_allocate()){
  //     block = bring_block_into_cache(address);
  //   } else {
  //     _memory->write_word(address, word);
  //   }
  // }
  // block->set_last_used_time(_use_clock.get_count());
  // if(_policy.is_write_back()){
  //   block->mark_as_dirty();
  // } else {
  //   _memory->write_word(address, word);
  // }
}