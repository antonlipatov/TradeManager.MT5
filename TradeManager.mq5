//+------------------------------------------------------------------+
//|                                                 TradeManager.mq5 |
//+------------------------------------------------------------------+
#include  <ChartObjects/ChartObjectsLines.mqh>
#include  <Controls/Dialog.mqh>
#include  <Controls/Button.mqh>
#include  <Controls/Edit.mqh>
#include <Controls/Label.mqh>
#include  <Trade/Trade.mqh>
#include  <Trade/OrderInfo.mqh>
#include  <Trade/PositionInfo.mqh>
#include  <ChartObjects/ChartObjectsTxtControls.mqh>
#include "ChartButtons.mqh/"
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
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason){
}