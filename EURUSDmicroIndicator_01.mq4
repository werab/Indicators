//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Moving Averages Convergence/Divergence"
#property strict

// #include <MovingAverages.mqh>

//--- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1  Silver
//--- indicator parameters
input int rsiPeriod = 14;

//input string ParamsAsList="";
//--- indicator buffers
double    ExtTradeSignalBuffer[];
//--- right input parameters flag
// bool      ExtParameters=false;
static int SELL = -1;
static int BUY = 1;

double upperRSIBound = 70;
double lowerRSIBound = 30;

double upperMACDBound = 0.0005;
double lowerMACDBound = -0.0005;

int iFastEMA = 12;
int iSlowEMA = 26;

int iATRPeriod = 14;
double dLowerATRBound = 0.00075;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   IndicatorDigits(Digits+1);
//--- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtTradeSignalBuffer);
//--- name for DataWindow and indicator subwindow label
   IndicatorShortName("Trade Signal Supplier");
   SetIndexLabel(0,"TradeSignal");
/* --- check for input parameters
   if(InpFastEMA<=1 || InpSlowEMA<=1 || InpSignalSMA<=1 || InpFastEMA>=InpSlowEMA)
     {
      Print("Wrong input parameters");
      ExtParameters=false;
      return(INIT_FAILED);
     }
   else
      ExtParameters=true;
//--- initialization done
   return(INIT_SUCCEEDED);
  }
*/
   return INIT_SUCCEEDED;
}

double ND(double val)
{
   return(NormalizeDouble(val, Digits));
}

int IndicateTrade(int i)
{
/*
   double preprevious = ND(iMA(NULL,PERIOD_M5,iMA_value,0, MODE_EMA, PRICE_CLOSE, i+3));
   double previous = ND(iMA(NULL,PERIOD_M5,iMA_value,0, MODE_EMA, PRICE_CLOSE, i+2));
   double current = ND(iMA(NULL,PERIOD_M5,iMA_value,0, MODE_EMA, PRICE_CLOSE, i+1));
   
   Comment("current: "+ (string)current+" previous: "+ (string)previous + " preprevious: "+(string)preprevious);
*/

   double previous = iMACD(NULL, PERIOD_M5, iFastEMA, iSlowEMA, 9, PRICE_CLOSE, MODE_MAIN, i+2);
   double current = iMACD(NULL, PERIOD_M5, iFastEMA, iSlowEMA, 9, PRICE_CLOSE, MODE_MAIN, i+1);
   
   double dATR = iATR(NULL, PERIOD_M5, iATRPeriod, i+1);
   
   if (dATR >= dLowerATRBound){
      if (current > 0 && previous < 0)
         return BUY;
         
      if (current < 0 && previous > 0)
         return SELL;
   }
 /*  
   if (iRSI(NULL,PERIOD_M5,rsiPeriod, PRICE_CLOSE, i+1) > upperRSIBound){
      if ( iMACD(NULL, PERIOD_M5, iFastEMA, iSlowEMA, 9, PRICE_MEDIAN, MODE_MAIN, i) > upperMACDBound){
         return SELL;
      }
   }
   
   if (iRSI(NULL,PERIOD_M5,rsiPeriod, PRICE_CLOSE, i+1) < lowerRSIBound){
      if ( iMACD(NULL, PERIOD_M5, iFastEMA, iSlowEMA, 9, PRICE_MEDIAN, MODE_MAIN, i) < lowerMACDBound){
         return BUY;
      }
   }
*/
   return 0;
}


//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int OnCalculate (const int rates_total,
                 const int prev_calculated,
                 const datetime& time[],
                 const double& open[],
                 const double& high[],
                 const double& low[],
                 const double& close[],
                 const long& tick_volume[],
                 const long& volume[],
                 const int& spread[])
  {
   int i,limit;
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;

//   if(prev_calculated>0)
//      limit++;

   for(i=0; i<limit; i++){
      ExtTradeSignalBuffer[i] = IndicateTrade(i);
   }
   return(rates_total);
  }
//+------------------------------------------------------------------+
