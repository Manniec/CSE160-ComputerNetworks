//---INCLUDE---//

//---Config---//
configuration{

    //PROVIDES

    Provides interface Flooding;

    //USES
}

//---IMPLEMENTATION---//
implementation{

    //Wire Flooding to Flooding in module file
    components FloodingP;
    Flooding = FloodingP.Flooding;

}