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
      
      void setOrderButtonClick();
   public:
      ChartButtons();
      ~ChartButtons();
      void OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
      void OnTradeEvent();
      bool CreateSetOrderButton();
      bool UpdateSetOrderButton();
      bool DeleteAll();
      bool DeleteSetOrderButton();
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
}
bool ChartButtons::CreateSetOrderButton(void){
   if(!Helper::IsObjectCreated(SetOrderButton)){
      _btnSetOrder.Create(0, SetOrderButton, 0, 400,5,500,30);
      _btnSetOrder.ColorBackground(clrWhite);
      _btnSetOrder.Text("Set Order");
      ChartRedraw(0);
      return true;
   }
   return false;
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
bool ChartButtons::DeleteSetOrderButton(void){
   if(!Helper::IsObjectCreated(SetSLButton)) return false;
   _btnSetOrder.Destroy();
   ChartRedraw(0);
   return true;  
}
bool ChartButtons::DeleteAll(void){
   DeleteSetOrderButton();
   return true;
}
void ChartButtons::setOrderButtonClick(void){
   _setOrderButtonClicked = !_setOrderButtonClicked;
   _setOrderButtonClickedEvent = true;
   if(_setOrderButtonClicked) _btnSetOrder.ColorBackground(clrLightBlue);
   else _btnSetOrder.ColorBackground(clrWhite);
   ChartRedraw(0); 
}