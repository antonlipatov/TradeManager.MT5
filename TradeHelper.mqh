//+------------------------------------------------------------------+
//|                                                  TradeHelper.mqh |
//+------------------------------------------------------------------+
#include  <Trade/Trade.mqh>
#include  <Trade/OrderInfo.mqh>
#include  <Trade/PositionInfo.mqh>
#include  <Trade/AccountInfo.mqh>
 #include <Trade/SymbolInfo.mqh>
#include  <Expert\Money\MoneyFixedRisk.mqh>
class TradeHelper{
   private:
   public:
      TradeHelper();
      ~TradeHelper();
      static int CountOpenOrders();
      static void CancelOrders();
      static void ClosePositions();
      static int CountOpenPositions();
      static void CountOpenedBuysAndSellsPositions(int& buyPositions, int& sellPositions);
      static double CalculateLotSize(double entryPrice, double slPrice, double riskPercent);
      static bool MarginCheck(double lot, double price);
      static ENUM_ORDER_TYPE GetOrderType(double orderPrice, double slPrice);
      static double HighestLowestPositionPrice(ENUM_POSITION_TYPE direction, bool hl); 
      static double PositionsPnL(double price, ENUM_POSITION_TYPE direction);
      static bool SendPendingOrder(double orderPrice, double slPrice, double riskPercent);
      static bool ModifyPositions(double price, ENUM_POSITION_TYPE positionType, int flagTpSl);
      static double NormalizePrice(const double price);
      static int GetSpread();
      static bool OpenedPositionsQtyAndVol(int& buyPositionsQt, int& sellPositionsQt, double& buyPositionsVol, double& sellPositionsVol);
      static bool OpenedPositionsPnL(double& positionsPnl);
      static bool HasOpenedPositionsByCurrentSymbol();
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
double TradeHelper::HighestLowestPositionPrice(ENUM_POSITION_TYPE direction, bool hl){
   if(PositionsTotal() == 0) return 0;
   double lastPrice = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--){
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0){
         Print(__FUNCTION__, " -> Error getting position: ", GetLastError());
         continue;
      }
      if(PositionGetString(POSITION_SYMBOL) == _Symbol){
         if(PositionGetInteger(POSITION_TYPE) == direction ){
            double currentPositionPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            if(lastPrice == 0) lastPrice = currentPositionPrice;
            if(hl) 
               if(currentPositionPrice > lastPrice) lastPrice = currentPositionPrice;
            if(!hl) 
               if(currentPositionPrice < lastPrice) lastPrice = currentPositionPrice;
         } 
      }
   }
   return lastPrice;
}
double TradeHelper::PositionsPnL(double price,ENUM_POSITION_TYPE direction){
   double totalPnL = 0.0;
   if(PositionsTotal() == 0) return totalPnL;
   const string symbol = Symbol();
   for(int i = PositionsTotal()-1; i >= 0; i--){
      if(PositionGetSymbol(i) != symbol) continue;
      const ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      const double volume = PositionGetDouble(POSITION_VOLUME);
      const double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      if(type == direction){
         double pnL = 0;
         CAccountInfo info;
         if(direction == POSITION_TYPE_BUY)
            pnL = info.OrderProfitCheck(symbol, ORDER_TYPE_BUY, volume, openPrice, price);
         if(direction == POSITION_TYPE_SELL)
            pnL = info.OrderProfitCheck(symbol, ORDER_TYPE_SELL, volume, openPrice, price);         
         totalPnL +=  pnL;
      }
   }
   return totalPnL;
}
void TradeHelper::CountOpenedBuysAndSellsPositions(int &buyPositions,int &sellPositions){
   buyPositions = 0; 
   sellPositions = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--){
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) {
         Print(__FUNCTION__, " -> Error getting position: ", GetLastError());
         continue;
      }
      string positionSymbol = PositionGetString(POSITION_SYMBOL);
      if(positionSymbol == _Symbol){
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) buyPositions++;
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) sellPositions++;
      }
   }
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
ENUM_ORDER_TYPE TradeHelper::GetOrderType(double orderPrice,double slPrice){
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(orderPrice > askPrice && orderPrice > slPrice) return ORDER_TYPE_BUY_STOP;
   if(orderPrice > askPrice && orderPrice < slPrice) return ORDER_TYPE_SELL_LIMIT;
   if(orderPrice < bidPrice && orderPrice > slPrice) return ORDER_TYPE_BUY_LIMIT;
   if(orderPrice < bidPrice && orderPrice < slPrice) return ORDER_TYPE_SELL_STOP;
   return NULL;
}
bool TradeHelper::SendPendingOrder(double orderPrice, double slPrice, double riskPercent){
   bool result = false;
   if(orderPrice == 0 || slPrice == 0){
      Print(__FUNCTION__, " -> Error: incorrect entry or stoploss prices");
      return result;   
   }
   if(riskPercent == 0){
      Print(__FUNCTION__, " -> Error: incorrect risk % value");
      return result;    
   }
   double lotSize = CalculateLotSize(orderPrice, slPrice, riskPercent);
   if(lotSize == -1){
      Print(__FUNCTION__," -> Error: Unable to calculate lot size");
      return result;
   }
   ENUM_ORDER_TYPE orderType = GetOrderType(orderPrice, slPrice);
   CTrade trade;
   if(orderType == ORDER_TYPE_BUY_LIMIT) result = trade.BuyLimit(lotSize,orderPrice, _Symbol, slPrice);
   else if(orderType == ORDER_TYPE_BUY_STOP) result = trade.BuyStop(lotSize, orderPrice, _Symbol, slPrice);
   else if(orderType == ORDER_TYPE_SELL_STOP) result = trade.SellStop(lotSize, orderPrice, _Symbol, slPrice);
   else if(orderType == ORDER_TYPE_SELL_LIMIT) result = trade.SellLimit(lotSize, orderPrice, _Symbol, slPrice);
   Print("order sent");
   return result;
}
bool TradeHelper::ModifyPositions(double price,ENUM_POSITION_TYPE positionType,int flagTpSl){
   bool result = false;
   if(positionType == -1 || flagTpSl == 0) return result;
   for(int i = PositionsTotal() - 1; i >= 0; i--){
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0){
         Print(__FUNCTION__, " -> Error getting position #", i, ", error: ", GetLastError());
         continue;
      }
      if(PositionGetString(POSITION_SYMBOL) == _Symbol){
         if(PositionGetInteger(POSITION_TYPE) == positionType){
            double positionSL = PositionGetDouble(POSITION_SL);
            double positionTP = PositionGetDouble(POSITION_TP);
            CTrade trade;
            if(flagTpSl == 1)
               result = trade.PositionModify(ticket, positionSL, price);
            if(flagTpSl == 2)
               result = trade.PositionModify(ticket, price, positionTP);
         }
      }
   }
   return result;
}

