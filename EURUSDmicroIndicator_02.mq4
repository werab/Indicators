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
input int iMA_value = 75;

//input string ParamsAsList="";
//--- indicator buffers
double    ExtTradeSignalBuffer[];
//--- right input parameters flag
// bool      ExtParameters=false;
static int SELL = -1;
static int BUY = 1;

int iTimeFrame = PERIOD_H4;
int iFastMa = 5;
int iSlowMa = 21;
int iTrendMa = 50;

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
   double previousFast = iMA(NULL, iTimeFrame, iFastMa, 0, 0, PRICE_WEIGHTED, 2);
   double currentFast = iMA(NULL, iTimeFrame, iFastMa, 0, 0, PRICE_WEIGHTED, 1);
   double previousSlow = iMA(NULL, iTimeFrame, iSlowMa, 0, 0, PRICE_WEIGHTED, 2);
   double currentSlow = iMA(NULL, iTimeFrame, iSlowMa, 0, 0, PRICE_WEIGHTED, 1);

   double previousTrend = iMA(NULL, iTimeFrame, iTrendMa, 0, 0, PRICE_WEIGHTED, 2);
   double currentTrend = iMA(NULL, iTimeFrame, iTrendMa, 0, 0, PRICE_WEIGHTED, 1);

   if (previousFast<previousSlow && currentFast>currentSlow && currentTrend>previousTrend){
     return BUY;

   if (previousFast>previousSlow && currentFast<currentSlow && currentTrend<previousTrend){
     return SELL;

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
