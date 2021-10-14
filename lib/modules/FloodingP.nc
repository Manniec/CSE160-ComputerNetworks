//---INCLUDE---//

//---MODULE---//
module FloodingP{

    //PROVIDES
    provides interface Flooding;

    //USES
    //uses interface SimpleSend as Sender;
    uses interface NeighborDiscover;
    
    uses interface Hashmap<uint16_t> as Cache; //table of nodes and most recent seq number
    uses interface List<uint16_t> as NeighborsList;
    
}

//---IMPLEMENTATION---//
implementation{

    // Define functions
     bool isNewPacket(uint16_t node, uint16_t sequenceNum);


    command error_t Flooding.addToCache(uint16_t node, uint16_t sequenceNum){
        if(isNewPacket(node, sequenceNum)){
            call Cache.remove(node);
            call Cache.insert(node, sequenceNum);
            return SUCCESS;
        }
        return FAIL;
    }

    // Get latest sequence number received from a node
    command uint16_t Flooding.getLastSeq(uint16_t node){
        // Check if node exists in cache
        if (call Cache.contains(node)){
            return call Cache.get(node);
        } 
        return 0; // Return zero if node doesn't exist yet in cache
    }
    
    bool isNewPacket(uint16_t node, uint16_t sequenceNum){
        if((call Cache.contains(node)) && (sequenceNum <= call Cache.get(node))){
            return FALSE;
        }
        return TRUE;

    }

}