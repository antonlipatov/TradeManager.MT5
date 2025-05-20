//+------------------------------------------------------------------+
//|                                                       Helper.mqh |
//+------------------------------------------------------------------+
enum CustomEvents{
   PriceUpdate_EVENT = 410,
   DeleteLevel_EVENT = 220,
   UpdateTextLevel_EVENT = 420 
};
class Helper{
   private:
   public:
      Helper();
     ~Helper();
     static bool IsObjectCreated(string objName);
     static datetime GetEndOfDay();

};
Helper::Helper(){
}
Helper::~Helper(){
}
bool Helper::IsObjectCreated(string objName){
   if(ObjectFind(0, objName) < 0) return false;
   return true;
}
datetime Helper::GetEndOfDay(void){
   datetime now = TimeCurrent();
   MqlDateTime timeStruct;
   TimeToStruct(now, timeStruct);
   timeStruct.hour = 23;
   timeStruct.min = 59;
   timeStruct.sec = 59;
   return StructToTime(timeStruct);
}
