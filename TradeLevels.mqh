//+------------------------------------------------------------------+
//|                                                  TradeLevels.mqh |
//+------------------------------------------------------------------+
#include "EntryLevel.mqh/"
#include "StoplossLevel.mqh/"
class TradeLevels{
   private:
      EntryLevel _entryLevel;
      StoplossLevel _stoplossLevel;
      void addEntryLevelButtons();
   public:
      TradeLevels();
      ~TradeLevels();
      void OnEvent(const int id,const long& lparam,const double& dparam,const string& sparam);
      bool PlacingEntryLevel;
      bool PlacingStoplossLevel;
      bool CreateEntryLevel(long lparam, double dparam);
      bool CreateStoplossLevel(long lparam, double dparam);
      bool UpdateLevelsLabelText(double entryPrice, double stoplossPrice);
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
   if(_stoplossLevel.Create(lparam, dparam)) return true;
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
         addEntryLevelButtons();
         UpdateLevelsLabelText(entryLevelPrice, stopLevelPrice);
         chartButtons.UpdateSetOrderButton();
         return;
      }
   }
}
bool TradeLevels::DeleteLevels(void){
   if(_entryLevel.Delete() && _stoplossLevel.Delete()) return true;
   return false;
}
void TradeLevels::addEntryLevelButtons(void){
   _entryLevel.AddLevelButtons();
}
bool TradeLevels::UpdateLevelsLabelText(double entryPrice, double stoplossPrice){
   if(entryPrice == 0 || stoplossPrice == 0) return false;
   //get bid and ask price
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   string entryLabelValue, stoplossLabelValue;
   if(entryPrice < bidPrice && stoplossPrice < entryPrice){
      entryLabelValue = "Buy limit: " + (string)entryPrice;
      stoplossLabelValue = _stoplossLevel.GenerateStoplossLabelText();
      _entryLevel.UpdateLabelText(entryLabelValue);
      _stoplossLevel.UpdateLabelText(stoplossLabelValue);
   }
   if(entryPrice < bidPrice && stoplossPrice > entryPrice){
      entryLabelValue = "Sell stop: " + (string)entryPrice;
      stoplossLabelValue = _stoplossLevel.GenerateStoplossLabelText();
      _entryLevel.UpdateLabelText(entryLabelValue);
      _stoplossLevel.UpdateLabelText(stoplossLabelValue);
   }
   if(entryPrice > askPrice && stoplossPrice > entryPrice){
      entryLabelValue = "Sell limit: " + (string)entryPrice;
      stoplossLabelValue = _stoplossLevel.GenerateStoplossLabelText();
      _entryLevel.UpdateLabelText(entryLabelValue);
      _stoplossLevel.UpdateLabelText(stoplossLabelValue);
   }
   if(entryPrice > askPrice && stoplossPrice < entryPrice){
      entryLabelValue = "Buy stop: " + (string)entryPrice;
      stoplossLabelValue = _stoplossLevel.GenerateStoplossLabelText();
      _entryLevel.UpdateLabelText(entryLabelValue);
      _stoplossLevel.UpdateLabelText(stoplossLabelValue);
   }
   return true;
}