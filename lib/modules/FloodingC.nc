//---INCLUDE---//

//---CONFIG---//
configuration{

    //PROVIDES

    Provides interface Flooding;

    //USES
}

//---IMPLEMENT---//
implementation{

    //Wire Flooding to Flooding in module file
    components FloodingP;
    Flooding = FloodingP.Flooding;

}