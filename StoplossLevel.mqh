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
      bool updateLabelText(string value);
      string generateStoplossLabelText();
   public:
      StoplossLevel();
      ~StoplossLevel();
      bool Create(long lparam, double dparam);
      double GetPrice();
      bool Update();
      bool Delete();
};
StoplossLevel::StoplossLevel(){}
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
      stopLossPrice = _stoplossLine.Price(0);
      //create level mover button
      if(Helper::IsObjectCreated(StopLossLineMoverButton)) _btnStoplossLineMover.Destroy();
      _btnStoplossLineMover.Create(0, StopLossLineMoverButton,0,(x - 35), (y -8), x, (y + 8));
      _btnStoplossLineMover.ColorBackground(clrRed);
      //creeate level info label
      if(Helper::IsObjectCreated(StoplossLevelInfoText)) _labelStoplossLevel.Delete();
      _labelStoplossLevel.Create(0, StoplossLevelInfoText, 0, (x + 5), (y- 27));
      _labelStoplossLevel.Color(clrWhite);
      updateLabelText(generateStoplossLabelText());
      ChartRedraw(0);
      result = true;
      return result;
}
bool StoplossLevel::updateLabelText(string value){
      if(ObjectSetString(0, StoplossLevelInfoText, OBJPROP_TEXT, value)) return true;
      return false;
}
double StoplossLevel::GetPrice(void){
   if(Helper::IsObjectCreated(StopLossLine)) return _stoplossLine.Price(0);
   return 0.0;
}
string StoplossLevel::generateStoplossLabelText(void){
   //double entryPrice = tradeLevels.GetEntryPrice();
   //double slPrice = tradeLevels.GetStopLossPrice();
   //double risk = riskPersent;
   //double riskMoney = AccountInfoDouble(ACCOUNT_BALANCE) * risk / 100;
   //string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
   //double lots = Helper::CalculateLotSize(entryPrice, slPrice, risk);
   //return "SL: " + (string)slPrice + " "+ (string)lots + " lots " + (string)riskMoney + " " +  accountCurrency;
   return "SL";
}
bool StoplossLevel::Update(void){
   return true;
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