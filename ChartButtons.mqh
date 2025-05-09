//+------------------------------------------------------------------+
//|                                                 ChartButtons.mqh |
//+------------------------------------------------------------------+
class ChartButtons{
   private:
      bool _setOrderButtonClicked;
      bool _setOrderButtonClickedEvent;
      bool _setSLTPButtonClicked;
      bool _setSLTPButtonClickedEvent;
      bool _setStopLossLevel;
      bool _placingStopLossLevel;
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
   _setStopLossLevel = false;
   _placingStopLossLevel = false;
}
ChartButtons::~ChartButtons(){
   DeleteSetOrderButton();
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
         //TODO: Add entry level   
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
   return true;
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
   if(!Helper::IsObjectCreated(SetOrderButton)) return;
   if(_setStopLossLevel) return;
   _setOrderButtonClicked = !_setOrderButtonClicked;
   _setOrderButtonClickedEvent = true;
   if(_setOrderButtonClicked) _btnSetOrder.ColorBackground(clrLightBlue);
   else _btnSetOrder.ColorBackground(clrWhite);
   ChartRedraw(0); 
}