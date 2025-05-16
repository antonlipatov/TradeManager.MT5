//+------------------------------------------------------------------+
//|                                                   TradeLevel.mqh |
//+------------------------------------------------------------------+
#include  <ChartObjects/ChartObjectsTxtControls.mqh>
#include  <ChartObjects/ChartObjectsLines.mqh>
#include  <Controls/Button.mqh>
class TradeLevel{
   private:
      //level
      #define  _Line "_Line"
      #define  _MoverButton "_MoverButton"
      #define  _Label "_Label"
      //level buttons
      #define  _SendOrderButton "_SendOrderButton"
      #define  _RiskButton "_RiskButton"
      #define  _CancelButton "_CancelButton"
      string _objectName;
      string _lineName;
      string _moverButtonName;
      string _labelName;
      string _sendOrderButtonName;
      string _riskButtonName;
      string _cancelButtonName;
      //level
      CChartObjectTrend _line;
      CButton _btnMoverButton;
      CChartObjectLabel _label;
      //level buttons
      CButton _btnSendOrder;
      CButton _btnRisk;
      CButton _btnCancel;
      bool create(string objectName, long lparam, double dparam, int type);
      bool createLine(datetime time,double price);
      bool createMoverButton(int x, int y);
      bool createLabel(int x, int y, string text);
      bool createSendOrderButton();
      bool createRiskButton();
      bool createCancelButton();
      void sendOrderButtonClick();
      void riskButtonClick();
      void cancelButtonClick();
      bool updateLabelText(string value);
      bool addLevelButtons(int type);
      bool deleteLine();
      bool deleteMoverButton();
      bool deleteLabel();
      bool deleteSendOrderButton();
      bool deleteRiskButton();
      bool deleteCancelButton();
   public:
      TradeLevel();
      TradeLevel(int type, string name, long lparam, double dparam);
      ~TradeLevel();
      bool IsDragable;
      void OnEvent(const int id,const long& lparam,const double& dparam,const string& sparam);
      bool Delete();
};
TradeLevel::TradeLevel(){
}
TradeLevel::TradeLevel(int type, string name, long lparam, double dparam){
   create(name, lparam, dparam, type);
}
TradeLevel::~TradeLevel(){
   Delete();
}
void TradeLevel::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   if(id == CHARTEVENT_OBJECT_CLICK){
      if(sparam == _sendOrderButtonName) sendOrderButtonClick();
      if(sparam == _riskButtonName) riskButtonClick();
      if(sparam == _cancelButtonName) cancelButtonClick();
   }
}
bool TradeLevel::create(string objectName, long lparam, double dparam, int type){
   if(Helper::IsObjectCreated(objectName)) return false;
   _objectName = objectName;
   _lineName = _objectName + _Line;
   _moverButtonName = _objectName + _MoverButton;
   _labelName = _objectName + _Label;
   _sendOrderButtonName = _objectName + _SendOrderButton;
   _riskButtonName = _objectName + _RiskButton;
   _cancelButtonName = _objectName + _CancelButton;
   IsDragable = false;
   //create line
   datetime time = 0;
   double price = 0;
   int x = (int)lparam;
   int y = (int)dparam;
   int window = 0;
   ChartXYToTimePrice(0, x, y, window, time, price);
   createLine(time, price);
   createMoverButton(x, y);
   createLabel(x, y, "Modify position");
   addLevelButtons(type);
   ChartRedraw(0);
   return true;
}
bool TradeLevel::createLine(datetime time,double price){
   if(Helper::IsObjectCreated(_lineName)) deleteLine();
   int window = 0;
   _line.Create(0, _lineName, window, time, price, Helper::GetEndOfDay(), price);
   //todo:: add select color to inputs
   _line.Color(clrLightGray);
   _line.Width(1);
   return true;
}
bool TradeLevel::createMoverButton(int x, int y){
   if(Helper::IsObjectCreated(_moverButtonName)) _btnMoverButton.Destroy();
   _btnMoverButton.Create(0, _moverButtonName,0,(x - 35), (y -8), x, (y + 8));
   _btnMoverButton.ColorBackground(clrGray);
   return true;
}
bool TradeLevel::createLabel(int x, int y, string text){
   if(Helper::IsObjectCreated(_labelName)) _label.Delete();
   _label.Create(0, _labelName, 0, (x + 5), (y- 27));
   _label.Color(clrWhite);
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
bool TradeLevel::createSendOrderButton(void){
   if(Helper::IsObjectCreated(_sendOrderButtonName)) _btnSendOrder.Destroy();
   if(Helper::IsObjectCreated(_cancelButtonName) && !Helper::IsObjectCreated(_riskButtonName)){
      _btnSendOrder.Create(0, _sendOrderButtonName, 0, (_btnCancel.Left() - 55), (_btnCancel.Top()), (_btnCancel.Right() - 30) , (_btnCancel.Bottom()));//20
      _btnSendOrder.Text("Send");
   }    
   return true;
}
void TradeLevel::sendOrderButtonClick(void){   
}
void TradeLevel::riskButtonClick(void){
}
void TradeLevel::cancelButtonClick(void){
   Print(__FUNCTION__);
   Delete();
}
bool TradeLevel::updateLabelText(string value){
   if(ObjectSetString(0, _labelName, OBJPROP_TEXT, value)) return true;
   return false;
}
//type:
//1: Entry level -> send order, risk, cancel
//2: SL levele -> no buttons
//3: Modify level -> send order, cancel
bool TradeLevel::addLevelButtons(int type){
   if(type == 3){
      createCancelButton();
      createSendOrderButton();
   }
   return true;
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
bool TradeLevel::deleteCancelButton(void){
   _btnCancel.Destroy();
   return true;
}
bool TradeLevel::Delete(void){
   deleteLine();
   deleteMoverButton();
   deleteLabel();
   deleteSendOrderButton();
   deleteRiskButton();
   deleteCancelButton();
   ChartRedraw(0);
   return true;
}