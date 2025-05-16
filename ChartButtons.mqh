//+------------------------------------------------------------------+
//|                                                 ChartButtons.mqh |
//+------------------------------------------------------------------+
#include  <Controls/Button.mqh>
//Set order button
#define SetOrderButton "Set Order Button"
//Cancel Orders button
#define  CancelOrdersButton "Cancel Orders Button"
//close positions button
#define ClosePositionsButton "Close Positions Button"
//set SL button
#define SetSLButton "Set SL Button"
//set TP button
#define SetTPButton "Set TP Button"
//modify positions button
#define ModifyPositionsButton "Modify Positions Button"
class ChartButtons{
   private:
      bool _setOrderButtonClicked;
      bool _setOrderButtonClickedEvent;
      bool _setSLTPButtonClicked;
      bool _setSLTPButtonClickedEvent;
      bool _modifyPositionsButtonClicked;
      bool _modifyPositionsButtonClickedEvent;
      //Set order button
      CButton _btnSetOrder;
      //Cancel order button
      CButton _btnCancelOrders;
      //Close positions button
      CButton _btnClosePositions;
      //set sl button
      CButton _btnSetSL;
      //set tp button
      CButton _btnSetTP;
      //modify positions button
      CButton _btnModifyPositions;
      bool createSetOrderButton();
      bool createCancelOrdersButton();
      bool createClosePositionsButton();
      bool createModifyPositionsButton();
      bool createSetSLButton();
      bool createSetTPButton();
      void setOrderButtonClick();
      void cancelOrdersButtonClick();
      void closePositionsButtonClick();
      void modifyPositionsButtonClick();
      void setSLButtonClick();
      void setTPButtonClick();
      bool deleteSetOrderButton();
      bool deleteCancelOrderButton();
      bool deleteClosePositionsButton();
      bool deleteModifyPositionsButton();
      bool deleteSetSLButton();
      bool deleteSetTPButton();
   public:
      ChartButtons();
      ~ChartButtons();
      void OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
      void OnTradeEvent();
      void CreateChartButtons();
      bool UpdateSetOrderButton();
      bool UpdateModifyPositionsButton();
      bool DeleteAll();

};

