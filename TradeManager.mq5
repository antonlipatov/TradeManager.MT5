//+------------------------------------------------------------------+
//|                                                 TradeManager.mq5 |
//+------------------------------------------------------------------+
#include  "Application.mqh/"

input group "Visual chart settings:"
input bool inputEnableCustomChartSettings = true; //Enable custom visual chart settings
input bool inputShowWatermark = true; //Show watermark
input color inputWatermarkLabelColor = C'90,90,90'; //Watermark label color
input group "Visual trade levels settings:"
input color inputPendingOrderColor = clrGold; //Pending order level color
input int inputPendingOrderLineWidth = 1; //Pending order level line width
input color inputPendingOrderLabelColor = clrWhite; //Pending order level text color
input color inputStoplossColor = clrRed; //Stoploss level color
input int inputStoplossLineWidth = 1; //Stoploss level line width
input color inputStoplossLabelColor = clrWhite; //Stoploss level text color
input color inputModifyPositionsColor = clrGray; //Modify positions level color
input int inputModifyPositionsLineWidth = 1; //Modify positions level line width
input color inputModifyPositionsLabelColor = clrWhite; //Modify positions level text color
input group "Risk % per trade:"
input double inputRisk1 = 0.1; //Risk value 1
input double inputRisk2 = 0.25; //Risk value 2
input double inputRisk3 = 0.5; //Risk value 3*
input double inputRisk4 = 1.0; //Risk value 4
input double inputRisk5 = 1.5; //Risk value 5
input group "Text information on chart:"
input bool inputShowPositionsQtLabel = true; //Show opened positions quantity and volume
input bool inputShowSpread = true; //Show spread
input group "Stop level:"
input bool inputShowStopLevels = true; //Show stop levels
input color inputStopLevelUpLineColor = clrLightCoral; //Up line color
input color inputStopLevelDownLineColor = clrLightGreen; //Down line color
input int inputStopLevelLineWidth = 1; //Line width
Application app;

int OnInit(){
   app.Init(inputRisk1, 
            inputRisk2, 
            inputRisk3, 
            inputRisk4, 
            inputRisk5, 
            inputEnableCustomChartSettings,
            inputPendingOrderColor,
            inputPendingOrderLineWidth,
            inputPendingOrderLabelColor,
            inputStoplossColor,
            inputStoplossLineWidth,
            inputStoplossLabelColor,
            inputModifyPositionsColor,
            inputModifyPositionsLineWidth,
            inputModifyPositionsLabelColor,
            inputShowPositionsQtLabel,
            inputShowSpread,
            inputShowStopLevels,
            inputStopLevelUpLineColor,
            inputStopLevelDownLineColor,
            inputStopLevelLineWidth,
            inputShowWatermark,
            inputWatermarkLabelColor);
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason){
   app.Deinit();
}
void OnTrade(void){
   app.OnTradeEvent();
}
void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam){
   app.OnEvent(id, lparam, dparam, sparam);  
}
void OnTick(void){
   app.Tick();
}