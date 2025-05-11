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
}