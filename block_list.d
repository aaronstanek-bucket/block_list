class block_list(T) {
  T blocks[][];
  uint block_size;
  ulong count;
  this() {
    block_size = 10;
    count = 0;
  }
  this(uint siz) {
    block_size = siz;
    count = 0;
  }
  void clear() {
    blocks.length = 0;
    count = 0;
  }
  void setBlockSize(uint siz) {
    clear();
    if (siz!=0) {
      block_size = siz;
    }
    else {
      block_size = 1;
    }
  }
  uint getBlockSize() {
    return block_size;
  }
  ulong getCount() {
    return count;
  }
  T at(ulong index) {
    ulong block_number = index / block_size;
    uint internal_number = index % block_size;
    return blocks[block_number][internal_number];
  }
  void append(T indata) {
    ulong block_number = count / block_size;
    uint internal_number = count % block_size;
    // if we are putting an item at the beginning of a block, we might need to do some memory stuff
    if (internal_number==0) {
      // if the block does not exist, we need to make it
      if (block_number>=blocks.length) {
        blocks.length = (blocks.length*2) + 5; // just an arbitrary growth function
      }
      // now the block exists
      blocks[block_number].reserve(block_size);
      blocks[block_number].length = block_size;
      // now the block has the correct length
    }
    // now the block exists, and has the correct length
    blocks[block_number][internal_number] = indata;
    count++;
  }
  void copyToList (ref T[] outlist) {
    outlist.length = count;
    ulong block_number = count / block_size;
    uint internal_number = count % block_size;
    ulong deposit_index = 0; // where we put the output values
    uint cnum; // I declare it here to save deallocation / reallocation time
    // block_number is the number of full blocks,
    // so we will run the full block copier that many times
    for (ulong cblock=0;cblock<block_number;cblock++) {
      // cblock is a the block that we are copying
      for (cnum=0;cnum<block_size;cnum++) {
        // cnum is the index that we are copying
        outlist[deposit_index] = blocks[cblock][cnum];
        deposit_index++;
      }
    }
    // this does not copy the last block, so we have to do that separately
    for (cnum=0;cnum<internal_number;cnum++) {
      outlist[deposit_index] = blocks[block_number][cnum];
      deposit_index++;
    }
  }
}
