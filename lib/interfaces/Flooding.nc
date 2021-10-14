#include "../../includes/packet.h"
interface Flooding{
    command error_t addToCache(uint16_t node, uint16_t sequenceNum);
    command uint16_t getLastSeq(uint16_t node);
}