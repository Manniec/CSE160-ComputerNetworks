//---INCLUDE---//
#include "../../includes/neighborStats.h"

//---CONFIG---//
configuration NeighborDiscoverC{

    //PROVIDES
    provides interface NeighborDiscover;

    //USES
}

//---IMPLEMENT---//
implementation{

    //Wire NeighborDiscoverP to NeighborDiscover in module file
    components NeighborDiscoverP;
    NeighborDiscover = NeighborDiscoverP.NeighborDiscover;

    components FloodingC;
    NeighborDiscoverP.Flooding -> FloodingC;

    components new HashmapC(neighborStats, 20);
    NeighborDiscoverP.NeighborsTable -> HashmapC;

    //Wire timer for when to resend neighbor discover request/ping
    components new TimerMilliC() as requestTimer;
    NodeP.neighborTimer -> requestTimer;

    //Wire sender
    components new SimpleSendC(AM_PACK);
    NodeP.Sender -> SimpleSendC

    

}