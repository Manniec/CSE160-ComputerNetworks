interface NeighborDiscover{
    command void start();
    command void updateNeighborsTable(uint32_t srcNode, uint16_t newSeqNum);
    command uint32_t* getNeighbors();
    command uint16_t getNeighborsCount();
   
}