//+------------------------------------------------------------------+
//|                                                   EntryLevel.mqh |
//+------------------------------------------------------------------+
#include  <ChartObjects/ChartObjectsTxtControls.mqh>
#include  <ChartObjects/ChartObjectsLines.mqh>
#include  <Controls/Button.mqh>
//Entry line
#define EntryLine "Entry line"
//Entry line mover button
#define EntryLineMoverButton "Entry Line Mover Button"
//Entry level buttons
#define SendOrderButton "Send Order Button"
#define CancelSelectionButton "Cancel Selection Button"
#define RiskButton "RiskButton"
//Risk select buttons
#define  SelectRisk1Button "Select Risk 1 Button"
#define  SelectRisk2Button "Select Risk 2 Button"
#define  SelectRisk3Button "Select Risk 3 Button"
#define  SelectRisk4Button "Select Risk 4 Button"
#define  SelectRisk5Button "Select Risk 5 Button"
//entry level labels
#define EntryLevelInfoText "Entry Level Info Text"
class EntryLevel{
   private:
      CChartObjectTrend _entryLine;
      CButton _btnEntryLineMover;
      CButton _btnSendOrder;
      CButton _btnRisk;
      CButton _btnCancel;
      CButton _btnSelectRisk1;
      CButton _btnSelectRisk2;
      CButton _btnSelectRisk3;
      CButton _btnSelectRisk4;
      CButton _btnSelectRisk5;
      CChartObjectLabel _labelEntryLevel;      
      bool createLevelButtons();
      double getRiskValue();
      void setRiskValue(double value);
      string generateRiskText(double riskValue);
   public:
      EntryLevel();
      ~EntryLevel();
      bool MovingState;
      int MoverMLBD_XD;
      int MoverMLBD_YD;
      int SendButtonMLBD_XD;
      int SendButtonMLBD_YD;
      int RiskButtonMLBD_XD;
      int RiskButtonMLBD_YD;
      int CancelSelectionButtonMLBD_XD;
      int CancelSelectionButtonMLBD_YD;
      int LabelMLBD_XD;
      int LabelMLBD_YD;
      bool Create(long lparam, double dparam);
      bool CreateLine(datetime time, double price);
      double GetPrice();
      bool LevelMove(int mouseXDistance, int mouseYDistance, int mouseLeftButtonDownX, int mouseLeftButtonDownY, int xDistance_Mover, int yDistance_Mover, int ySize_Mover);
      void OnEvent(const int id,const long& lparam,const double& dparam,const string& sparam);
      bool IsLevelExict();
      int GetMoverXDistance();
      bool SetMoverXDistance(int value);
      int GetMoverYDistance();
      bool SetMoverYDistance(int value);
      int GetMoverXSize();
      bool SetMoverXSize(int value);
      int GetMoverYSize();
      bool SetMoverYSize(int value);
      int GetSendOrderXDistance();
      bool SetSendOrderXDistance(int value);
      int GetSendOrderYDistance();
      bool SetSendOrderYDistance(int value);
      int GetSendOrderXSize();
      bool SetSendOrderXSize(int value);
      int GetSendOrderYSize();
      bool SetSendOrderYSize(int value);
      int GetRiskButtonXDistance();
      bool SetRiskButtonXDistance(int value);
      int GetRiskButtonYDistance();
      bool SetRiskButtonYDistance(int value);
      int GetRiskButtonXSize();
      bool SetRiskButtonXSize(int value);
      int GetRiskButtonYSize();
      bool SetRiskButtonYSize(int value);
      int GetCancelButtonXDistance();
      bool SetCancelButtonXDistance(int value);
      int GetCancelButtonYDistance();
      bool SetCancelButtonYDistance(int value);
      int GetCancelButtonXSize();
      bool SetCancelButtonXSize(int value);
      int GetCancelButtonYSize();
      bool SetCancelButtonYSize(int value);
      int GetLabelXDistance();
      bool SetLabelXDistance(int value);
      int GetLabelYDistance();
      bool SetLabelYDistance(int value);
      int GetLabelXSize();
      bool SetLabelXSize(int value);
      int GetLabelYSize();
      bool SetLabelYSize(int value);
      bool Update();
      bool UpdateLabelText(string value);
      bool DeleteLine();
      bool Delete();
      bool AddLevelButtons();
};
EntryLevel::EntryLevel(){
   MovingState = false;
   MoverMLBD_XD = 0;
   MoverMLBD_YD = 0;
   SendButtonMLBD_XD = 0;
   SendButtonMLBD_YD = 0;
   RiskButtonMLBD_XD = 0;
   RiskButtonMLBD_YD = 0;
   CancelSelectionButtonMLBD_XD = 0;
   CancelSelectionButtonMLBD_YD = 0;
   LabelMLBD_XD = 0;
   LabelMLBD_YD = 0;
}
EntryLevel::~EntryLevel(){
   Delete();
}
bool EntryLevel::Create(long lparam, double dparam){
   bool result = false;
   if(Helper::IsObjectCreated(EntryLine)) return result;
   //create entry line
   datetime time = 0, endOfDay = Helper::GetEndOfDay();
   double price = 0;
   int x = (int)lparam;
   int y = (int)dparam;
   int window = 0;
   ChartXYToTimePrice(0, x, y, window, time, price);
   _entryLine.Create(0, EntryLine, window, time, price, endOfDay, price);
   _entryLine.Color(clrYellow);
   _entryLine.Width(1);
   //create level mover button
   if(Helper::IsObjectCreated(EntryLineMoverButton)) _btnEntryLineMover.Destroy();
   _btnEntryLineMover.Create(0, EntryLineMoverButton,0,(x - 35), (y -8), x, (y + 8));
   _btnEntryLineMover.ColorBackground(clrYellow);
   //creeate level info label
   if(Helper::IsObjectCreated(EntryLevelInfoText)) _labelEntryLevel.Delete();
   _labelEntryLevel.Create(0, EntryLevelInfoText, 0, (x + 5), (y- 27));
   _labelEntryLevel.Color(clrWhite);
   UpdateLabelText("Entry price:" + (string)GetPrice());
   entryLevelPrice = GetPrice();
   ChartRedraw(0);
   result = true;
   return result;
}
bool EntryLevel::CreateLine(datetime time,double price){
   int window = 0;
   if(Helper::IsObjectCreated(EntryLine)) return false;
   _entryLine.Create(0, EntryLine, window, time, price, Helper::GetEndOfDay(), price); 
   _entryLine.Color(clrYellow);
   _entryLine.Width(1);
   return true;
}
bool EntryLevel::UpdateLabelText(string value){
   if(ObjectSetString(0, EntryLevelInfoText, OBJPROP_TEXT, value)) return true;
   return false;
}
double EntryLevel::GetPrice(void){
   if(Helper::IsObjectCreated(EntryLine)) return _entryLine.Price(0);
   return 0.0;
}
bool EntryLevel::LevelMove(int mouseXDistance, int mouseYDistance, int mouseLeftButtonDownX, int mouseLeftButtonDownY, int xDistance_Mover, int yDistance_Mover, int ySize_Mover){
   ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
   //mover
   SetMoverXDistance(MoverMLBD_XD + mouseXDistance - mouseLeftButtonDownX);
   SetMoverYDistance(MoverMLBD_YD + mouseYDistance - mouseLeftButtonDownY);
   //move send order button
   SetSendOrderXDistance(SendButtonMLBD_XD + mouseXDistance - mouseLeftButtonDownX);
   SetSendOrderYDistance(SendButtonMLBD_YD + mouseYDistance - mouseLeftButtonDownY);
   //move risk button
   SetRiskButtonXDistance(RiskButtonMLBD_XD + mouseXDistance - mouseLeftButtonDownX);
   SetRiskButtonYDistance(RiskButtonMLBD_YD + mouseYDistance - mouseLeftButtonDownY);
   //move cancelSelection button
   SetCancelButtonXDistance(CancelSelectionButtonMLBD_XD + mouseXDistance - mouseLeftButtonDownX);
   SetCancelButtonYDistance(CancelSelectionButtonMLBD_YD + mouseYDistance - mouseLeftButtonDownY);
   //entry info label
   SetLabelXDistance(LabelMLBD_XD + mouseXDistance - mouseLeftButtonDownX);
   SetLabelYDistance(LabelMLBD_YD + mouseYDistance - mouseLeftButtonDownY);
   //price line
   datetime lineTime = 0;
   double linePrice = 0;
   int window = 0;
   ChartXYToTimePrice(0, (xDistance_Mover + 35), ((yDistance_Mover + ySize_Mover) - 6), window, lineTime, linePrice);
   entryLevelPrice = linePrice;
   DeleteLine();
   CreateLine(lineTime, linePrice);
   ChartRedraw(0);
   return true;
}
void EntryLevel::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam){

}
bool EntryLevel::IsLevelExict(void){
   if(Helper::IsObjectCreated(EntryLine) && 
      Helper::IsObjectCreated(EntryLineMoverButton) &&
      Helper::IsObjectCreated(SendOrderButton) &&
      Helper::IsObjectCreated(RiskButton) &&
      Helper::IsObjectCreated(CancelSelectionButton) &&
      Helper::IsObjectCreated(EntryLevelInfoText)) return true;
   return false;
}
int EntryLevel::GetMoverXDistance(void){
   return (int)ObjectGetInteger(0, EntryLineMoverButton, OBJPROP_XDISTANCE);
}
bool EntryLevel::SetMoverXDistance(int value){
   return ObjectSetInteger(0, EntryLineMoverButton, OBJPROP_XDISTANCE, value);
}
int EntryLevel::GetMoverYDistance(void){
   return (int)ObjectGetInteger(0, EntryLineMoverButton, OBJPROP_YDISTANCE);  
}
bool EntryLevel::SetMoverYDistance(int value){
   return ObjectSetInteger(0, EntryLineMoverButton, OBJPROP_YDISTANCE, value);
}
int EntryLevel::GetMoverXSize(void){
   return (int)ObjectGetInteger(0, EntryLineMoverButton, OBJPROP_XSIZE);
}
bool EntryLevel::SetMoverXSize(int value){
   return ObjectSetInteger(0, EntryLineMoverButton, OBJPROP_XSIZE, value);
}
int EntryLevel::GetMoverYSize(void){
   return (int)ObjectGetInteger(0, EntryLineMoverButton, OBJPROP_YSIZE);
}
bool EntryLevel::SetMoverYSize(int value){
   return ObjectSetInteger(0, EntryLineMoverButton, OBJPROP_YSIZE, value);
}
int EntryLevel::GetSendOrderXDistance(void){
   return (int)ObjectGetInteger(0, SendOrderButton, OBJPROP_XDISTANCE);
}
bool EntryLevel::SetSendOrderXDistance(int value){
   return ObjectSetInteger(0, SendOrderButton, OBJPROP_XDISTANCE, value);
}
int EntryLevel::GetSendOrderYDistance(void){
   return (int)ObjectGetInteger(0, SendOrderButton, OBJPROP_YDISTANCE);
}
bool EntryLevel::SetSendOrderYDistance(int value){
   return ObjectSetInteger(0, SendOrderButton, OBJPROP_YDISTANCE, value);
}
int EntryLevel::GetSendOrderXSize(void){
   return (int)ObjectGetInteger(0, SendOrderButton, OBJPROP_XSIZE);
}
bool EntryLevel::SetSendOrderXSize(int value){
   return ObjectSetInteger(0, SendOrderButton, OBJPROP_XSIZE, value);
}
int EntryLevel::GetSendOrderYSize(void){
   return (int)ObjectGetInteger(0, SendOrderButton, OBJPROP_YSIZE);
}
bool EntryLevel::SetSendOrderYSize(int value){
   return ObjectSetInteger(0, SendOrderButton, OBJPROP_YSIZE, value);
}
int EntryLevel::GetRiskButtonXDistance(void){
   return (int)ObjectGetInteger(0, RiskButton, OBJPROP_XDISTANCE);
}
bool EntryLevel::SetRiskButtonXDistance(int value){
   return ObjectSetInteger(0, RiskButton, OBJPROP_XDISTANCE, value);
}
int EntryLevel::GetRiskButtonYDistance(void){
   return (int)ObjectGetInteger(0, RiskButton, OBJPROP_YDISTANCE);
}
bool EntryLevel::SetRiskButtonYDistance(int value){
   return ObjectSetInteger(0, RiskButton, OBJPROP_YDISTANCE, value);
}
int EntryLevel::GetRiskButtonXSize(void){
   return (int)ObjectGetInteger(0, RiskButton, OBJPROP_XSIZE);
}
bool EntryLevel::SetRiskButtonXSize(int value){
   return ObjectSetInteger(0, RiskButton, OBJPROP_XSIZE, value);
}
int EntryLevel::GetRiskButtonYSize(void){
   return (int)ObjectGetInteger(0, RiskButton, OBJPROP_YSIZE);
}
bool EntryLevel::SetRiskButtonYSize(int value){
   return ObjectSetInteger(0, RiskButton, OBJPROP_YSIZE, value);   
}
int EntryLevel::GetCancelButtonXDistance(void){
   return (int)ObjectGetInteger(0, CancelSelectionButton, OBJPROP_XDISTANCE);
}
bool EntryLevel::SetCancelButtonXDistance(int value){
   return ObjectSetInteger(0, CancelSelectionButton, OBJPROP_XDISTANCE, value);
}
int EntryLevel::GetCancelButtonYDistance(void){
   return (int)ObjectGetInteger(0, CancelSelectionButton, OBJPROP_YDISTANCE);
}
bool EntryLevel::SetCancelButtonYDistance(int value){
   return ObjectSetInteger(0, CancelSelectionButton, OBJPROP_YDISTANCE, value);
}
int EntryLevel::GetCancelButtonXSize(void){
   return (int)ObjectGetInteger(0, CancelSelectionButton, OBJPROP_XSIZE);
}
bool EntryLevel::SetCancelButtonXSize(int value){
   return ObjectSetInteger(0, CancelSelectionButton, OBJPROP_XSIZE, value);
}
int EntryLevel::GetCancelButtonYSize(void){
   return (int)ObjectGetInteger(0, CancelSelectionButton, OBJPROP_YSIZE);
}
bool EntryLevel::SetCancelButtonYSize(int value){
   return ObjectSetInteger(0, CancelSelectionButton, OBJPROP_YSIZE, value);
}
bool EntryLevel::Update(void){
   return true;
}
int EntryLevel::GetLabelXDistance(void){
   return (int)ObjectGetInteger(0, EntryLevelInfoText, OBJPROP_XDISTANCE);
}
bool EntryLevel::SetLabelXDistance(int value){
   return ObjectSetInteger(0, EntryLevelInfoText, OBJPROP_XDISTANCE, value);
}
int EntryLevel::GetLabelYDistance(void){
   return (int)ObjectGetInteger(0, EntryLevelInfoText, OBJPROP_YDISTANCE);
}
bool EntryLevel::SetLabelYDistance(int value){
   return ObjectSetInteger(0, EntryLevelInfoText, OBJPROP_YDISTANCE, value);
}
int EntryLevel::GetLabelXSize(void){
   return (int)ObjectGetInteger(0, EntryLevelInfoText, OBJPROP_XSIZE);
}
bool EntryLevel::SetLabelXSize(int value){
   return ObjectSetInteger(0, EntryLevelInfoText, OBJPROP_XSIZE, value);
}
int EntryLevel::GetLabelYSize(void){
   return (int)ObjectGetInteger(0, EntryLevelInfoText, OBJPROP_YSIZE);
}
bool EntryLevel::SetLabelYSize(int value){
   return ObjectSetInteger(0, EntryLevelInfoText, OBJPROP_YSIZE, value);
}
bool EntryLevel::DeleteLine(void){
   return _entryLine.Delete();
}
bool EntryLevel::Delete(void){
   if(!Helper::IsObjectCreated(EntryLine) || 
      !Helper::IsObjectCreated(EntryLineMoverButton) ||
      !Helper::IsObjectCreated(EntryLevelInfoText)) return false;
   _entryLine.Delete();
   _btnEntryLineMover.Destroy();
   _labelEntryLevel.Delete();
   ChartRedraw(0);
   return true;   
}
bool EntryLevel::AddLevelButtons(void){
   if(!Helper::IsObjectCreated(EntryLine) || 
      !Helper::IsObjectCreated(EntryLineMoverButton) ||
      !Helper::IsObjectCreated(EntryLevelInfoText)) return false;
   createLevelButtons(); 
   return true; 
}
bool EntryLevel::createLevelButtons(void){
   //get entry line
   double entryLinePrice = GetPrice();
   datetime entryLineTime = _entryLine.Time(0);
   int x,y;
   ChartTimePriceToXY(0, 0, entryLineTime, entryLinePrice, x, y);
   if(!Helper::IsObjectCreated(SendOrderButton)){
      _btnSendOrder.Create(0, SendOrderButton, 0, (x - 170), (y - 10), (x - 120) , (y + 10));//50
      _btnSendOrder.Text("Send");
   }
   if(!Helper::IsObjectCreated(RiskButton)){
      _btnRisk.Create(0, RiskButton, 0, (x - 115), (y - 10), (x - 65) , (y + 10));//40
      _btnRisk.Text(generateRiskText(getRiskValue()));
   }
   if(!Helper::IsObjectCreated(CancelSelectionButton)){
      _btnCancel.Create(0, CancelSelectionButton, 0, (x - 60), (y - 10), (x - 40) , (y + 10));//20
      _btnCancel.Text("X");
   }
   ChartRedraw(0);
   return true;
}
double EntryLevel::getRiskValue(void){
   return persentOfRisk;
}
void EntryLevel::setRiskValue(double value){
   persentOfRisk = value;
}
string EntryLevel::generateRiskText(double riskValue){
   return (string)riskValue + " %";
}