//+------------------------------------------------------------------+
//|                                                  ChartLabels.mqh |
//+------------------------------------------------------------------+
#include <ChartObjects\ChartObjectsTxtControls.mqh>
class ChartLabel{
   private:
   #define _Label "_Label"
   string _objectName;
   string _labelName;
   string _text;
   int _x;
   int _y;
   int _fontSize;
   CChartObjectLabel _LabelText;
   bool createChartLabel(string objectName, int x, int y, string text, int fontSize);
   bool deleteChartLabek();
   public:
      ChartLabel();
      ~ChartLabel();
      bool Create(string objectName, int x, int y, string text, int fontSize);
      bool UpdateText(string value);
      bool IsLabelExist();
      bool Delete();
};
ChartLabel::ChartLabel(){}
ChartLabel::~ChartLabel(){}
bool ChartLabel::createChartLabel(string objectName, int x, int y, string text, int fontSize){
   _objectName = objectName;
   _labelName = _objectName + _Label;
   _x = x;
   _y = y;
   _text = text;
   _fontSize = fontSize;
   if(Helper::IsObjectCreated(_labelName)) return false;
   _LabelText.Create(0, _labelName, 0, _x, _y);
   _LabelText.FontSize(_fontSize);
   _LabelText.Color(clrWhite);
   UpdateText(_text);
    ChartRedraw(0);
   return true;
}
bool ChartLabel::deleteChartLabek(void){
   return _LabelText.Delete();
}
bool ChartLabel::Create(string objectName, int x, int y, string text, int fontSize){
   return createChartLabel(objectName, x, y, text, fontSize);
}
bool ChartLabel::Delete(void){
   return deleteChartLabek();
}
bool ChartLabel::IsLabelExist(void){
   if(Helper::IsObjectCreated(_labelName)) return true;
   return false;
}
bool ChartLabel::UpdateText(string value){
   if(Helper::IsObjectCreated(_labelName))
      return ObjectSetString(0, _labelName, OBJPROP_TEXT, value);
   return false; 
}