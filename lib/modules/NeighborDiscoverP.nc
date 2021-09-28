//---INCLUDE---//

#include "includes/channels.h"

//---MODULE---//
module NeighborDiscoverP{

    //PROVIDES

    //specify Flooding task as an interface (so Node Module can call it)
    provides interface NeighborDiscover;

    //USES
    uses interface Timer<TMilli> as neighborTimer;

    uses interface Hashmap<sendTimer*> as NeighborsTable; //table of nodes with time value

    uses interface Receive;

    
}

//---IMPLEMENTATION---//
implementation{

    //milliseconds waited before next ping
    uint16_t pingFreq = 1000; 

    // Prototypes
    void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t Protocol, uint16_t seq, uint8_t *payload, uint8_t length);
    void pingNeighbors();

    command error_t NeighborDiscover.start(){
        if (call neighborTimer.isRunning() == FALSE){
            post discoverNeighbors();
            //reset timers
            call sendTimer.startOneShot(10000);
        }
    
    }
   

    task void discoverNeighbors(){
        if (NeighborsTable.isEmpty()){

        }else{

        }
        //copy list of neighbors
        uint32_t* listNeighbors = call NeighborsTable.getKeys();
        
        uint32_t* oldNeighbors
        for(oldNeighbor = 0){

            //remove outdated neighbor from table
            call NeighborsTable.remove();

            //send request ping to neighbor
            call NeighborDiscover.requestPing();
        }
    }

    void manageNeighborsTable(){
        if(call pingTimer.isRunning == FALSE){
            requestPing();
        }
    }

    task error_t requestPing(){
        call SimpleSend.send()
    }

    command error_t responsePing(){

    }

    event void Receive.receive(message_t* msg, ){
        call NeighborsTable.insert()
    }

    event void CommandHandler.ping(uint16_t destination, uint8_t *payload){
        dbg(NEIGHBOR_CHANNEL, ")
    }

    void deleteNeighbors(){
        call neighborsTable.getKeys();
        for ()
    }

    
}