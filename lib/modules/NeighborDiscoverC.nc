//---INCLUDE---//

//---CONFIG---//
configuration NeighborDiscoverC{

    //PROVIDES
    provides interface NeighborDiscover;

    //USES
}

//---IMPLEMENT---//
implementation{

    //Wire Flooding to Flooding in module file
    components NeighborDiscoverP;
    NeighborDiscover = NeighborDiscoverP.NeighborDiscover;

}