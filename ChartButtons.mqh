//+------------------------------------------------------------------+
//|                                                 ChartButtons.mqh |
//+------------------------------------------------------------------+
#include  <Controls/Button.mqh>
//Set order button
#define PendingOrderButton "Pending Order Button"
//Cancel Orders button
#define  CancelOrdersButton "Cancel Orders Button"
//close positions button
#define ClosePositionsButton "Close Positions Button"
//modify positions button
#define ModifyPositionsButton "Modify Positions Button"
//dot button
#define DotButton "DotButton"
class ChartButtons{
   private:
      bool _pendingOrderButtonClicked;
      bool _pendingOrderButtonClickedEvent;
      bool _modifyPositionsButtonClicked;
      bool _modifyPositionsButtonClickedEvent;
      bool _buttonsCollapsed;
      //Dot button
      CButton _btnDot;
      //Set order button
      CButton _btnPendingOrder;
      //Cancel order button
      CButton _btnCancelOrders;
      //Close positions button
      CButton _btnClosePositions;
      //modify positions button
      CButton _btnModifyPositions;
      bool createDotButton();
      bool createPendingOrderButton();
      bool createCancelOrdersButton();
      bool createClosePositionsButton();
      bool createModifyPositionsButton();
      bool createButtonHelper(CButton &button, 
                              string name, 
                              string textCollapsed, 
                              string textExpanded, 
                              int xOffsetCollapsed, 
                              int xOffsetExpanded, 
                              int widthCollapsed, 
                              int widthExpanded, 
                              color bgColor, 
                              color textColor = clrBlack);
      void pendingOrderButtonClick();
      void cancelOrdersButtonClick();
      void closePositionsButtonClick();
      void modifyPositionsButtonClick();
      void dotButtonClick();
      bool deleteDotButton();
      bool deletePendingOrderButton();
      bool deleteCancelOrderButton();
      bool deleteClosePositionsButton();
      bool deleteModifyPositionsButton();
      void updateDotButtonText();
      void buttonsCollapseEvent();
   public:
      ChartButtons();
      ~ChartButtons();
      void OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
      void OnTradeEvent();
      void CreateChartButtons();
      bool Delete();
};
ChartButtons::ChartButtons(){}
ChartButtons::~ChartButtons(){
  Delete();
}
void ChartButtons::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   if(id == CHARTEVENT_OBJECT_CLICK){
      if(sparam == _btnDot.Name()) dotButtonClick();
      if(sparam == _btnPendingOrder.Name()) pendingOrderButtonClick();
      if(sparam == _btnCancelOrders.Name()) cancelOrdersButtonClick();
      if(sparam == _btnClosePositions.Name()) closePositionsButtonClick();
      if(sparam == _btnModifyPositions.Name()) modifyPositionsButtonClick();
   }
   if(id == CHARTEVENT_CLICK){
      //set pending order level
      if(_pendingOrderButtonClicked){
         if(_pendingOrderButtonClickedEvent){
            _pendingOrderButtonClickedEvent = false;
            return;
         }
         _pendingOrderButtonClicked = false;
         app.PlacingPendingOrderLevel = true;
         _btnPendingOrder.ColorBackground(clrWhite);
         ChartRedraw(0);
      }
      
      //set modify positions level
      if(_modifyPositionsButtonClicked){
         if(_modifyPositionsButtonClickedEvent){
            _modifyPositionsButtonClickedEvent = false;
            return;
         }
         _modifyPositionsButtonClicked = false;
         app.PlacingModifyPositionsLevel = true;
         _btnModifyPositions.ColorBackground(clrWheat);
         ChartRedraw(0);
      }
   }
   if(id > CHARTEVENT_CUSTOM){
      CustomEvents event = (CustomEvents)(id - CHARTEVENT_CUSTOM);
      if(event== ButtonsCollapse_EVENT){
         if(Helper::IsObjectCreated(PendingOrderButton)){
            deletePendingOrderButton();
            createPendingOrderButton();
         }
         if(Helper::IsObjectCreated(CancelOrdersButton)){
            deleteCancelOrderButton();
            createCancelOrdersButton();
         }
         if(Helper::IsObjectCreated(ClosePositionsButton)){
            deleteClosePositionsButton();
            createClosePositionsButton();
         }
         if(Helper::IsObjectCreated(ModifyPositionsButton)){
            deleteModifyPositionsButton();
            createModifyPositionsButton();
         }
         ChartRedraw(0);   
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
   } 
   if(TradeHelper::CountOpenPositions() <= 0){
      if(Helper::IsObjectCreated(ClosePositionsButton)) deleteClosePositionsButton();
      if(Helper::IsObjectCreated(ModifyPositionsButton)) deleteModifyPositionsButton();

   }
}
bool ChartButtons::createPendingOrderButton(void){
   return createButtonHelper(_btnPendingOrder, PendingOrderButton, "PO", "Pending", 0, 0, 35, 100, clrWhite);
}
bool ChartButtons::createCancelOrdersButton(void){
   return createButtonHelper(_btnCancelOrders, CancelOrdersButton, "CO", "Cancel Orders", 40, 105, 35, 140, clrLightCoral);
}
bool ChartButtons::createClosePositionsButton(void){
   return createButtonHelper(_btnClosePositions, ClosePositionsButton, "CP", "Close Positions", 80, 250, 35, 140, clrDarkRed, clrWhite);
}
bool ChartButtons::createModifyPositionsButton(void){
   return createButtonHelper(_btnModifyPositions, ModifyPositionsButton, "MP", "Modify Positions", 120, 395, 35, 150, clrWheat);
   if(!Helper::IsObjectCreated(ModifyPositionsButton)){
      if(!Helper::IsObjectCreated(DotButton)) return false;
      if(_buttonsCollapsed){
         _btnModifyPositions.Create(0, ModifyPositionsButton, 0, ((_btnDot.Left() +35) + 120), _btnDot.Top(), ((_btnDot.Left() +35) + 155),(_btnDot.Top() + 25));
         _btnModifyPositions.Text("MP");      
      }
      else if(!_buttonsCollapsed){
         _btnModifyPositions.Create(0, ModifyPositionsButton, 0, ((_btnDot.Left() +35) + 395), _btnDot.Top(), ((_btnDot.Left() +35) + 550), (_btnDot.Top() + 25));
         _btnModifyPositions.Text("Modify Positions");
      }
      _btnModifyPositions.Color(clrBlack);
      _btnModifyPositions.ColorBackground(clrWheat); 
      ChartRedraw(0);
      return true;
   }
   return false; 
}
bool ChartButtons::createDotButton(void){
   if(!Helper::IsObjectCreated(DotButton)){
      _btnDot.Create(0, DotButton, 0, 365,5,395,30);
      _btnDot.ColorBackground(clrGold);
      updateDotButtonText();
      ChartRedraw(0);
      return true;
   }
   return false;
}
bool ChartButtons::createButtonHelper(CButton &button,
                                      string name,
                                      string textCollapsed,
                                      string textExpanded,
                                      int xOffsetCollapsed,
                                      int xOffsetExpanded,
                                      int widthCollapsed,
                                      int widthExpanded,
                                      color bgColor,color textColor=0){
   if(!Helper::IsObjectCreated(name)){
      if(!Helper::IsObjectCreated(DotButton)) return false;
      int xPosition, width;
      string text;
      if(_buttonsCollapsed) {
         xPosition = _btnDot.Left() + 35 + xOffsetCollapsed;
         width = widthCollapsed;
         text = textCollapsed;
      } else {
         xPosition = _btnDot.Left() + 35 + xOffsetExpanded;
         width = widthExpanded;
         text = textExpanded;
      }
      button.Create(0, name, 0, xPosition, _btnDot.Top(), xPosition + width, _btnDot.Top() + 25);
      button.Text(text);
      button.ColorBackground(bgColor);
      if (textColor != clrNONE) button.Color(textColor);
      ChartRedraw(0);
      return true;
   }
   return false;
}
void ChartButtons::updateDotButtonText(void){
   if(Helper::IsObjectCreated(DotButton)) _buttonsCollapsed? _btnDot.Text(":>") : _btnDot.Text(":<");
}
void ChartButtons::CreateChartButtons(void){
   _pendingOrderButtonClicked = false;
   _pendingOrderButtonClickedEvent = false;
   _modifyPositionsButtonClicked = false;
   _modifyPositionsButtonClickedEvent = false;
   _buttonsCollapsed = false;
   createDotButton();
   createPendingOrderButton();
   if(TradeHelper::CountOpenOrders() > 0) createCancelOrdersButton();
   if(TradeHelper::CountOpenPositions() > 0){
      createClosePositionsButton();
      createModifyPositionsButton();
   } 
}
bool ChartButtons::deletePendingOrderButton(void){
   if(!Helper::IsObjectCreated(PendingOrderButton)) return false;
   _btnPendingOrder.Destroy();
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
bool ChartButtons::deleteDotButton(void){
   if(!Helper::IsObjectCreated(DotButton)) return false;
   _btnDot.Destroy();
   ChartRedraw(0);
   return true;
}
void ChartButtons::dotButtonClick(void){
   _buttonsCollapsed = !_buttonsCollapsed;
   updateDotButtonText();
   buttonsCollapseEvent();
}
void ChartButtons::pendingOrderButtonClick(void){
   _pendingOrderButtonClicked = !_pendingOrderButtonClicked;
   _pendingOrderButtonClickedEvent = true;
   if(_pendingOrderButtonClicked) _btnPendingOrder.ColorBackground(clrLightBlue);
   else _btnPendingOrder.ColorBackground(clrWhite);
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
   if(_modifyPositionsButtonClicked) _btnModifyPositions.ColorBackground(clrLightBlue);
   else _btnModifyPositions.ColorBackground(clrWheat);
   ChartRedraw(0);
}
bool ChartButtons::Delete(void){
   deleteDotButton();
   deletePendingOrderButton();
   deleteCancelOrderButton();
   deleteClosePositionsButton();
   deleteModifyPositionsButton();
   return true;
}
void ChartButtons::buttonsCollapseEvent(void){
   CustomEvents eventId = ButtonsCollapse_EVENT;
   EventChartCustom(0, (ushort)eventId, (long)_buttonsCollapsed);
}