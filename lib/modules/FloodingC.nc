//---INCLUDE---//

//---CONFIG---//
configuration FloodingC{

    //PROVIDES
    provides interface Flooding;

}

//---IMPLEMENT---//
implementation{

    //Wire to Flooding in module file
    components FloodingP;
    Flooding = FloodingP.Flooding;

    components new HashmapC(uint16_t, 20) as Cache;
    FloodingP.Cache -> Cache;


}