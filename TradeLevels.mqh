//+------------------------------------------------------------------+
//|                                                  TradeLevels.mqh |
//+------------------------------------------------------------------+
#include "EntryLevel.mqh/"
#include "StoplossLevel.mqh/"
class TradeLevels{
   private:
      EntryLevel _entryLevel;
      StoplossLevel _stoplossLevel;
      //
      int _prevMouseState;
      int _mouseLeftButtonDownX1;
      int _mouseLeftButtonDownY1;
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
   _prevMouseState = 0;
   _mouseLeftButtonDownX1 = 0;
   _mouseLeftButtonDownY1 = 0; 
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
   _entryLevel.OnEvent(id, lparam, dparam, sparam);
   _stoplossLevel.OnEvent(id, lparam, dparam, sparam);
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
   if(id == CHARTEVENT_MOUSE_MOVE){
      int mouseXDistance = (int)lparam;
      int mouseYDistance = (int)dparam;
      int mouseState = (int)sparam;
      //Add mouse move to entry and stoploss levels
      if(_entryLevel.IsLevelExict() && _stoplossLevel.IsLevelExict()){
         //entry level
         //line mover
         int xDistance_EntryMover = _entryLevel.GetMoverXDistance();
         int yDistance_EntryMover = _entryLevel.GetMoverYDistance();
         int xSize_EntryMover = _entryLevel.GetMoverXSize();
         int ySize_EntryMover = _entryLevel.GetMoverYSize();
         //send button
         int xDistance_SendOrder = _entryLevel.GetSendOrderXDistance();
         int yDistance_SendOrder = _entryLevel.GetSendOrderYDistance();
         int xSize_SendOrder = _entryLevel.GetSendOrderXSize();
         int ySize_SendOrder = _entryLevel.GetSendOrderYSize();
         //risk button
         int xDistance_RiskProcent = _entryLevel.GetRiskButtonXDistance();
         int yDistance_RiskProcent = _entryLevel.GetRiskButtonYDistance();
         int xSize_RiskProcent = _entryLevel.GetRiskButtonXSize();
         int ySize_RiskProcent = _entryLevel.GetRiskButtonYSize();
         //cancel selection button
         int xDistance_CancelSelection = _entryLevel.GetCancelButtonXDistance();
         int yDistance_CancelSelection = _entryLevel.GetCancelButtonYDistance();
         int xSize_CancelSelection = _entryLevel.GetCancelButtonXSize();
         int ySize_CancelSelection = _entryLevel.GetCancelButtonYSize();
         //entry info label
         int xDistance_EntryLabel = _entryLevel.GetLabelXDistance();
         int yDistance_EntryLabel = _entryLevel.GetLabelYDistance();
         int xSize_EntryLabel = _entryLevel.GetLabelXSize();
         int ySize_EntryLabel = _entryLevel.GetLabelYSize();
         //stoploss level
         //line mover
         int xDistance_StoplossMover = _stoplossLevel.GetMoverXDistance();
         int yDistance_StoplossMover = _stoplossLevel.GetMoverYDistance();
         int xSize_StoplossMover = _stoplossLevel.GetMoverXSize();
         int ySize_StoplossMover = _stoplossLevel.GetMoverYSize();
         //stoploss info label
         int xDistance_StoplossLabel = _stoplossLevel.GetLabelXDistance();
         int yDistance_StoplossLabel = _stoplossLevel.GetLabelYDistance();
         int xSize_StoplossLabel = _stoplossLevel.GetLabelXSize();
         int ySize_StoplossLabel = _stoplossLevel.GetLabelYSize();
         if(_prevMouseState == 0 && mouseState == 1){
            _mouseLeftButtonDownX1 = mouseXDistance;
            _mouseLeftButtonDownY1 = mouseYDistance;
            //entry mover
            _entryLevel.MoverMLBD_XD = xDistance_EntryMover;
            _entryLevel.MoverMLBD_YD = yDistance_EntryMover;
            //stoploss mover
            _stoplossLevel.MoverMLBD_XD = xDistance_StoplossMover;
            _stoplossLevel.MoverMLBD_YD = yDistance_StoplossMover;
            //send button
            _entryLevel.SendButtonMLBD_XD = xDistance_SendOrder;
            _entryLevel.SendButtonMLBD_YD = yDistance_SendOrder;
            //risk button
            _entryLevel.RiskButtonMLBD_XD = xDistance_RiskProcent;
            _entryLevel.RiskButtonMLBD_YD = yDistance_RiskProcent;
            //Cancel selection button
            _entryLevel.CancelSelectionButtonMLBD_XD = xDistance_CancelSelection;
            _entryLevel.CancelSelectionButtonMLBD_YD = yDistance_CancelSelection;
            //entry info label
            _entryLevel.LabelMLBD_XD = xDistance_EntryLabel;
            _entryLevel.LabelMLBD_YD = yDistance_EntryLabel;
            //stoploss info label
            _stoplossLevel.LabelMLBD_XD = xDistance_StoplossLabel;
            _stoplossLevel.LabelMLBD_YD = yDistance_StoplossLabel;
            if(mouseXDistance >= xDistance_EntryMover && 
               mouseXDistance <= xDistance_EntryMover + xSize_EntryMover &&
               mouseYDistance >= yDistance_EntryMover && 
               mouseYDistance <= yDistance_EntryMover + ySize_EntryMover){
               //we are inside the entry line mover, we can start dragging obj entry level
               _entryLevel.MovingState = true;
            }
            if(mouseXDistance >= xDistance_StoplossMover && 
               mouseXDistance <= xDistance_StoplossMover + xSize_StoplossMover &&
               mouseYDistance >= yDistance_StoplossMover && 
               mouseYDistance <= yDistance_StoplossMover + ySize_StoplossMover){
               //we are inside the stoploss line mover, we can start dragging obj stoploss level
               _stoplossLevel.MovingState = true;
            }
         }
         if(_entryLevel.MovingState){
               _entryLevel.LevelMove(mouseXDistance, mouseYDistance, _mouseLeftButtonDownX1, _mouseLeftButtonDownY1, xDistance_EntryMover, yDistance_EntryMover, ySize_EntryMover);
               UpdateLevelsLabelText(_entryLevel.GetPrice(), _stoplossLevel.GetPrice());
               ChartRedraw(0);
         }
         if(_stoplossLevel.MovingState){
            _stoplossLevel.LevelMove(mouseXDistance, mouseYDistance, _mouseLeftButtonDownX1, _mouseLeftButtonDownY1,xDistance_StoplossMover, yDistance_StoplossMover, ySize_StoplossMover);
            UpdateLevelsLabelText(_entryLevel.GetPrice(), _stoplossLevel.GetPrice());
            ChartRedraw(0);
         }
         if(mouseState == 0){
         _entryLevel.MovingState = false;
         _stoplossLevel.MovingState = false;
         ChartSetInteger(0, CHART_MOUSE_SCROLL, true);
         }
         _prevMouseState = mouseState;
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