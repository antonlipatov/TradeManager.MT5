//+------------------------------------------------------------------+
//|                                                       Helper.mqh |
//+------------------------------------------------------------------+
class Helper{
   private:
   public:
      Helper();
     ~Helper();
     static bool IsObjectCreated(string objName);
};
Helper::Helper(){
}

Helper::~Helper(){
}

bool Helper::IsObjectCreated(string objName){
   if(ObjectFind(0, objName) < 0) return false;
   return true;
}