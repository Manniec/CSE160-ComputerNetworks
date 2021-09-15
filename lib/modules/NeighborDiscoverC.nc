//---INCLUDE---//

//---CONFIG---//
configuration{

    //PROVIDES
    Provides interface Neighbors;

    //USES
}

//---IMPLEMENT---//
implementation{

    //Wire Flooding to Flooding in module file
    components NeighborDiscoverP;
    Neighbors = NeighborDiscoverP.Neighbors;

}