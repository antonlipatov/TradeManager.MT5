//+------------------------------------------------------------------+
//|                                                  Application.mqh |
//+------------------------------------------------------------------+
#include "Helper.mqh/"
#include "TradeHelper.mqh/"
#include "ChartButtons.mqh/"
#include "ChartLabels.mqh/"
#include  "TradeLevel.mqh/"
#include  "DialogWindow.mqh/"
#include "StopLevel.mqh/"
#define  PendingOrderLevel "PendingOrderLevel"
#define  StopLossLevel "StopLossLevel"
#define  ModifyPositionsLevel "ModifyPositionsLevel"
#define  ModifyPositionsDirectionDialog "ModifyPositionsDirectionDialog"
#define  SpreadLabel "SpreadLabel"
#define  PositionsQtLabel "PositionsQtLabel"
#define  WatermarkLabel "WatermarkLabel"
class Application{
   private:
      double _riskValue1;
      double _riskValue2;
      double _riskValue3;
      double _riskValue4;
      double _riskValue5;
      double _pendingOrderPrice;
      double _slPrice;
      double _modifyPositionsPrice;
      double _riskPersent;
      ChartButtons _chartButtons;
      TradeLevel _pendingOrderLevel;
      DialogWindow _dialogModifyPositionsDirection;
      StopLevel _stopLevel;
      color _pendingLevelColor;
      int _pendingLevelLineWidth;
      color _pendingLabelColor;
      TradeLevel _stopLossLevel;
      color _stoplossLevelColor;
      int _stoplossLevelLineWidth;
      color _stoplossLabelColor;
      TradeLevel _modifyPositionsLevel;
      color _modifyPositionsLevelColor;
      int _modifyPositionsLevelLineWidth;
      color _modifyPositionsLabelColor;
      ENUM_POSITION_TYPE _modifyPositionsDirection;
      int _modifyPositionsFlagTpSl;
      bool _showPositionsQtLabel;
      bool _showSpread;
      bool _showStopLevels;
      color _stopLevelUpLineColor;
      color _stopLevelDownLineColor;
      int _stopLevelLineWidth;
      bool _showWatermark;
      color _watermarkLabelColor;
      color _labelsColor;
      ChartLabel _lblSpread;
      ChartLabel _lblPositionsQt;
      ChartLabel _lblWatermark;
      bool setInitalVisualChartSettings();
      bool updateLevelsText();
      string generateStoplossLevelText();
      string generateModifyPositionsLevelText(bool tpsl);
      void updateModifyPositionsDirection();
      void showSpreadOnChart();
      void showPositionsQtOnChart();
      void showWatermarkOnChart();
   public:
      bool PlacingPendingOrderLevel;
      bool PlacingStoplossLevel;
      bool PlacingModifyPositionsLevel;
      Application();
      ~Application();
      void Init(double riskValue1, 
                double riskValue2, 
                double riskValue3, 
                double riskValue4, 
                double riskValue5, 
                bool loadVisualChartSettings, 
                color pendingLevelColor, 
                int pendingLevelLineWidth, 
                color pendingLabelColor, 
                color stoplossLevelColor, 
                int stoplossLevelLineWidth, 
                color stoplossLabelColor, 
                color modifyPositionsLevelColor, 
                int modifyPositionsLevelLineWidth, 
                color modifyPositionsLabelColor,
                bool showPositionsQtLabel,
                bool showSpread,
                bool showStopLevels,
                color stopLevelUpLineColor,
                color stopLevelDownLineColor,
                int stopLevelLineWidth,
                bool showWatermark,
                color watermarkLabelColor,
                color labelsColor);
      void OnEvent(const int id,const long& lparam,const double& dparam,const string& sparam);
      void Deinit();
      void OnTradeEvent();
      void Tick();
      double GetRiskPersent();
      double GetPendingOrderPrice();
      double GetStoplossPrice();
      double GetModifyPositionsPrice();
      int GetModifyPositionsFlagTpSl();
      bool GetRiskValues(double& riskValues[]);
      void SetRiskPersent(double value);
      ENUM_POSITION_TYPE GetModifyPositionsDirection();
      void SetModifyPositionsDirection(ENUM_POSITION_TYPE value);
};
Application::Application(){
}
Application::~Application(){
}
bool Application::updateLevelsText(void){
   //get bid and ask price
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(_pendingOrderLevel.IsLevelExist() && _stopLossLevel.IsLevelExist()){
      string pendingLabelValue, stoplossLabelValue;
      if(_pendingOrderPrice < bidPrice && _slPrice < _pendingOrderPrice)
         pendingLabelValue = "Buy limit: " + (string)_pendingOrderPrice;
      if(_pendingOrderPrice < bidPrice && _slPrice > _pendingOrderPrice)
         pendingLabelValue = "Sell stop: " + (string)_pendingOrderPrice;
      if(_pendingOrderPrice > askPrice && _slPrice > _pendingOrderPrice)
         pendingLabelValue = "Sell limit: " + (string)_pendingOrderPrice;
      if(_pendingOrderPrice > askPrice && _slPrice < _pendingOrderPrice)
         pendingLabelValue = "Buy stop: " + (string)_pendingOrderPrice;
      stoplossLabelValue = generateStoplossLevelText();
      _pendingOrderLevel.UpdateText(pendingLabelValue);
      _stopLossLevel.UpdateText(stoplossLabelValue);
   }
   if(_modifyPositionsLevel.IsLevelExist()){
      double highestPositionPrice = TradeHelper::HighestLowestPositionPrice(_modifyPositionsDirection, true);
      double lowestPositionPrice = TradeHelper::HighestLowestPositionPrice(_modifyPositionsDirection, false);
      if(_modifyPositionsDirection == POSITION_TYPE_BUY){
         if(_modifyPositionsPrice > highestPositionPrice &&
            _modifyPositionsPrice > askPrice){
            _modifyPositionsFlagTpSl = 1;
            _modifyPositionsLevel.UpdateText(generateModifyPositionsLevelText(true));
         }
         
         if((_modifyPositionsPrice < lowestPositionPrice &&
            _modifyPositionsPrice < bidPrice) ||
            (_modifyPositionsPrice > highestPositionPrice &&
             _modifyPositionsPrice < bidPrice)){
            _modifyPositionsFlagTpSl = 2;
            _modifyPositionsLevel.UpdateText(generateModifyPositionsLevelText(false));
         }
         if((_modifyPositionsPrice < highestPositionPrice && 
            _modifyPositionsPrice > lowestPositionPrice) ||
            (_modifyPositionsPrice >= bidPrice && _modifyPositionsPrice <= askPrice)){
            _modifyPositionsFlagTpSl = 0;
            _modifyPositionsLevel.UpdateText("Modify positions");
         }
      }
      if(_modifyPositionsDirection == POSITION_TYPE_SELL){
         if(_modifyPositionsPrice < lowestPositionPrice &&
            _modifyPositionsPrice < bidPrice){
            _modifyPositionsFlagTpSl = 1;
            _modifyPositionsLevel.UpdateText(generateModifyPositionsLevelText(true));
         }
         if((_modifyPositionsPrice > highestPositionPrice &&
            _modifyPositionsPrice > askPrice) ||
            (_modifyPositionsPrice < lowestPositionPrice &&
             _modifyPositionsPrice > askPrice)) {
            _modifyPositionsFlagTpSl = 2;
            _modifyPositionsLevel.UpdateText(generateModifyPositionsLevelText(false));
         }
         if((_modifyPositionsPrice < highestPositionPrice && 
            _modifyPositionsPrice > lowestPositionPrice) ||
            (_modifyPositionsPrice >= bidPrice && 
             _modifyPositionsPrice <= askPrice)){
            _modifyPositionsFlagTpSl = 0;
            _modifyPositionsLevel.UpdateText("Modify positions");
         }
      }
   }
   return true;
}
string Application::generateStoplossLevelText(void){
   double entryPrice = _pendingOrderPrice;
   double slPrice = _slPrice;
   double risk = _riskPersent;
   double riskMoney = AccountInfoDouble(ACCOUNT_BALANCE) * risk / 100;
   string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
   double lots = TradeHelper::CalculateLotSize(entryPrice, slPrice, risk);
   return "SL: " + (string)NormalizeDouble(slPrice, _Digits) + " "+ (string)NormalizeDouble(lots, 2) + " lots " + (string)NormalizeDouble(riskMoney,2) + " " +  accountCurrency;
}
string  Application::generateModifyPositionsLevelText(bool tpsl){
   string direction = _modifyPositionsDirection == POSITION_TYPE_BUY ? "buy": "sell";
   if(tpsl) return "Modify " + direction + " positions TP: " + (string)_modifyPositionsPrice + " PnL: " + (string)TradeHelper::PositionsPnL(_modifyPositionsPrice, _modifyPositionsDirection) + " " + AccountInfoString(ACCOUNT_CURRENCY);
   if(!tpsl) return "Modify " + direction + " positions SL: " + (string)_modifyPositionsPrice+ " PnL: " + (string)TradeHelper::PositionsPnL(_modifyPositionsPrice, _modifyPositionsDirection) + " " + AccountInfoString(ACCOUNT_CURRENCY);
   return "Modify positions";
}
void Application::Init(double riskValue1,
                       double riskValue2,
                       double riskValue3,
                       double riskValue4,
                       double riskValue5,
                       bool loadVisualChartSettings,
                       color pendingLevelColor,
                       int pendingLevelLineWidth,
                       color pendingLabelColor,
                       color stoplossLevelColor,
                       int stoplossLevelLineWidth,
                       color stoplossLabelColor,
                       color modifyPositionsLevelColor,
                       int modifyPositionsLevelLineWidth,
                       color modifyPositionsLabelColor,
                       bool showPositionsQtLabel,
                       bool showSpread,
                       bool showStopLevels,
                       color stopLevelUpLineColor,
                       color stopLevelDownLineColor,
                       int stopLevelLineWidth,                
                       bool showWatermark,
                       color watermarkLabelColor,
                       color labelsColor){
   _riskValue1 = riskValue1;
   _riskValue2 = riskValue2;
   _riskValue3 = riskValue3;
   _riskValue4 = riskValue4;
   _riskValue5 = riskValue5;
   _riskPersent = riskValue3;
   _pendingLevelColor = pendingLevelColor;
   _pendingLevelLineWidth = pendingLevelLineWidth;
   _pendingLabelColor = pendingLabelColor;
   _stoplossLevelColor = stoplossLevelColor;
   _stoplossLevelLineWidth = stoplossLevelLineWidth;
   _stoplossLabelColor = stoplossLabelColor;
   _modifyPositionsLevelColor = modifyPositionsLevelColor;
   _modifyPositionsLevelLineWidth = modifyPositionsLevelLineWidth;
   _modifyPositionsLabelColor = modifyPositionsLabelColor;
   _pendingOrderPrice = 0;
   _modifyPositionsPrice = 0;
   _slPrice = 0;
   _modifyPositionsFlagTpSl = 0;
   _showPositionsQtLabel = showPositionsQtLabel;
   _showSpread = showSpread;
   _showStopLevels = showStopLevels;
   _stopLevelUpLineColor = stopLevelUpLineColor;
   _stopLevelDownLineColor = stopLevelDownLineColor;
   _stopLevelLineWidth = stopLevelLineWidth;
   _showWatermark = showWatermark;
   _watermarkLabelColor = watermarkLabelColor;
   _labelsColor = labelsColor;
   if(loadVisualChartSettings) setInitalVisualChartSettings();
   PlacingPendingOrderLevel = false;
   PlacingStoplossLevel = false;
   PlacingModifyPositionsLevel = false;
   _modifyPositionsDirection = -1;
   _chartButtons.CreateChartButtons();
   showSpreadOnChart();
   showPositionsQtOnChart();
   if(_showStopLevels)
      _stopLevel.Create(_stopLevelUpLineColor, _stopLevelDownLineColor, _stopLevelLineWidth);
   if(_showWatermark) showWatermarkOnChart();
}
void Application::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
    _chartButtons.OnEvent(id, lparam, dparam, sparam);
   _pendingOrderLevel.OnEvent(id, lparam, dparam, sparam);
   _stopLossLevel.OnEvent(id, lparam, dparam, sparam);
   _modifyPositionsLevel.OnEvent(id, lparam, dparam, sparam);
   _dialogModifyPositionsDirection.OnEvent(id, lparam, dparam, sparam);
   if(id == CHARTEVENT_CLICK){
      if(PlacingPendingOrderLevel) {
         if(_modifyPositionsLevel.IsLevelExist()){
            PlacingPendingOrderLevel = false;
            return;
         }
         _pendingOrderLevel.Create(PendingOrderLevel, lparam, dparam, 1, _pendingLevelColor, _pendingLevelLineWidth, _pendingLabelColor);
         PlacingPendingOrderLevel = false;
         _pendingOrderPrice = _pendingOrderLevel.GetPrice();
         _pendingOrderLevel.IsDragable = false;
         PlacingStoplossLevel = true;
         return;
      }
      if(PlacingStoplossLevel){
         _stopLossLevel.Create(StopLossLevel, lparam, dparam, 2, _stoplossLevelColor, _stoplossLevelLineWidth, _stoplossLabelColor);
         PlacingStoplossLevel = false;
         _slPrice = _stopLossLevel.GetPrice();
         _pendingOrderLevel.IsDragable = true;
         _stopLossLevel.IsDragable = true;
         updateLevelsText();
         ChartRedraw(0);
         return;
      }
      if(PlacingModifyPositionsLevel){
         if(_pendingOrderLevel.IsLevelExist() || _stopLossLevel.IsLevelExist()){
            PlacingModifyPositionsLevel = false;
            return;
         }
         _modifyPositionsLevel.Create(ModifyPositionsLevel, lparam, dparam, 3, _modifyPositionsLevelColor, _modifyPositionsLevelLineWidth, _modifyPositionsLabelColor);
         PlacingModifyPositionsLevel = false;
         _modifyPositionsPrice = _modifyPositionsLevel.GetPrice();
         _modifyPositionsLevel.IsDragable = true;
         updateModifyPositionsDirection();
         updateLevelsText();
         ChartRedraw(0);
         return;
      }
   }
   if(id > CHARTEVENT_CUSTOM){
      CustomEvents event = (CustomEvents)(id - CHARTEVENT_CUSTOM);
      if(event== DeleteLevel_EVENT)
         if(sparam == PendingOrderLevel) _stopLossLevel.Delete();
      if(event == PriceUpdate_EVENT){
         if(sparam == PendingOrderLevel) _pendingOrderPrice = dparam;
         if(sparam == StopLossLevel) _slPrice = dparam;
         if(sparam == ModifyPositionsLevel) _modifyPositionsPrice = dparam;
      }
      if(event == UpdateTextLevel_EVENT) updateLevelsText();    
   }
   if(id == CHARTEVENT_CHART_CHANGE){
      _lblSpread.Delete();
      showSpreadOnChart();
      _lblPositionsQt.Delete();
      showPositionsQtOnChart();
      _lblWatermark.Delete();
      if(_showWatermark) showWatermarkOnChart();
   }
}
void Application::Deinit(void){
   _chartButtons.Delete();
   _pendingOrderLevel.Delete();
   _stopLossLevel.Delete();
   _modifyPositionsLevel.Delete();
   _dialogModifyPositionsDirection.Delete();
   _lblSpread.Delete();
   _lblPositionsQt.Delete();
   _stopLevel.Delete();
   _lblWatermark.Delete();
}
void Application::OnTradeEvent(void){
   _chartButtons.OnTradeEvent();
   showPositionsQtOnChart();
}
void Application::Tick(void){
   if(_lblSpread.IsLabelExist()) _lblSpread.UpdateText("Spread: " +(string)TradeHelper::GetSpread());
   if(_showStopLevels) _stopLevel.Update();
}
double Application::GetRiskPersent(void){
   return _riskPersent;
}
double Application::GetPendingOrderPrice(void){
   return _pendingOrderPrice;
}
double Application::GetStoplossPrice(void){
   return _slPrice;
}
double Application::GetModifyPositionsPrice(void){
   return _modifyPositionsPrice;
}
int Application::GetModifyPositionsFlagTpSl(void){
   return _modifyPositionsFlagTpSl;
}
bool Application::GetRiskValues(double &riskValues[]){
   if(ArrayResize(riskValues, 5) == -1) return false;
   riskValues[0] = _riskValue1;
   riskValues[1] = _riskValue2;
   riskValues[2] = _riskValue3;
   riskValues[3] = _riskValue4;
   riskValues[4] = _riskValue5;
   return true;
}
void Application::SetRiskPersent(double value){
   _riskPersent = value;
}
ENUM_POSITION_TYPE Application::GetModifyPositionsDirection(void){
   return _modifyPositionsDirection;
}
void Application::SetModifyPositionsDirection(ENUM_POSITION_TYPE value){
   _modifyPositionsDirection = value;
}
void Application::updateModifyPositionsDirection(void){
   if(_modifyPositionsPrice == 0) return;
   int buys, sells;
   TradeHelper::CountOpenedBuysAndSellsPositions(buys, sells);
   Print("b: ", buys, " s: ", sells);
   if(buys > 0 && sells == 0) SetModifyPositionsDirection(POSITION_TYPE_BUY);
   if(buys == 0 && sells > 0) SetModifyPositionsDirection(POSITION_TYPE_SELL);
   if(buys > 0 && sells > 0) _dialogModifyPositionsDirection.CreateModifyPositionsDialog(ModifyPositionsDirectionDialog, "Opened buys and sells positions on " + _Symbol+ ".Chouse positions direction to modify.");
   Print(_modifyPositionsDirection);
}
void Application::showSpreadOnChart(void){
   if(!_showSpread) return;
   int spread = TradeHelper::GetSpread();
   if(spread == -1) return;
   int x = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS) - 140;
   int y = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS) - 30; 
   _lblSpread.Create(SpreadLabel, x, y, "Spread: " + (string)spread, 10, _labelsColor);
}
void Application::showPositionsQtOnChart(void){
   if(!_showPositionsQtLabel) return;
   bool openedPositions = (TradeHelper::CountOpenPositions() > 0)? true: false;
   if(TradeHelper::CountOpenPositions() > 0){ 
      int x = 10 ; 
      int y = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS) - 35 ;
      int buysQt = 0, sellsQt = 0;
      double buysVol = 0, sellsVol = 0;
      TradeHelper::OpenedPositionsQtyAndVol(buysQt, sellsQt, buysVol, sellsVol);
      string qtVol = ((buysQt > 0)? ((string)buysQt  + ":" + (string)buysVol): ("-:--")) + " / " + ((sellsQt > 0)? ("-" + (string)sellsQt  + ":" + (string)sellsVol): ("-:--"));
      if(!_lblPositionsQt.IsLabelExist())
         _lblPositionsQt.Create(PositionsQtLabel, x, y, qtVol, 14, _labelsColor);
      _lblPositionsQt.UpdateText(qtVol);
      ChartRedraw(0);
   }
   if(TradeHelper::CountOpenPositions() <= 0)
      if(_lblPositionsQt.IsLabelExist())
         _lblPositionsQt.Delete();
}
void Application::showWatermarkOnChart(void){
   int x = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS) /2;
   int y = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS) /2; 
   _lblWatermark.Create(WatermarkLabel, x, y, (_Symbol + ", " + StringSubstr(EnumToString(ChartPeriod(0)), 7) ), 25, _watermarkLabelColor);
}
bool Application::setInitalVisualChartSettings(void){
if(ChartSetInteger(0, CHART_COLOR_BACKGROUND, C'20,23,23') &&
   ChartSetInteger(0, CHART_SHOW_GRID, false) &&
   ChartSetInteger(0, CHART_SHOW_VOLUMES, false) &&
   ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, true) &&
   ChartSetInteger(0, CHART_SHOW_ASK_LINE, true) &&
   ChartSetInteger(0, CHART_SHOW_BID_LINE, true) &&
   ChartSetInteger(0, CHART_SHOW_LAST_LINE, true) &&
   ChartSetInteger(0, CHART_SHOW_ONE_CLICK, true) &&
   ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, true) &&
   ChartSetInteger(0, CHART_SHIFT, true) &&
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true) &&
   ChartSetInteger(0, CHART_EVENT_OBJECT_DELETE, true) &&
   ChartSetDouble(0, CHART_SHIFT_SIZE, 5) &&
   ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrLightGray) &&
   ChartSetInteger(0, CHART_COLOR_CHART_UP, clrWhite) &&
   ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrGold) &&
   ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrDodgerBlue) &&
   ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrWhite) &&
   ChartSetInteger(0, CHART_COLOR_ASK, clrLightCoral) &&
   ChartSetInteger(0, CHART_COLOR_BID, clrLightBlue) &&
   ChartSetInteger(0, CHART_COLOR_LAST, clrYellow)) return true;
   return false;
}