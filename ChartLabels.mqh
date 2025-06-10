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
   color _color;
   CChartObjectLabel _labelText;
   public:
      ChartLabel();
      ~ChartLabel();
      bool Create(string objectName, int x, int y, string text, int fontSize, color labelColor);
      bool UpdateText(string value);
      string GetLabelText();
      bool IsLabelExist();
      bool Delete();
};
ChartLabel::ChartLabel(){}
ChartLabel::~ChartLabel(){}
bool ChartLabel::Create(string objectName, 
                                  int x, 
                                  int y, 
                                  string text, 
                                  int fontSize, 
                                  color labelColor){
   _objectName = objectName;
   _labelName = _objectName + _Label;
   _x = x;
   _y = y;
   _text = text;
   _fontSize = fontSize;
   _color = labelColor;
   if(Helper::IsObjectCreated(_labelName)) return false;
   _labelText.Create(0, _labelName, 0, _x, _y);
   _labelText.FontSize(_fontSize);
   _labelText.Color(_color);
   _labelText.Background(true);
   _labelText.Selectable(false);
   _labelText.SetInteger(OBJPROP_ZORDER, 0);
   UpdateText(_text);
    ChartRedraw(0);
   return true;
}
bool ChartLabel::Delete(void){
   return _labelText.Delete();
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
string ChartLabel::GetLabelText(void){
   return ObjectGetString(0, _labelName, OBJPROP_TEXT);
}