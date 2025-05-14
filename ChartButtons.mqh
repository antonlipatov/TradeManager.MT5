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
class ChartButtons{
   private:
      bool _setOrderButtonClicked;
      bool _setOrderButtonClickedEvent;
      bool _setSLTPButtonClicked;
      bool _setSLTPButtonClickedEvent;
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
      bool createSetOrderButton();
      bool createCancelOrdersButton();
      bool createClosePositionsButton();
      void setOrderButtonClick();
      void cancelOrdersButtonClick();
      void closePositionsButtonClick();
      bool deleteSetOrderButton();
      bool deleteCancelOrderButton();
      bool deleteClosePositionsButton();
   public:
      ChartButtons();
      ~ChartButtons();
      void OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
      void OnTradeEvent();
      void CreateChartButtons();
      bool UpdateSetOrderButton();
      bool DeleteAll();

};

ChartButtons::ChartButtons(){
   _setOrderButtonClicked = false;
   _setOrderButtonClickedEvent = false;
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
   }
}
void ChartButtons::OnTradeEvent(void){
   if(TradeHelper::CountOpenOrders() > 0 && !Helper::IsObjectCreated(CancelOrdersButton))
      createCancelOrdersButton();
   if(TradeHelper::CountOpenOrders() <= 0 && Helper::IsObjectCreated(CancelOrdersButton))
      deleteCancelOrderButton();
   if(TradeHelper::CountOpenPositions() > 0 && !Helper::IsObjectCreated(ClosePositionsButton))
      createClosePositionsButton();
   if(TradeHelper::CountOpenPositions() <= 0 && Helper::IsObjectCreated(ClosePositionsButton))
      deleteClosePositionsButton();  
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
void ChartButtons::CreateChartButtons(void){
   createSetOrderButton();
   if(TradeHelper::CountOpenOrders() > 0) createCancelOrdersButton();
   if(TradeHelper::CountOpenPositions() > 0) createClosePositionsButton();
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
bool ChartButtons::DeleteAll(void){
   deleteSetOrderButton();
   deleteCancelOrderButton();
   deleteClosePositionsButton();
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