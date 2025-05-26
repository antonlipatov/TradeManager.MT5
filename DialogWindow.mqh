//+------------------------------------------------------------------+
//|                                                 DialogWindow.mqh |
//+------------------------------------------------------------------+
#include <Controls\Button.mqh>
#include <Controls\Label.mqh>
#include <Controls\Dialog.mqh>
class DialogWindow{
   private:
      #define _Dialog "_Dialog"
      #define  _DialogLabelLine "_DialogLabelLine"
      #define  _BuyButton "_BuyButton"
      #define  _SellButton "_SellButton"
      string _objectName;
      string _dialogName;
      string _labelLine1Name;
      string _labelLine2Name;
      string _buyButtonName;
      string _sellButtonName;
      string _dialogText;
      int _x;
      int _y;
      CDialog _dialogWindow;
      CLabel _labelLine1;
      CLabel _labelLine2;
      CButton _btnBuy;
      CButton _btnSell;
   public:
      DialogWindow();
      ~DialogWindow();
      bool CreateModifyPositionsDialog(string objectName, string dialogText);
      void OnEvent(const int id,const long& lparam,const double& dparam,const string& sparam);
      bool Hide();
      bool Delete();
};
DialogWindow::DialogWindow(){
}
DialogWindow::~DialogWindow(){
}
bool DialogWindow::CreateModifyPositionsDialog(string objectName, string dialogText){
  
   _objectName = objectName;
   _dialogName = _objectName + _Dialog;
   _labelLine1Name = _objectName + _DialogLabelLine + "1";
   _labelLine2Name = _objectName + _DialogLabelLine + "2";
   _buyButtonName = _objectName + _BuyButton;
   _sellButtonName = _objectName + _SellButton;
   _dialogText = dialogText;
   _x =  (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS) / 2;
   _y = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS) / 2;
   if(Helper::IsObjectCreated(_dialogName)){
      _dialogWindow.Show();
      ChartRedraw(0);
      return true;
   }
   Delete();
   ChartRedraw(0);
   _dialogWindow.Create(0, _dialogName, 0, _x, _y, (_x + 420), (_y +200));
   int dotIndex = StringFind(_dialogText, ".") +1;
   _labelLine1.Create(0, _labelLine1Name, 0, 5, 5, 0, 0);
   _labelLine1.Text(StringSubstr(_dialogText, 0, dotIndex));
   _labelLine2.Create(0, _labelLine2Name, 0, 5, 30, 0, 0);
   _labelLine2.Text(StringSubstr(_dialogText, dotIndex, dialogText.Length()));
   _btnBuy.Create(0, _buyButtonName, 0, 50, 75, 300, 110);
   _btnBuy.Text("Buy positions");
   _btnSell.Create(0, _sellButtonName, 0, 50, 120, 300, 155);
   _btnSell.Text("Sell positions");
   _dialogWindow.Add(_labelLine1);
   _dialogWindow.Add(_labelLine2);
   _dialogWindow.Add(_btnBuy);
   _dialogWindow.Add(_btnSell);
   _dialogWindow.Caption("");
   _dialogWindow.Show();
   ChartRedraw(0);
   return true;
}
void DialogWindow::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   _dialogWindow.OnEvent(id, lparam, dparam, sparam);
   if(id == CHARTEVENT_OBJECT_CLICK){
      if(sparam == _btnBuy.Name()){
         app.SetModifyPositionsDirection(POSITION_TYPE_BUY);
         //Delete();
         Hide();
         ChartRedraw(0);
      }
      if(sparam == _btnSell.Name()){
         app.SetModifyPositionsDirection(POSITION_TYPE_SELL);
         //Delete();
         Hide();
         ChartRedraw(0);
      }
   }
}
bool DialogWindow::Hide(void){
   return _dialogWindow.Hide();
}
bool DialogWindow::Delete(void){
   if(Helper::IsObjectCreated(_dialogName)){
      _dialogWindow.Delete(_labelLine1);
      _dialogWindow.Delete(_labelLine2);
      _dialogWindow.Delete(_btnBuy);
      _dialogWindow.Delete(_btnSell);
   }
   if(Helper::IsObjectCreated(_labelLine1Name)) _labelLine1.Destroy();
   if(Helper::IsObjectCreated(_labelLine2Name)) _labelLine2.Destroy();
   if(Helper::IsObjectCreated(_buyButtonName)) _btnBuy.Destroy();
   if(Helper::IsObjectCreated(_sellButtonName)) _btnSell.Destroy();
   if(Helper::IsObjectCreated(_dialogName)) _dialogWindow.Destroy();
   ObjectsDeleteAll(0, _objectName, 0);
   ChartRedraw(0);
   return true;
}