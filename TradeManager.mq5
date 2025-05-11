//+------------------------------------------------------------------+
//|                                                 TradeManager.mq5 |
//+------------------------------------------------------------------+
#include  <Controls/Dialog.mqh>
#include  <Controls/Edit.mqh>
#include <Controls/Label.mqh>


#include "Helper.mqh/"
#include "TradeHelper.mqh/"
#include "ChartButtons.mqh/"
#include "TradeLevels.mqh/"
double entryPrice = 0.0;
double stopLossPrice = 0.0;
ChartButtons chartButtons;
TradeLevels tradeLevels;
//Inital visual chart setup
void SetInitalVisualChartSettings(){
   ChartSetInteger(0, CHART_COLOR_BACKGROUND, C'20,23,23');
   ChartSetInteger(0, CHART_SHOW_GRID, false);
   ChartSetInteger(0, CHART_SHOW_VOLUMES, false);
   ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, true);
   ChartSetInteger(0, CHART_SHOW_ASK_LINE, true);
   ChartSetInteger(0, CHART_SHOW_BID_LINE, true);
   ChartSetInteger(0, CHART_SHOW_LAST_LINE, true);
   ChartSetInteger(0, CHART_SHOW_ONE_CLICK, true);
   ChartSetInteger(0, CHART_SHOW_TRADE_LEVELS, true);
   ChartSetInteger(0, CHART_SHIFT, true);
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   ChartSetDouble(0, CHART_SHIFT_SIZE, 5);
   ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrLightGray);
   ChartSetInteger(0, CHART_COLOR_CHART_UP, clrWhite);
   ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrGold);
   ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrDodgerBlue);
   ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrWhite);
   ChartSetInteger(0, CHART_COLOR_ASK, clrLightCoral);
   ChartSetInteger(0, CHART_COLOR_BID, clrLightBlue);
   ChartSetInteger(0, CHART_COLOR_LAST, clrYellow);
}
int OnInit(){
   SetInitalVisualChartSettings();
   chartButtons.CreateChartButtons();
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason){
   chartButtons.DeleteAll();
   tradeLevels.DeleteLevels();
}
void OnTrade(void){
   chartButtons.OnTradeEvent();
}
void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam){
   chartButtons.OnEvent(id, lparam, dparam, sparam);
   tradeLevels.OnEvent(id, lparam, dparam, sparam);   
}