
#include <trade/trade.mqh>

// Input parameters
input double account_balance = 5000;
input double risk_per_trade = 20.0;
input int x_points_stoploss = 15;

CTrade trade;

void OnTick(){
   
   // Buy Button Position
   ObjectCreate(0,"BUY_BUTTON",OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,"BUY_BUTTON",OBJPROP_XDISTANCE,200);
   ObjectSetInteger(0,"BUY_BUTTON",OBJPROP_XSIZE,200);
   ObjectSetInteger(0,"BUY_BUTTON",OBJPROP_YDISTANCE,50);
   ObjectSetInteger(0,"BUY_BUTTON",OBJPROP_YSIZE,50);
   ObjectSetInteger(0,"BUY_BUTTON",OBJPROP_CORNER,4);
   ObjectSetString(0,"BUY_BUTTON",OBJPROP_TEXT,"Buy");
   
   // Sell Button Position
   ObjectCreate(0,"SELL_BUTTON",OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,"SELL_BUTTON",OBJPROP_XDISTANCE,200);
   ObjectSetInteger(0,"SELL_BUTTON",OBJPROP_XSIZE,200);
   ObjectSetInteger(0,"SELL_BUTTON",OBJPROP_YDISTANCE,50);
   ObjectSetInteger(0,"SELL_BUTTON",OBJPROP_YSIZE,50);
   ObjectSetInteger(0,"SELL_BUTTON",OBJPROP_CORNER,1);
   ObjectSetString(0,"SELL_BUTTON",OBJPROP_TEXT,"Sell");
}

double CalculateLotSize(double entry, double lowestLow, double stopLoss) {
    double riskAmount = risk_per_trade;
    double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double actualStopLossPips = MathAbs(entry - stopLoss) / SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    double lotSize = riskAmount / (actualStopLossPips * pipValue);
    return lotSize;
}

double CalculateLotSizeS(double entry, double highestHigh, double stopLoss) {
    double riskAmount = risk_per_trade;
    double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double actualStopLossPips = MathAbs(entry - stopLoss) / SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    double lotSize = riskAmount / (actualStopLossPips * pipValue);
    return lotSize;
}


//event handling
void OnChartEvent(const int id,const long &lparam, const double &dparam,const string &sparam){
   
   if(id == CHARTEVENT_OBJECT_CLICK){
      string ClickedObjectname = sparam;
      if(sparam == "BUY_BUTTON"){
          double entry = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
          entry = NormalizeDouble(entry, _Digits);
          double lowest_low = iLow(_Symbol, PERIOD_CURRENT, 1);
          double stop_loss = lowest_low - x_points_stoploss * _Point;
          double take_profit = entry + 3 * (entry - stop_loss);
      
          double lotSize = CalculateLotSize(entry, lowest_low, stop_loss);
          lotSize = NormalizeDouble(lotSize, 1);
      
          Print("Lot size: ", lotSize);
          double stop_loss_pips = (entry - stop_loss) / _Point;
          Print("Order send for BuySide with lotsize",lotSize);
          trade.Buy(lotSize, NULL, 0.0, stop_loss, take_profit, "BUY_DONE");
         
      }else if(sparam == "SELL_BUTTON"){
         double entry = SymbolInfoDouble(_Symbol, SYMBOL_BID); 
          entry = NormalizeDouble(entry, _Digits);
          double highest_high = iHigh(_Symbol, PERIOD_CURRENT, 1);
          double stop_loss = highest_high + x_points_stoploss * _Point; 
          double take_profit = entry - 3 * (stop_loss - entry); 
      
          double lotSize = CalculateLotSizeS(entry, highest_high, stop_loss);
          lotSize = NormalizeDouble(lotSize, 1);
      
          Print("Lot size: ", lotSize);
          double stop_loss_pips = (stop_loss - entry) / _Point; 
      
          trade.Sell(lotSize, NULL, 0.0, stop_loss, take_profit, "SELL_DONE"); 
        }
   }

}