ChartButtons::ChartButtons(){
   _setOrderButtonClicked = false;
   _setOrderButtonClickedEvent = false;
   _modifyPositionsButtonClicked = false;
   _modifyPositionsButtonClickedEvent = false;
   _setSLTPButtonClicked = false;
   _setSLTPButtonClickedEvent = false;
}
ChartButtons::~ChartButtons(){
   DeleteAll();
}
void ChartButtons::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   if(id == CHARTEVENT_OBJECT_CLICK){
      if(sparam == _btnSetOrder.Name()) setOrderButtonClick();
      if(sparam == _btnCancelOrders.Name()) cancelOrdersButtonClick();
      if(sparam == _btnClosePositions.Name()) closePositionsButtonClick();
      if(sparam == _btnModifyPositions.Name()) modifyPositionsButtonClick();
      if(sparam == _btnSetSL.Name()) setSLButtonClick();
      if(sparam == _btnSetTP.Name()) setTPButtonClick();
   }
   if(id == CHARTEVENT_CLICK){
      //set entry line
      if(_setOrderButtonClicked){
         if(_setOrderButtonClickedEvent){
            _setOrderButtonClickedEvent = false;
            return;
         }
         _setOrderButtonClicked = false;
         tradeLevels.PlacingEntryLevel = true;
         UpdateSetOrderButton();  
      }
      //set modify positions line
      if(_modifyPositionsButtonClicked){
         if(_modifyPositionsButtonClickedEvent){
            _modifyPositionsButtonClickedEvent = false;
            return;
         }
         _modifyPositionsButtonClicked = false;
         tradeLevels.PlacingModifyPositionsLevel = true;
         
      }
   }
}
void ChartButtons::OnTradeEvent(void){
   if(TradeHelper::CountOpenOrders() > 0 && !Helper::IsObjectCreated(CancelOrdersButton))
      createCancelOrdersButton();
   if(TradeHelper::CountOpenOrders() <= 0 && Helper::IsObjectCreated(CancelOrdersButton))
      deleteCancelOrderButton();
   if(TradeHelper::CountOpenPositions() > 0){  
      if(!Helper::IsObjectCreated(ClosePositionsButton)) createClosePositionsButton();
      if(!Helper::IsObjectCreated(ModifyPositionsButton)) createModifyPositionsButton();
      //if(!Helper::IsObjectCreated(SetSLButton)) createSetSLButton();
      //if(!Helper::IsObjectCreated(SetTPButton)) createSetTPButton();
   } 
   if(TradeHelper::CountOpenPositions() <= 0){
      if(Helper::IsObjectCreated(ClosePositionsButton)) deleteClosePositionsButton();
      if(Helper::IsObjectCreated(ModifyPositionsButton)) deleteModifyPositionsButton();
      //if(Helper::IsObjectCreated(SetSLButton)) deleteSetSLButton();
      //if(Helper::IsObjectCreated(SetTPButton)) deleteSetTPButton();
   }
}
bool ChartButtons::createSetOrderButton(void){
   if(!Helper::IsObjectCreated(SetOrderButton)){
      _btnSetOrder.Create(0, SetOrderButton, 0, 400,5,500,30);
      _btnSetOrder.ColorBackground(clrWhite);
      _btnSetOrder.Text("Set Order");
      ChartRedraw(0);
      return true;
   }
   return false;
}
bool ChartButtons::createCancelOrdersButton(void){
   if(!Helper::IsObjectCreated(CancelOrdersButton)){
      _btnCancelOrders.Create(0, CancelOrdersButton, 0, 505,5,645,30);
      _btnCancelOrders.ColorBackground(clrLightCoral);
      _btnCancelOrders.Text("Cancel Orders");
      ChartRedraw(0);
      return true;
   }
   return false;
}
bool ChartButtons::createClosePositionsButton(void){
   if(!Helper::IsObjectCreated(ClosePositionsButton)){
      _btnClosePositions.Create(0, ClosePositionsButton, 0, 650,5,790,30);
      _btnClosePositions.Color(clrWhite);
      _btnClosePositions.ColorBackground(clrDarkRed);
      _btnClosePositions.Text("Close Positions");
      ChartRedraw(0);
      return true;
   }
   return false;
}
bool ChartButtons::createModifyPositionsButton(void){
   if(!Helper::IsObjectCreated(ModifyPositionsButton)){
      _btnModifyPositions.Create(0, ModifyPositionsButton, 0, 795,5,945,30);
      _btnModifyPositions.Color(clrBlack);
      _btnModifyPositions.ColorBackground(clrWheat);
      _btnModifyPositions.Text("Modify Positions");
      ChartRedraw(0);
      return true;
   }
   return false; 
}
bool ChartButtons::createSetSLButton(void){
   if(!Helper::IsObjectCreated(SetSLButton)){
      _btnSetSL.Create(0, SetSLButton, 0, 795,5,860,30);
      _btnSetSL.Color(clrBlack);
      _btnSetSL.ColorBackground(clrLightCoral);
      _btnSetSL.Text("Set SL");
      ChartRedraw(0);
      return true;
   }
   return false; 
}
bool ChartButtons::createSetTPButton(void){
   if(!Helper::IsObjectCreated(SetTPButton)){
      _btnSetTP.Create(0, SetTPButton, 0, 865,5,930,30);
      _btnSetTP.Color(clrBlack);
      _btnSetTP.ColorBackground(clrLightGreen);
      _btnSetTP.Text("Set TP");
      ChartRedraw(0);
      return true;
   }
   return false; 
}
void ChartButtons::CreateChartButtons(void){
   createSetOrderButton();
   if(TradeHelper::CountOpenOrders() > 0) createCancelOrdersButton();
   if(TradeHelper::CountOpenPositions() > 0){
      createClosePositionsButton();
      createModifyPositionsButton();
      //createSetSLButton();
      //createSetTPButton();
   } 
}
bool ChartButtons::UpdateSetOrderButton(void){
   if(tradeLevels.PlacingEntryLevel){
      _btnSetOrder.ColorBackground(clrGray);
      ChartRedraw(0);
      return true;
      }
   if(!tradeLevels.PlacingStoplossLevel){
      _btnSetOrder.ColorBackground(clrWhite);
      ChartRedraw(0);
      return true;
   }
   return false;
}
bool ChartButtons::UpdateModifyPositionsButton(void){
   if(tradeLevels.PlacingModifyPositionsLevel){
      _btnModifyPositions.ColorBackground(clrGray);
      ChartRedraw(0);
      return true;
      }
   if(!tradeLevels.PlacingModifyPositionsLevel){
      _btnModifyPositions.ColorBackground(clrWheat);
      ChartRedraw(0);
      return true;
   }
   return false;   
}
bool ChartButtons::deleteSetOrderButton(void){
   if(!Helper::IsObjectCreated(SetSLButton)) return false;
   _btnSetOrder.Destroy();
   ChartRedraw(0);
   return true;  
}
bool ChartButtons::deleteCancelOrderButton(void){
   if(!Helper::IsObjectCreated(CancelOrdersButton)) return false;
   _btnCancelOrders.Destroy();
   ChartRedraw(0);
   return true; 
}
bool ChartButtons::deleteClosePositionsButton(void){
   if(!Helper::IsObjectCreated(ClosePositionsButton)) return false;
   _btnClosePositions.Destroy();
   ChartRedraw(0);
   return true; 
}
bool ChartButtons::deleteModifyPositionsButton(void){
   if(!Helper::IsObjectCreated(ModifyPositionsButton)) return false;
   _btnModifyPositions.Destroy();
   ChartRedraw(0);
   return true;
}
bool ChartButtons::deleteSetSLButton(void){
   if(!Helper::IsObjectCreated(SetSLButton)) return false;
   _btnSetSL.Destroy();
   ChartRedraw(0);
   return true;
}
bool ChartButtons::deleteSetTPButton(void){
   if(!Helper::IsObjectCreated(SetTPButton)) return false;
   _btnSetTP.Destroy();
   ChartRedraw(0);
   return true;
}
bool ChartButtons::DeleteAll(void){
   deleteSetOrderButton();
   deleteCancelOrderButton();
   deleteClosePositionsButton();
   deleteModifyPositionsButton();
   deleteSetSLButton();
   deleteSetTPButton();
   return true;
}
void ChartButtons::setOrderButtonClick(void){
   _setOrderButtonClicked = !_setOrderButtonClicked;
   _setOrderButtonClickedEvent = true;
   if(_setOrderButtonClicked) _btnSetOrder.ColorBackground(clrLightBlue);
   else _btnSetOrder.ColorBackground(clrWhite);
   ChartRedraw(0); 
}
void ChartButtons::cancelOrdersButtonClick(void){
   TradeHelper::CancelOrders();   
}
void ChartButtons::closePositionsButtonClick(void){
   TradeHelper::ClosePositions();
}
void ChartButtons::modifyPositionsButtonClick(void){
   _modifyPositionsButtonClicked = !_modifyPositionsButtonClicked;
   _modifyPositionsButtonClickedEvent = true;
   if(_modifyPositionsButtonClicked) {
      _btnModifyPositions.ColorBackground(clrLightBlue);
   }
   else {
      _btnModifyPositions.ColorBackground(clrWheat);
   }
   ChartRedraw(0);
}
void ChartButtons::setSLButtonClick(void){

}
void ChartButtons::setTPButtonClick(void){
}