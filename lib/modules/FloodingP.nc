//---INCLUDE---//

//---MODULE---//
module FloodingP{

    //PROVIDES
    provides interface Flooding;

    //USES
    uses interface SimpleSend;
    uses interface NeighborDiscover;
    uses interface Packet;
    uses interface AMPacket;
    
}

//---IMPLEMENTATION---//
implementation{

    // Define cache item for latest packet
    typedef struct cache{
        uint16_t seq;
        uint16_t local_src; //node the packet received from
    }cache;

    //Implement initial Flooding using SimpleSendP.nc
    command error_t Flooding.flood(pack msg){
        return FAIL;
    }

    //Implement Flooding forwarding using SimpleSendP.nc
    //event void Flooding.forward(pack msg){}

    //void checkCache(sendInfo* input){}

    // bool isNewPacket(sendInfo* input){}

    

}