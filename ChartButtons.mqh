//+------------------------------------------------------------------+
//|                                                 ChartButtons.mqh |
//+------------------------------------------------------------------+
class ChartButtons{
   private:
      bool setOrderButtonClicked;
      bool setOrderButtonClickedEvent;
      bool setSLTPButtonClicked;
      bool setSLTPButtonClickedEvent;
      //Set order button
      CButton btnSetOrder;
      //Cancel order button
      CButton btnCancelOrders;
      //Close positions button
      CButton btnClosePositions;
      //set sl button
      CButton btnSetSL;
      //set tp button
      CButton btnSetTP;
   public:
      ChartButtons();
      ~ChartButtons();
      bool CreateSetOrderButton();
      bool DeleteAll();
      bool DeleteSetOrderButton();
};

ChartButtons::ChartButtons(){
   setOrderButtonClicked = false;
   setOrderButtonClickedEvent = false;
   setSLTPButtonClicked = false;
   setSLTPButtonClickedEvent = false;
}
ChartButtons::~ChartButtons(){
   DeleteSetOrderButton();
}
bool ChartButtons::CreateSetOrderButton(void){
   if(!Helper::IsObjectCreated(SetOrderButton)){
      btnSetOrder.Create(0, SetOrderButton, 0, 400,5,500,30);
      btnSetOrder.ColorBackground(clrWhite);
      btnSetOrder.Text("Set Order");
      ChartRedraw(0);
      return true;
   }
   return false;
}
bool ChartButtons::DeleteSetOrderButton(void){
   if(!Helper::IsObjectCreated(SetSLButton)) return false;
   btnSetOrder.Destroy();
   ChartRedraw(0);
   return true;  
}
bool ChartButtons::DeleteAll(void){
   DeleteSetOrderButton();
   return true;
}