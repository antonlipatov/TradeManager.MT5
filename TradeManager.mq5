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

input group "Visual chart settings"
input bool inputEnableCustomChartSettings = true; //Enable custom visual chart settings
input group "Risk per trade:"
input double inputRisk1 = 0.1; //Risk value 1
input double inputRisk2 = 0.25; //Risk value 2
input double inputRisk3 = 0.5; //Risk value 3*
input double inputRisk4 = 1.0; //Risk value 4
input double inputRisk5 = 1.5; //Risk value 5


ChartButtons chartButtons;
TradeLevels tradeLevels;
double entryLevelPrice = 0.0, stopLevelPrice = 0.0, persentOfRisk = 0.0;
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
   if(inputEnableCustomChartSettings) SetInitalVisualChartSettings();
   chartButtons.CreateChartButtons();
   persentOfRisk = inputRisk3;
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