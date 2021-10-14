/*
 * ANDES Lab - University of California, Merced
 * This class provides the basic functions of a network node.
 *
 * @author UCM ANDES Lab
 * @date   2013/09/03
 *
 */
#include <Timer.h>
#include "includes/command.h"
#include "includes/packet.h"
#include "includes/CommandMsg.h"
#include "includes/sendInfo.h"
#include "includes/channels.h"

module NodeP{
   uses interface Boot;

   uses interface SplitControl as AMControl;
   uses interface Receive;

   // Add Flooding module
   uses interface Flooding;

   // Add Neighbors module
   uses interface NeighborDiscover;
   uses interface List<uint16_t> as NeighborsList;
   
   uses interface SimpleSend as Sender;

   uses interface CommandHandler;
}

implementation{
   pack sendPackage;
   
   uint8_t msgPayload = 0;
   int i;
   uint32_t* neighborsList;
   uint32_t neighborTimerRefresh = 300000;

   // Prototypes
   void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t Protocol, uint16_t seq, uint8_t *payload, uint8_t length);

   //initialize Neighbor Discovery functions


   event void Boot.booted(){
      call AMControl.start();

      dbg(GENERAL_CHANNEL, "Booted\n");
   }


   //event void neighborTimer.fired(){
   //   // Broadcast neighbor request
   //   makePack(&sendPackage, TOS_NODE_ID, AM_BROADCAST_ADDR, 1, 0, 0, & msgPayload ,PACKET_MAX_PAYLOAD_SIZE);
   //   call Sender.send(sendPackage, AM_BROADCAST_ADDR);

   //}

   event void AMControl.startDone(error_t err){
      if(err == SUCCESS){
         dbg(GENERAL_CHANNEL, "Radio On\n");
      }else{
         //Retry until successful
         call AMControl.start();
      }
   }

   event void AMControl.stopDone(error_t err){}

   event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
      dbg(GENERAL_CHANNEL, "Packet Received\n");
      if(len==sizeof(pack)){
         pack* myMsg=(pack*) payload;
         dbg(GENERAL_CHANNEL, "Package Payload: %s\n", myMsg->payload);

         //Check if is Neighbor Discovery request
         //if(myMsg->dest == AM_BROADCAST_ADDR){
            dbg(NEIGHBOR_CHANNEL, "Received neighbor request ping from node %s\n", myMsg->src);

         //   //Update neighbor table
         //   call NeighborDiscover.updateNeighborsTable(myMsg->src, myMsg->seq);

            //Change payload to differentiate
         //   msgPayload ++;

            //Create response message & send
         //   makePack(&sendPackage, TOS_NODE_ID, myMsg->src, 1, 1, 0, &msgPayload ,PACKET_MAX_PAYLOAD_SIZE);
         //   call Sender.send(sendPackage, myMsg->src);
         //   return msg;
         //}

         //Check if is Neighbor Discovery response 
         //if((myMsg->dest == TOS_NODE_ID) && (myMsg->protocol == 1)){
         //   dbg(NEIGHBOR_CHANNEL, "Received neighbor response ping from node %s\n", myMsg->src);

         //   //Update neighbor table
         //   call NeighborDiscover.updateNeighborsTable(myMsg->src, myMsg->seq);

         //   return msg;
         //}

         //Check if is Flooding message
         //if((myMsg->dest == TOS_NODE_ID) && (myMsg->protocol == 0)){
         //   dbg(FLOODING_CHANNEL, "Received Flooding message from node %s\n", myMsg->src);

         //   // Check against & Save to cache
         //   if (call Flooding.addToCache(myMsg->src, myMsg->seq) == SUCCESS){

         //      // Forward the packet
         //      myMsg->TTL = (myMsg->TTL) - 1;
               
         //      makePack(&sendPackage, myMsg->src, 0, myMsg->TTL, myMsg->protocol, myMsg->seq, &msgPayload, PACKET_MAX_PAYLOAD_SIZE);

         //      //Flood the message to all neighbors
         //      neighborsList = call NeighborDiscover.getNeighbors(); // Get list of neighbors
         //      for(i = 0; i < call NeighborDiscover.getNeighborsCount(); i++){
         //         sendPackage.dest = neighborsList[i];
         //         call Sender.send(sendPackage, neighborsList[i]);
         //      }

         //   }

         //   return msg;
         //}
         return msg;

      }
      dbg(GENERAL_CHANNEL, "Unknown Packet Type %d\n", len);
      return msg;
   }

   event void CommandHandler.ping(uint16_t destination, uint8_t *payload){
      dbg(GENERAL_CHANNEL, "PING EVENT \n");
      makePack(&sendPackage, TOS_NODE_ID, destination, 0, 0, 0, payload, PACKET_MAX_PAYLOAD_SIZE);
      call Sender.send(sendPackage, destination);
     
   }

   event void CommandHandler.printNeighbors(){
         // Get list of neighbors
         neighborsList = call NeighborDiscover.getNeighbors();
         for(i = 0; i < call NeighborDiscover.getNeighborsCount(); i++){
            dbg(NEIGHBOR_CHANNEL, "%s \n", neighborsList[i]);
         }
   }

   event void CommandHandler.printRouteTable(){}

   event void CommandHandler.printLinkState(){}

   event void CommandHandler.printDistanceVector(){}

   event void CommandHandler.setTestServer(){}

   event void CommandHandler.setTestClient(){}

   event void CommandHandler.setAppServer(){}

   event void CommandHandler.setAppClient(){}

   void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length){
      Package->src = src;
      Package->dest = dest;
      Package->TTL = TTL;
      Package->seq = seq;
      Package->protocol = protocol;
      memcpy(Package->payload, payload, length);
   }
}
