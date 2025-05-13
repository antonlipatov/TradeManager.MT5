//+------------------------------------------------------------------+
//|                                                StoplossLevel.mqh |
//+------------------------------------------------------------------+
#include  <ChartObjects/ChartObjectsTxtControls.mqh>
#include  <ChartObjects/ChartObjectsLines.mqh>
#include  <Controls/Button.mqh>
//Stop loss line
#define StopLossLine "Stop Loss Line"
//Stop loss line mover button
#define StopLossLineMoverButton "Stop Loss Line Mover Button"
//Stoploss level label
#define StoplossLevelInfoText "Stoploss Level Info Text"
class StoplossLevel{
   private:
      CChartObjectTrend _stoplossLine;
      CButton _btnStoplossLineMover;
      CChartObjectLabel _labelStoplossLevel;
    
   public:
      StoplossLevel();
      ~StoplossLevel();
      bool MovingState;
      int MoverMLBD_XD;
      int MoverMLBD_YD;
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
      string GenerateStoplossLabelText();
};
StoplossLevel::StoplossLevel(){
   MovingState = false;\
   MoverMLBD_XD = 0;
   MoverMLBD_YD = 0;
   LabelMLBD_XD = 0;
   LabelMLBD_YD = 0;
}
StoplossLevel::~StoplossLevel(){
   Delete();
}
bool StoplossLevel::Create(long lparam,double dparam){
      bool result = false;
      if(Helper::IsObjectCreated(StopLossLine)) return result;
      //create stoploss line
      datetime time = 0, endOfDay = Helper::GetEndOfDay();
      double price = 0;
      int x = (int)lparam;
      int y = (int)dparam;
      int window = 0;
      ChartXYToTimePrice(0, x, y, window, time, price);
      _stoplossLine.Create(0, StopLossLine, window, time, price, endOfDay, price);
      _stoplossLine.Color(clrRed);
      _stoplossLine.Width(1);
      //create level mover button
      if(Helper::IsObjectCreated(StopLossLineMoverButton)) _btnStoplossLineMover.Destroy();
      _btnStoplossLineMover.Create(0, StopLossLineMoverButton,0,(x - 35), (y -8), x, (y + 8));
      _btnStoplossLineMover.ColorBackground(clrRed);
      //creeate level info label
      if(Helper::IsObjectCreated(StoplossLevelInfoText)) _labelStoplossLevel.Delete();
      _labelStoplossLevel.Create(0, StoplossLevelInfoText, 0, (x + 5), (y- 27));
      _labelStoplossLevel.Color(clrWhite);
      stopLevelPrice = GetPrice();
      UpdateLabelText(GenerateStoplossLabelText());
      ChartRedraw(0);
      result = true;
      return result;
}
bool StoplossLevel::CreateLine(datetime time,double price){
   int window = 0;
   if(Helper::IsObjectCreated(StopLossLine)) return false;
   _stoplossLine.Create(0, StopLossLine, window, time, price, Helper::GetEndOfDay(), price); 
   _stoplossLine.Color(clrRed);
   _stoplossLine.Width(1);
   return true;
}
bool StoplossLevel::UpdateLabelText(string value){
      if(ObjectSetString(0, StoplossLevelInfoText, OBJPROP_TEXT, value)) return true;
      return false;
}
double StoplossLevel::GetPrice(void){
   if(Helper::IsObjectCreated(StopLossLine)) return _stoplossLine.Price(0);
   return 0.0;
}
bool StoplossLevel::LevelMove(int mouseXDistance,int mouseYDistance,int mouseLeftButtonDownX,int mouseLeftButtonDownY,int xDistance_Mover,int yDistance_Mover,int ySize_Mover){
   ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
   //drag the obj along with the mouse button
   SetMoverXDistance(MoverMLBD_XD + mouseXDistance - mouseLeftButtonDownX);
   SetMoverYDistance(MoverMLBD_YD + mouseYDistance - mouseLeftButtonDownY);
   //stoploss info label
   SetLabelXDistance(LabelMLBD_XD + mouseXDistance - mouseLeftButtonDownX);
   SetLabelYDistance(LabelMLBD_YD + mouseYDistance - mouseLeftButtonDownY);      
   //price line
   datetime lineTime = 0;
   double linePrice = 0;
   int window = 0;
   ChartXYToTimePrice(0, (xDistance_Mover + 35), ((yDistance_Mover + ySize_Mover) - 6), window, lineTime, linePrice);
   stopLevelPrice = linePrice;
   DeleteLine();
   CreateLine(lineTime, linePrice);
   ChartRedraw(0);
   return true;
}
void StoplossLevel::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
}
bool StoplossLevel::IsLevelExict(void){
   if(Helper::IsObjectCreated(StopLossLine) &&
      Helper::IsObjectCreated(StopLossLineMoverButton) &&
      Helper::IsObjectCreated(StoplossLevelInfoText)) return true;
   return false;
}
int StoplossLevel::GetMoverXDistance(void){
   return (int)ObjectGetInteger(0, StopLossLineMoverButton, OBJPROP_XDISTANCE);
}
bool StoplossLevel::SetMoverXDistance(int value){
   return ObjectSetInteger(0, StopLossLineMoverButton, OBJPROP_XDISTANCE, value);
}
int StoplossLevel::GetMoverYDistance(void){
   return (int)ObjectGetInteger(0, StopLossLineMoverButton, OBJPROP_YDISTANCE);
}
bool StoplossLevel::SetMoverYDistance(int value){
   return ObjectSetInteger(0, StopLossLineMoverButton, OBJPROP_YDISTANCE, value);
}
int StoplossLevel::GetMoverXSize(void){
   return (int)ObjectGetInteger(0, StopLossLineMoverButton, OBJPROP_XSIZE);
}
bool StoplossLevel::SetMoverXSize(int value){
   return ObjectSetInteger(0, StopLossLineMoverButton, OBJPROP_XSIZE, value);
}
int StoplossLevel::GetMoverYSize(void){
   return (int)ObjectGetInteger(0, StopLossLineMoverButton, OBJPROP_YSIZE);
}
bool StoplossLevel::SetMoverYSize(int value){
   return ObjectSetInteger(0, StopLossLineMoverButton, OBJPROP_YSIZE, value);
}
int StoplossLevel::GetLabelXDistance(void){
   return (int)ObjectGetInteger(0, StoplossLevelInfoText, OBJPROP_XDISTANCE);
}
bool StoplossLevel::SetLabelXDistance(int value){
   return ObjectSetInteger(0, StoplossLevelInfoText, OBJPROP_XDISTANCE, value);
}
int StoplossLevel::GetLabelYDistance(void){
   return (int)ObjectGetInteger(0, StoplossLevelInfoText, OBJPROP_YDISTANCE);
}
bool StoplossLevel::SetLabelYDistance(int value){
   return ObjectSetInteger(0, StoplossLevelInfoText, OBJPROP_YDISTANCE, value);
}
int StoplossLevel::GetLabelXSize(void){
   return (int)ObjectGetInteger(0, StoplossLevelInfoText, OBJPROP_XSIZE);
}
bool StoplossLevel::SetLabelXSize(int value){
   return ObjectSetInteger(0, StoplossLevelInfoText, OBJPROP_XSIZE, value);
}
int StoplossLevel::GetLabelYSize(void){
   return (int)ObjectGetInteger(0, StoplossLevelInfoText, OBJPROP_YSIZE);
}
bool StoplossLevel::SetLabelYSize(int value){
   return ObjectSetInteger(0, StoplossLevelInfoText, OBJPROP_YSIZE, value);
}
string StoplossLevel::GenerateStoplossLabelText(){
   double price = GetPrice();
   double risk = persentOfRisk;
   double riskMoney = AccountInfoDouble(ACCOUNT_BALANCE) * risk / 100;
   string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
   double lots = TradeHelper::CalculateLotSize(entryLevelPrice, stopLevelPrice, risk);
   return "SL: " + (string)price + ", "+ (string)lots + " lots, " + (string)riskMoney + " " +  accountCurrency;
}
bool StoplossLevel::Update(void){
   return true;
}
bool StoplossLevel::DeleteLine(void){
   return _stoplossLine.Delete();
}
bool StoplossLevel::Delete(void){
   if(!Helper::IsObjectCreated(StopLossLine) || 
      !Helper::IsObjectCreated(StopLossLineMoverButton) ||
      !Helper::IsObjectCreated(StoplossLevelInfoText)) return false;
   _stoplossLine.Delete();
   _btnStoplossLineMover.Destroy();
   _labelStoplossLevel.Delete();
   ChartRedraw(0);
   return true;   
}