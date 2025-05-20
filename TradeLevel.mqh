//+------------------------------------------------------------------+
//|                                                   TradeLevel.mqh |
//+------------------------------------------------------------------+
#include  <ChartObjects\ChartObject.mqh>
#include  <ChartObjects/ChartObjectsTxtControls.mqh>
#include  <ChartObjects/ChartObjectsLines.mqh>
#include  <Controls/Button.mqh>
class TradeLevel: public CChartObject{
   private:
      //level
      #define  _Line "_Line"
      #define  _MoverButton "_MoverButton"
      #define  _Label "_Label"
      //level buttons
      #define  _SendOrderButton "_SendOrderButton"
      #define  _RiskButton "_RiskButton"
      #define  _CancelButton "_CancelButton"
      //buttons to select risk
      #define  _RiskButton1 "_RiskButton1"
      #define  _RiskButton2 "_RiskButton2"
      #define  _RiskButton3 "_RiskButton3"
      #define  _RiskButton4 "_RiskButton4"
      #define  _RiskButton5 "_RiskButton5"
      string _objectName;
      string _lineName;
      string _moverButtonName;
      string _labelName;
      string _sendOrderButtonName;
      string _riskButtonName;
      string _cancelButtonName;
      string _riskButton1Name;
      string _riskButton2Name;
      string _riskButton3Name;
      string _riskButton4Name;
      string _riskButton5Name;
      //type:
      //1: Entry level -> send order, risk, cancel
      //2: SL levele -> no buttons
      //3: Modify level -> send order, cancel
      int _type;
      int _prevMouseState;
      int _mouseLeftButtonDownX;
      int _mouseLeftButtonDownY;
      int _moverMLBD_XD;
      int _moverMLBD_YD;
      int _sendButtonMLBD_XD;
      int _sendButtonMLBD_YD;
      int _riskButtonMLBD_XD;
      int _riskButtonMLBD_YD;
      int _cancelButtonMLBD_XD;
      int _cancelButtonMLBD_YD;
      int _labelMLBD_XD;
      int _labelMLBD_YD;
      bool _movingState;
      color _levelColor;
      int _lineWidth;
      color _labelColor;
      bool _selectingRisk;
      bool _riskButtonClicked;
      double _risks[];
      double _price;
      //level
      CChartObjectTrend _line;
      CButton _btnMoverButton;
      CChartObjectLabel _label;
      //level buttons
      CButton _btnSendOrder;
      CButton _btnRisk;
      CButton _btnCancel;
      CButton _btnSelectRisk1;
      CButton _btnSelectRisk2;
      CButton _btnSelectRisk3;
      CButton _btnSelectRisk4;
      CButton _btnSelectRisk5;
      bool createLine(datetime time,double price);
      bool createMoverButton(int x, int y);
      bool createLabel(int x, int y, string text);
      bool createSendOrderButton();
      bool createRiskButton();
      bool createCancelButton();
      bool createSelectRiskButtons();
      void sendOrderButtonClick();
      void riskButtonClick();
      void cancelButtonClick();
      void selectRiskButtonClick(double newRiskValue);
      bool updateLabelText(string value);
      bool addLevelButtons();
      bool deleteLine();
      bool deleteMoverButton();
      bool deleteLabel();
      bool deleteSendOrderButton();
      bool deleteRiskButton();
      bool deleteSelectRiskButtons();
      bool deleteCancelButton();
      void updateLabelTextEvent();
      void deleteEvent();
      void updatePriceEvent();
   public:
      TradeLevel();
      TradeLevel(int type, string name, long lparam, double dparam);
      ~TradeLevel();
      bool Create(string objectName, long lparam, double dparam, int type, color levelColor, int lineWidth, color labelColor);
      bool IsDragable;
      void OnEvent(const int id,const long& lparam,const double& dparam,const string& sparam);
      bool IsLevelExist();
      bool UpdateText(string value);
      double GetPrice();
      bool SetPrice(double value);
      bool Delete();
};
TradeLevel::TradeLevel(){
}
TradeLevel::TradeLevel(int type, string name, long lparam, double dparam){
   //Create()
}
TradeLevel::~TradeLevel(){
   Delete();
}
void TradeLevel::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   if(id == CHARTEVENT_OBJECT_CLICK){
      if(sparam == _sendOrderButtonName) sendOrderButtonClick();
      if(sparam == _riskButtonName) riskButtonClick();
      if(sparam == _cancelButtonName) cancelButtonClick();
      if(sparam ==_riskButton1Name) selectRiskButtonClick(_risks[0]);
      if(sparam ==_riskButton2Name) selectRiskButtonClick(_risks[1]);
      if(sparam ==_riskButton3Name) selectRiskButtonClick(_risks[2]);
      if(sparam ==_riskButton4Name) selectRiskButtonClick(_risks[3]);
      if(sparam ==_riskButton5Name) selectRiskButtonClick(_risks[4]);
   }
   if(id == CHARTEVENT_MOUSE_MOVE){
      if(IsDragable){
         int mouseXDistance = (int)lparam;
         int mouseYDistance = (int)dparam;
         int mouseState = (int)sparam;
         //line mover
         int xDistance_Mover = Helper::IsObjectCreated(_moverButtonName) ? (int)ObjectGetInteger(0, _moverButtonName, OBJPROP_XDISTANCE): 0;
         int yDistance_Mover = Helper::IsObjectCreated(_moverButtonName) ? (int)ObjectGetInteger(0, _moverButtonName, OBJPROP_YDISTANCE): 0;
         int xSize_Mover = Helper::IsObjectCreated(_moverButtonName) ? (int)ObjectGetInteger(0, _moverButtonName, OBJPROP_XSIZE): 0;
         int ySize_Mover = Helper::IsObjectCreated(_moverButtonName) ? (int)ObjectGetInteger(0, _moverButtonName, OBJPROP_YSIZE): 0;
         //send button
         int xDistance_SendOrder = Helper::IsObjectCreated(_sendOrderButtonName) ? (int)ObjectGetInteger(0, _sendOrderButtonName, OBJPROP_XDISTANCE): 0;
         int yDistance_SendOrder = Helper::IsObjectCreated(_sendOrderButtonName) ? (int)ObjectGetInteger(0, _sendOrderButtonName, OBJPROP_YDISTANCE): 0;
         int xSize_SendOrder = Helper::IsObjectCreated(_sendOrderButtonName) ? (int)ObjectGetInteger(0, _sendOrderButtonName, OBJPROP_XSIZE): 0;
         int ySize_SendOrder = Helper::IsObjectCreated(_sendOrderButtonName) ? (int)ObjectGetInteger(0, _sendOrderButtonName, OBJPROP_YSIZE): 0;
         //risk button
         int xDistance_RiskButton = Helper::IsObjectCreated(_riskButtonName) ? (int)ObjectGetInteger(0, _riskButtonName, OBJPROP_XDISTANCE): 0;
         int yDistance_RiskButton = Helper::IsObjectCreated(_riskButtonName) ? (int)ObjectGetInteger(0, _riskButtonName, OBJPROP_YDISTANCE): 0;
         int xSize_RiskButton = Helper::IsObjectCreated(_riskButtonName) ? (int)ObjectGetInteger(0, _riskButtonName, OBJPROP_XSIZE): 0;
         int ySize_RiskButton = Helper::IsObjectCreated(_riskButtonName) ? (int)ObjectGetInteger(0, _riskButtonName, OBJPROP_YSIZE): 0;
         //cancel button
         int xDistance_CancelButton = Helper::IsObjectCreated(_cancelButtonName) ? (int)ObjectGetInteger(0, _cancelButtonName, OBJPROP_XDISTANCE): 0;
         int yDistance_CancelButton = Helper::IsObjectCreated(_cancelButtonName) ? (int)ObjectGetInteger(0, _cancelButtonName, OBJPROP_YDISTANCE): 0;
         int xSize_CancelButton = Helper::IsObjectCreated(_cancelButtonName) ? (int)ObjectGetInteger(0, _cancelButtonName, OBJPROP_XSIZE): 0;
         int ySize_CancelButton = Helper::IsObjectCreated(_cancelButtonName) ? (int)ObjectGetInteger(0, _cancelButtonName, OBJPROP_YSIZE): 0;
         //label
         int xDistance_Label = Helper::IsObjectCreated(_labelName) ? (int)ObjectGetInteger(0, _labelName, OBJPROP_XDISTANCE): 0;
         int yDistance_Label = Helper::IsObjectCreated(_labelName) ? (int)ObjectGetInteger(0, _labelName, OBJPROP_YDISTANCE): 0;
         int xSize_Label = Helper::IsObjectCreated(_labelName) ? (int)ObjectGetInteger(0, _labelName, OBJPROP_XSIZE): 0;
         int ySize_Label = Helper::IsObjectCreated(_labelName) ? (int)ObjectGetInteger(0, _labelName, OBJPROP_YSIZE): 0;
         if(_prevMouseState == 0 && mouseState == 1){
            _mouseLeftButtonDownX = mouseXDistance;
            _mouseLeftButtonDownY = mouseYDistance;
            //mover
            _moverMLBD_XD = xDistance_Mover;
            _moverMLBD_YD = yDistance_Mover;
            //sendorder button
            _sendButtonMLBD_XD = xDistance_SendOrder;
            _sendButtonMLBD_YD = yDistance_SendOrder;
            //risk button
            _riskButtonMLBD_XD = xDistance_RiskButton;
            _riskButtonMLBD_YD = yDistance_RiskButton;
            //cancel button
            _cancelButtonMLBD_XD = xDistance_CancelButton;
            _cancelButtonMLBD_YD = yDistance_CancelButton;
            //label
            _labelMLBD_XD = xDistance_Label;
            _labelMLBD_YD = yDistance_Label;
            if(mouseXDistance >= xDistance_Mover && 
               mouseXDistance <= xDistance_Mover + xSize_Mover &&
               mouseYDistance >= yDistance_Mover && 
               mouseYDistance <= yDistance_Mover + ySize_Mover){
               //we are inside the  mover, we can start dragging obj
               _movingState = true;
            }
         }
         if(_movingState){
            ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
            //mover
            ObjectSetInteger(0, _moverButtonName, OBJPROP_XDISTANCE, (_moverMLBD_XD + mouseXDistance - _mouseLeftButtonDownX));
            ObjectSetInteger(0, _moverButtonName, OBJPROP_YDISTANCE, (_moverMLBD_YD + mouseYDistance - _mouseLeftButtonDownY));
            //move send order button
            if(Helper::IsObjectCreated(_sendOrderButtonName)){
               ObjectSetInteger(0, _sendOrderButtonName, OBJPROP_XDISTANCE, (_sendButtonMLBD_XD + mouseXDistance - _mouseLeftButtonDownX));
               ObjectSetInteger(0, _sendOrderButtonName , OBJPROP_YDISTANCE, (_sendButtonMLBD_YD + mouseYDistance - _mouseLeftButtonDownY));
            }
            //move risk button
            if(Helper::IsObjectCreated(_riskButtonName)){
               ObjectSetInteger(0, _riskButtonName, OBJPROP_XDISTANCE, (_riskButtonMLBD_XD + mouseXDistance - _mouseLeftButtonDownX));
               ObjectSetInteger(0, _riskButtonName , OBJPROP_YDISTANCE, (_riskButtonMLBD_YD + mouseYDistance - _mouseLeftButtonDownY));
            }
            //move cancel button
            if(Helper::IsObjectCreated(_cancelButtonName)){
               ObjectSetInteger(0, _cancelButtonName, OBJPROP_XDISTANCE, (_cancelButtonMLBD_XD + mouseXDistance - _mouseLeftButtonDownX));
               ObjectSetInteger(0, _cancelButtonName , OBJPROP_YDISTANCE, (_cancelButtonMLBD_YD + mouseYDistance - _mouseLeftButtonDownY));
            }
            //move label
            if(Helper::IsObjectCreated(_labelName)){
               ObjectSetInteger(0, _labelName, OBJPROP_XDISTANCE, (_labelMLBD_XD + mouseXDistance - _mouseLeftButtonDownX));
               ObjectSetInteger(0, _labelName , OBJPROP_YDISTANCE, (_labelMLBD_YD + mouseYDistance - _mouseLeftButtonDownY));
            }
            //price line
            datetime lineTime = 0;
            double linePrice = 0;
            int window = 0;
            ChartXYToTimePrice(0, (xDistance_Mover + 35), ((yDistance_Mover + ySize_Mover) - 6), window, lineTime, linePrice);
            //entryLevelPrice = linePrice;
            deleteLine();
            createLine(lineTime, linePrice);
            updateLabelTextEvent();
            ChartRedraw(0);            
         }
         if(mouseState == 0){
         _movingState = false;
         ChartSetInteger(0, CHART_MOUSE_SCROLL, true);
         }
         _prevMouseState = mouseState;
      }
   }
   if(id == CHARTEVENT_CLICK){
      if(_selectingRisk){
      if(_riskButtonClicked){
         _riskButtonClicked = false;
         return;
      }
      deleteSelectRiskButtons();
      }
   }
}
bool TradeLevel::Create(string objectName, long lparam, double dparam, int type, color levelColor, int lineWidth, color labelColor){
   if(Helper::IsObjectCreated(objectName)) return false;
   _objectName = objectName;
   _lineName = _objectName + _Line;
   _moverButtonName = _objectName + _MoverButton;
   _labelName = _objectName + _Label;
   _sendOrderButtonName = _objectName + _SendOrderButton;
   _riskButtonName = _objectName + _RiskButton;
   _cancelButtonName = _objectName + _CancelButton;
   _riskButton1Name = _objectName + _RiskButton1;
   _riskButton2Name = _objectName + _RiskButton2;
   _riskButton3Name = _objectName + _RiskButton3;
   _riskButton4Name = _objectName + _RiskButton4;
   _riskButton5Name = _objectName + _RiskButton5;
   ArrayResize(_risks,1);
   _risks[0] = 0; 
   _type = type;
   _levelColor = levelColor;
   _lineWidth = lineWidth;
   _labelColor = labelColor;
   Name(objectName);
   IsDragable = false;
   _prevMouseState = 0;
   _mouseLeftButtonDownX = 0;
   _mouseLeftButtonDownY = 0;
   _moverMLBD_XD = 0;
   _moverMLBD_YD = 0;
   _sendButtonMLBD_XD = 0;
   _sendButtonMLBD_YD = 0;
   _riskButtonMLBD_XD = 0;
   _riskButtonMLBD_YD = 0;
   _cancelButtonMLBD_XD = 0;
   _cancelButtonMLBD_YD = 0;
   _labelMLBD_XD = 0;
   _labelMLBD_YD = 0;
   _movingState = false;
   _selectingRisk = false;
   _riskButtonClicked = false;
   _price = 0;
   //create line
   datetime time = 0;
   double price = 0;
   int x = (int)lparam;
   int y = (int)dparam;
   int window = 0;
   ChartXYToTimePrice(0, x, y, window, time, price);
   createLine(time, price);
   createMoverButton(x, y);
   string textValue;
   switch(_type){
      case  1:
        textValue = "Pending order: " + (string)GetPrice();
        break;
      case  2:
        textValue = "Stoploss: " + (string)GetPrice();
        break;
      case  3:
        textValue = "Modify positions: " + (string)GetPrice();
        break;  
      default:
        textValue = ""; 
        break;
   }
   createLabel(x, y, textValue);
   addLevelButtons();
   ChartRedraw(0);
   return true;
}
bool TradeLevel::createLine(datetime time,double price){
   if(Helper::IsObjectCreated(_lineName)) deleteLine();
   int window = 0;
   _line.Create(0, _lineName, window, time, price, Helper::GetEndOfDay(), price);
   //todo:: add select color to inputs
   _line.Color(_levelColor);
   _line.Width(_lineWidth);
   SetPrice(_line.Price(0));
   return true;
}
bool TradeLevel::createMoverButton(int x, int y){
   if(Helper::IsObjectCreated(_moverButtonName)) _btnMoverButton.Destroy();
   _btnMoverButton.Create(0, _moverButtonName,0,(x - 35), (y -8), x, (y + 8));
   _btnMoverButton.ColorBackground(_levelColor);
   return true;
}
bool TradeLevel::createLabel(int x, int y, string text){
   if(Helper::IsObjectCreated(_labelName)) _label.Delete();
   _label.Create(0, _labelName, 0, (x + 5), (y- 27));
   _label.Color(_labelColor);
   updateLabelText(text);
   return true;
}
bool TradeLevel::createCancelButton(){
   if(!Helper::IsObjectCreated(_moverButtonName)) return false;
   if(Helper::IsObjectCreated(_cancelButtonName)) _btnCancel.Destroy();
   _btnCancel.Create(0, _cancelButtonName, 0, (_btnMoverButton.Left() - 30), (_btnMoverButton.Top() - 2), (_btnMoverButton.Right() - 40) , (_btnMoverButton.Bottom() + 2));
   _btnCancel.ColorBackground(clrRed);
   _btnCancel.Color(clrWhite);
   _btnCancel.Text("X"); 
   return true;
}
bool TradeLevel::createRiskButton(void){
   if(Helper::IsObjectCreated(_riskButtonName)) _btnRisk.Destroy();
   if(Helper::IsObjectCreated(_cancelButtonName)){
      _btnRisk.Create(0, _riskButtonName, 0, (_btnCancel.Left() - 65), (_btnCancel.Top()), (_btnCancel.Right() - 30) , (_btnCancel.Bottom()));
      _btnRisk.Text((string)app.GetRiskPersent() + " %");
   }
   _selectingRisk = false;
   return true;
}
bool TradeLevel::createSendOrderButton(void){
   if(Helper::IsObjectCreated(_sendOrderButtonName)) _btnSendOrder.Destroy();
   if(Helper::IsObjectCreated(_cancelButtonName) && !Helper::IsObjectCreated(_riskButtonName))
      _btnSendOrder.Create(0, _sendOrderButtonName, 0, (_btnCancel.Left() - 55), (_btnCancel.Top()), (_btnCancel.Right() - 30) , (_btnCancel.Bottom()));//20 
   if(Helper::IsObjectCreated(_cancelButtonName) && Helper::IsObjectCreated(_riskButtonName))
     _btnSendOrder.Create(0, _sendOrderButtonName, 0, (_btnRisk.Left() - 55), (_btnRisk.Top()), (_btnRisk.Right() - 65) , (_btnRisk.Bottom()));//20  
   _btnSendOrder.Text("Send");
   return true;
}
bool TradeLevel::createSelectRiskButtons(void){
   if(_selectingRisk){
      if(Helper::IsObjectCreated(_riskButton1Name)) _btnSelectRisk1.Destroy();
      if(Helper::IsObjectCreated(_riskButton2Name)) _btnSelectRisk2.Destroy();
      if(Helper::IsObjectCreated(_riskButton3Name)) _btnSelectRisk3.Destroy();
      if(Helper::IsObjectCreated(_riskButton4Name)) _btnSelectRisk4.Destroy();
      if(Helper::IsObjectCreated(_riskButton5Name)) _btnSelectRisk5.Destroy();
      deleteRiskButton();
      ChartRedraw(0);
      double entryLinePrice = GetPrice();
      datetime entryLineTime = _line.Time(0);
      int x,y;
      ChartTimePriceToXY(0, 0, entryLineTime, entryLinePrice, x, y);
      app.GetRiskValues(_risks);
      _btnSelectRisk1.Create(0, _riskButton1Name, 0, (x - 130), (y - 60), (x - 70) , (y - 40));
      _btnSelectRisk1.Color(clrBlack);
      _btnSelectRisk1.ColorBackground(clrWheat);
      _btnSelectRisk1.Text(string(_risks[0]) + " %");
      _btnSelectRisk2.Create(0, _riskButton2Name, 0, (x - 130), (y - 35), (x - 70) , (y - 15));
      _btnSelectRisk2.Color(clrBlack);
      _btnSelectRisk2.ColorBackground(clrWheat);
      _btnSelectRisk2.Text(string(_risks[1]) + " %");
      _btnSelectRisk3.Create(0, _riskButton3Name, 0, (x - 130), (y - 10), (x - 70) , (y + 10));
      _btnSelectRisk3.Color(clrBlack);
      _btnSelectRisk3.ColorBackground(clrWheat);
      _btnSelectRisk3.Text(string(_risks[2]) + " %");
      _btnSelectRisk4.Create(0, _riskButton4Name, 0, (x - 130), (y + 15), (x - 70) , (y + 35));
      _btnSelectRisk4.Color(clrBlack);
      _btnSelectRisk4.ColorBackground(clrWheat);
      _btnSelectRisk4.Text(string(_risks[3]) + " %");
      _btnSelectRisk5.Create(0, _riskButton5Name, 0, (x - 130), (y + 40), (x - 70) , (y + 60));
      _btnSelectRisk5.Color(clrBlack);
      _btnSelectRisk5.ColorBackground(clrWheat);
      _btnSelectRisk5.Text(string(_risks[4]) + " %");
      updateLabelText("Select risk %");
      ChartRedraw(0);
   }
   return true;
}
void TradeLevel::sendOrderButtonClick(void){
   if(_type == 1){
      bool result = TradeHelper::SendPendingOrder(app.GetPendingOrderPrice(), app.GetStoplossPrice(), app.GetRiskPersent());
      if(result) Delete();   
   }
   
}
void TradeLevel::riskButtonClick(void){
   _selectingRisk = true;
   IsDragable = false;
   createSelectRiskButtons();
   _riskButtonClicked = true;
}
void TradeLevel::cancelButtonClick(void){
   Delete();
}
void TradeLevel::selectRiskButtonClick(double newRiskValue){
   app.SetRiskPersent(newRiskValue);
   deleteSelectRiskButtons();
   //createRiskButton();
   ChartRedraw(0);
}
bool TradeLevel::updateLabelText(string value){
   if(ObjectSetString(0, _labelName, OBJPROP_TEXT, value)) return true;
   return false;
}

