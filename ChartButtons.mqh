//+------------------------------------------------------------------+
//|                                                 ChartButtons.mqh |
//+------------------------------------------------------------------+
class ChartButtons{
   private:
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
};

ChartButtons::ChartButtons(){
}
ChartButtons::~ChartButtons(){
}