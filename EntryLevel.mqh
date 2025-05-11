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
#define SetRiskButton "SetRiskButton"
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
      bool updateLabelText(string value);
   public:
      EntryLevel();
      ~EntryLevel();
      bool Create(long lparam, double dparam);
      double GetPrice();
      bool Update();
      bool Delete();
};
EntryLevel::EntryLevel(){
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
   entryPrice = _entryLine.Price(0);
   //create level mover button
   if(Helper::IsObjectCreated(EntryLineMoverButton)) _btnEntryLineMover.Destroy();
   _btnEntryLineMover.Create(0, EntryLineMoverButton,0,(x - 35), (y -8), x, (y + 8));
   _btnEntryLineMover.ColorBackground(clrYellow);
   //creeate level info label
   if(Helper::IsObjectCreated(EntryLevelInfoText)) _labelEntryLevel.Delete();
   _labelEntryLevel.Create(0, EntryLevelInfoText, 0, (x + 5), (y- 27));
   _labelEntryLevel.Color(clrWhite);
   updateLabelText("Entry price:" + (string)_entryLine.Price(0));
   ChartRedraw(0);
   result = true;
   return result;
}
bool EntryLevel::updateLabelText(string value){
      if(ObjectSetString(0, EntryLevelInfoText, OBJPROP_TEXT, value)) return true;
      return false;
}
double EntryLevel::GetPrice(void){
   if(Helper::IsObjectCreated(EntryLine)) return _entryLine.Price(0);
   return 0.0;
}
bool EntryLevel::Update(void){
   return true;
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