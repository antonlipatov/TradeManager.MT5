//+------------------------------------------------------------------+
//|                                                  TradeLevels.mqh |
//+------------------------------------------------------------------+
#include "EntryLevel.mqh/"
#include "StoplossLevel.mqh/"
class TradeLevels{
   private:
      EntryLevel _entryLevel;
      StoplossLevel _StoplossLevel;
   public:
      TradeLevels();
      ~TradeLevels();
      void OnEvent(const int id,const long& lparam,const double& dparam,const string& sparam);
      bool PlacingEntryLevel;
      bool PlacingStoplossLevel;
      bool CreateEntryLevel(long lparam, double dparam);
      bool CreateStoplossLevel(long lparam, double dparam);
      bool DeleteLevels();
};
TradeLevels::TradeLevels(){ 
   PlacingEntryLevel = false;
   PlacingStoplossLevel = false;
}
TradeLevels::~TradeLevels(){
   DeleteLevels();
}
bool TradeLevels::CreateEntryLevel(long lparam, double dparam){
   if(_entryLevel.Create(lparam, dparam)) return true;
   return false;
}
bool TradeLevels::CreateStoplossLevel(long lparam,double dparam){
   if(_StoplossLevel.Create(lparam, dparam)) return true;
   return false;
}
void TradeLevels::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   if(id == CHARTEVENT_CLICK){
      if(PlacingEntryLevel) {
         CreateEntryLevel(lparam, dparam);
         PlacingEntryLevel = false;
         PlacingStoplossLevel = true;
         return;
      }
      if(PlacingStoplossLevel){
         CreateStoplossLevel(lparam, dparam);
         PlacingStoplossLevel = false;
         chartButtons.UpdateSetOrderButton();
         return;
      }
   }
}
bool TradeLevels::DeleteLevels(void){
   if(_entryLevel.Delete() && _StoplossLevel.Delete()) return true;
   return false;
}
