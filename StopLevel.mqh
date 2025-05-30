//+------------------------------------------------------------------+
//|                                                    StopLevel.mqh |
//+------------------------------------------------------------------+
#include <ChartObjects\ChartObjectsLines.mqh>
class StopLevel{
   private:
      #define  _stopLevelUpLine "Stop Level Up Line"
      #define  _stopLevelDownLine "Stop Level Down Line"
      double _askPrice, _bidPrice;
      int _stopLevel;
      color _stopLevelUpLineColor;
      color _stopLevelDownLineColor;
      int _stopLevelLineWidth;
      CChartObjectHLine _hUpLine;
      CChartObjectHLine _hDownLine;
      void updatePrices();
   public:
      StopLevel();
      ~StopLevel();
      bool Create(color upLineColor, color downLineColor, int lineWidth);
      bool Update();
      void Tick();
      bool Delete();
};
StopLevel::StopLevel(){}
StopLevel::~StopLevel(){}
bool StopLevel::Create(color upLineColor, color downLineColor, int lineWidth){
   updatePrices();
   if(_stopLevel < 3) return false;
   _stopLevelUpLineColor = upLineColor;
   _stopLevelDownLineColor = downLineColor;
   _stopLevelLineWidth = lineWidth;
   if(Helper::IsObjectCreated(_stopLevelDownLine)) _hDownLine.Delete();
   if(Helper::IsObjectCreated(_stopLevelUpLine)) _hUpLine.Delete();
   _hUpLine.Create(0, _stopLevelUpLine, 0, _askPrice +(_stopLevel * _Point));
   _hDownLine.Create(0, _stopLevelDownLine, 0, _bidPrice - (_stopLevel * _Point));
   _hUpLine.Selectable(false);
   _hUpLine.Color(_stopLevelUpLineColor);
   _hUpLine.Width(_stopLevelLineWidth);
   _hDownLine.Selectable(false);
   _hDownLine.Color(_stopLevelDownLineColor);
   _hDownLine.Width(_stopLevelLineWidth);
   ChartRedraw(0);
   return true;
}
bool StopLevel::Update(void){
   updatePrices(); 
   _hUpLine.Price(0, _askPrice + (_stopLevel * _Point));
   _hDownLine.Price(0, _bidPrice - (_stopLevel * _Point));
   ChartRedraw(0);  
   return true;
}
bool StopLevel::Delete(void){
   _hUpLine.Delete();
   _hDownLine.Delete();
   ChartRedraw(0);
   return true;
}
void StopLevel::Tick(void){
   if(Helper::IsObjectCreated(_stopLevelDownLine) &&
      Helper::IsObjectCreated(_stopLevelUpLine) &&
      _stopLevel >= 3) Update();
}
void StopLevel::updatePrices(void){
   _askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   _bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   _stopLevel = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
} 