//+------------------------------------------------------------------+
//|                                                  TradeHelper.mqh |
//+------------------------------------------------------------------+
#include  <Trade/Trade.mqh>
#include  <Trade/OrderInfo.mqh>
#include  <Trade/PositionInfo.mqh>
class TradeHelper{
   private:
   public:
      TradeHelper();
      ~TradeHelper();
      static int CountOpenOrders();
      static void CancelOrders();
      static void ClosePositions();
      static int CountOpenPositions();
      static double CalculateLotSize(double entryPrice, double slPrice, double riskPercent);
      static bool MarginCheck(double lot, double price);
};
TradeHelper::TradeHelper(){
}
TradeHelper::~TradeHelper(){
}
int TradeHelper::CountOpenOrders(){
   int count = 0;
   string currentSymbol = _Symbol;
   for(int i = OrdersTotal()-1; i >= 0; i--){
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0){
         Print(__FUNCTION__, " -> Error receiving order: ", GetLastError());
         continue;
      }
      string orderSymbol = OrderGetString(ORDER_SYMBOL);
      if(orderSymbol == currentSymbol)
      count++;
   }
   return count;
}
int TradeHelper::CountOpenPositions(void){
   if(PositionsTotal() == 0) return 0;
   int count = 0;
   string currentSymbol = _Symbol;
   for(int i = PositionsTotal()-1; i >= 0; i--){
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0){
         Print(__FUNCTION__, " -> Error getting position: ", GetLastError());
         continue;
      }
      string positionSymbol = PositionGetString(POSITION_SYMBOL);
      if(positionSymbol == currentSymbol)
         count++;
   }
   return count;
}
void TradeHelper::CancelOrders(void){
   int ordersTotal = OrdersTotal();
   if(ordersTotal == 0) return;
   CTrade removeOrder;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      ulong orderTicket = OrderGetTicket(i);
      if(OrderSelect(orderTicket)){
         ResetLastError();
         if(OrderGetString(ORDER_SYMBOL) != _Symbol) continue;
         ENUM_ORDER_TYPE orderType = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
         if(orderType <= ORDER_TYPE_SELL) continue;
         if(!removeOrder.OrderDelete(orderTicket))
            Print(__FUNCTION__, " -> Failed to delete order ", orderTicket, ", error: ", GetLastError());
         else
            i = OrdersTotal();
      }
   }
}
void TradeHelper::ClosePositions(void){
   if(PositionsTotal() == 0) return;
   for(int i = PositionsTotal() - 1; i >= 0; i--){
      ResetLastError();
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0){
         Print(__FUNCTION__, " -> Error getting position #", i, ", error: ", GetLastError());
         continue;
      }
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      CTrade trade;
      if(!trade.PositionClose(ticket))
         Print(__FUNCTION__, " -> Failed to close position ", ticket, ", error: ", trade.ResultRetcodeDescription());
      else{
         Print(__FUNCTION__, " -> Position closed: ", ticket);
         i = PositionsTotal();
      }
   }
}double TradeHelper::CalculateLotSize(double entryPrice,double slPrice,double riskPercent){
         double result = -1;
         //check incoming parameters
         if(riskPercent <= 0 || riskPercent > 100){
            Print(__FUNCTION__, " - > Incorrect % risk");
            return result;
         }
         if(entryPrice == slPrice){
            Print(__FUNCTION__, " - > Incorrect Entry or SL price");
            return result;
         }
         //get risk in money
         double riskMoney = AccountInfoDouble(ACCOUNT_BALANCE) * riskPercent / 100;
         //get tick size and value
         double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
         double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
         double pointValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
         //volume step
         double volimeStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
         //get min, max, limit of volume
         double volumeMin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
         double volumeMax = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
         double volumeLimit = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_LIMIT);
         //Ticks
         double priceDifference = MathAbs(entryPrice - slPrice);
         int ticks =(int)(priceDifference / tickSize);
         //risk
         double riskPerLot = ticks * tickValue;
         if(riskPerLot == 0){
            Print(__FUNCTION__, " - > Zero risk per lot error.");
            return result;
         }
         //lots
         double lotSize = riskMoney / riskPerLot;
         //Rounding lot size to volume step
         lotSize = volimeStep * MathFloor(lotSize / volimeStep);
         //fix min/max lot size volume
         lotSize = MathMax(lotSize, volumeMin);
         lotSize = MathMin(lotSize, volumeMax);
         //check margin
         if(!MarginCheck(lotSize, entryPrice)){
            Print(__FUNCTION__, " - > Error: Not enough funds to open a position.");
            return result;
         }
         if(volimeStep == 0.1)
            lotSize = NormalizeDouble(lotSize, 1);
         else
         if(volimeStep == 0.01)
            lotSize = NormalizeDouble(lotSize, 2);
         else
            lotSize = NormalizeDouble(lotSize, 2);
         result = lotSize;
         return result;
}
bool TradeHelper::MarginCheck(double lot,double price){
   double marginRequired;
   if(!OrderCalcMargin(ORDER_TYPE_BUY, _Symbol, lot, price, marginRequired)){
      Print(__FUNCTION__, " -> Margin calculation error");
      return false;
   }
   double freeMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   return(marginRequired < freeMargin);
}