bool TradeLevel::addLevelButtons(){
   if(_type == 3){
      createCancelButton();
      createSendOrderButton();
      return true;
   }
   if(_type == 1){
   createCancelButton();
   createRiskButton();
   createSendOrderButton();
   return true;
   }
   if(_type == 2) return true;
   return false;
}
bool TradeLevel::deleteLine(void){
   return _line.Delete();
}
bool TradeLevel::deleteMoverButton(void){
   _btnMoverButton.Destroy();
   return true;
}
bool TradeLevel::deleteLabel(void){
   return _label.Delete();
}
bool TradeLevel::deleteSendOrderButton(void){
   _btnSendOrder.Destroy();
   return true;
}
bool TradeLevel::deleteRiskButton(void){
   _btnRisk.Destroy();
   return true;
}
bool TradeLevel::deleteSelectRiskButtons(void){
if(_selectingRisk){
      if(Helper::IsObjectCreated(_riskButton1Name) &&
      Helper::IsObjectCreated(_riskButton2Name) &&
      Helper::IsObjectCreated(_riskButton3Name) &&
      Helper::IsObjectCreated(_riskButton4Name) &&
      Helper::IsObjectCreated(_riskButton5Name)){
         _btnSelectRisk1.Destroy();
         _btnSelectRisk2.Destroy();
         _btnSelectRisk3.Destroy();
         _btnSelectRisk4.Destroy();
         _btnSelectRisk5.Destroy();
         _selectingRisk = false;
         ChartRedraw(0);
         if(!Helper::IsObjectCreated(_riskButtonName)){
         createRiskButton();
         
         ChartRedraw(0);
         }
         IsDragable = true;
         updateLabelTextEvent();
         return true;
      }
   }
   return false;
}
bool TradeLevel::deleteCancelButton(void){
   _btnCancel.Destroy();
   return true;
}
bool TradeLevel::IsLevelExist(void){
   switch(_type){
      case 1 :
        if(Helper::IsObjectCreated(_lineName) &&
           Helper::IsObjectCreated(_moverButtonName) &&
           Helper::IsObjectCreated(_cancelButtonName) &&
           Helper::IsObjectCreated(_riskButtonName) &&
           Helper::IsObjectCreated(_sendOrderButtonName)) return true;
      case 2 :
        if(Helper::IsObjectCreated(_lineName) &&
           Helper::IsObjectCreated(_moverButtonName)) return true;
      case 3 :
        if(Helper::IsObjectCreated(_lineName) &&
           Helper::IsObjectCreated(_moverButtonName) &&
           Helper::IsObjectCreated(_cancelButtonName) &&
           Helper::IsObjectCreated(_sendOrderButtonName)) return true;
      default:
        return false;
     }
}
bool TradeLevel::UpdateText(string value){
   return updateLabelText(value);
}
double TradeLevel::GetPrice(void){
   return _price;
}
bool TradeLevel::SetPrice(double value){
   _price = value;
   updatePriceEvent();
   return true;
}
bool TradeLevel::Delete(void){
   deleteLine();
   deleteMoverButton();
   deleteLabel();
   deleteSendOrderButton();
   deleteRiskButton();
   deleteCancelButton();
   deleteEvent();
   ChartRedraw(0);
   return true;
}
void TradeLevel::deleteEvent(void){
   CustomEvents eventId = DeleteLevel_EVENT;
   EventChartCustom(0, (ushort)eventId, 0, 0, _objectName);
}
void TradeLevel::updateLabelTextEvent(void){
   CustomEvents eventId = UpdateTextLevel_EVENT;
   EventChartCustom(0, (ushort)eventId, 0, 0, _objectName);
}
void TradeLevel::updatePriceEvent(void){
   CustomEvents eventId = PriceUpdate_EVENT;
   EventChartCustom(0, (ushort)eventId, 0, _price, _objectName);
}