double TradeHelper::NormalizePrice(const double price){
   double tickSize = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int digits = (int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(tickSize!=0)
      return(NormalizeDouble(MathRound(price/tickSize)*tickSize,digits));
   return(NormalizeDouble(price,digits));
}
int TradeHelper::GetSpread(void){
   CSymbolInfo info;
   info.Name(_Symbol);
   if(info.SpreadFloat()) return info.Spread();
   return -1;
}
bool TradeHelper::OpenedPositionsQtyAndVol(int &buyPositionsQt,
                                           int &sellPositionsQt,
                                           double &buyPositionsVol,
                                           double &sellPositionsVol){
   if(PositionsTotal() == 0) return false;                                         
   for(int i = PositionsTotal()-1; i >= 0; i--){
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) {
         Print(__FUNCTION__, " -> Error getting position #", i, ", error: ", GetLastError());
         continue;
      }
      string positionSymbol = PositionGetString(POSITION_SYMBOL);
      if(positionSymbol == _Symbol){
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY){
            buyPositionsQt++;
            buyPositionsVol =NormalizeDouble(buyPositionsVol + PositionGetDouble(POSITION_VOLUME), 2);
         }
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL){
            sellPositionsQt++;
            sellPositionsVol = NormalizeDouble(sellPositionsVol + PositionGetDouble(POSITION_VOLUME),2);
         }
      }
   }
   return true;
}
bool TradeHelper::OpenedPositionsPnL(double &positionsPnl){
   if(PositionsTotal() == 0 || !HasOpenedPositionsByCurrentSymbol()) return false;
   positionsPnl = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--){
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) {
         Print(__FUNCTION__, " -> Error getting position #", i, ", error: ", GetLastError());
         continue;
      }
      string positionSymbol = PositionGetString(POSITION_SYMBOL);
      if(positionSymbol == _Symbol){
         positionsPnl = NormalizeDouble(positionsPnl + PositionGetDouble(POSITION_PROFIT),2);
      }
   }
   return true;
}
bool TradeHelper::HasOpenedPositionsByCurrentSymbol(void){
   bool result = false;
   if(PositionsTotal() == 0) return result;
   for(int i = PositionsTotal()-1; i >= 0; i--){
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) {
         Print(__FUNCTION__, " -> Error getting position #", i, ", error: ", GetLastError());
         continue;
      }
      string positionSymbol = PositionGetString(POSITION_SYMBOL);
      if(positionSymbol == _Symbol) result = true;
   }
   return result;
}