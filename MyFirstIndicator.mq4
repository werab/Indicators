//+------------------------------------------------------------------+
//|                                             MyFirstIndicator.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 4
#property indicator_color1  Red
#property indicator_color2  Yellow
#property indicator_color3  Blue
#property indicator_color4  Green

input int FastMa = 5;
input int FastMaShift = 0;
input int FastMaMethod = 0;
input int FastMaAppliedTo = 0;
input int SlowMa = 21;
input int SlowMaShift = 0;
input int SlowMaMethod = 0;
input int SlowMaAppliedTo = 0;

input int AmountToLockIn = 1;
input int BreakEvenBuffer = 5;

double Shift;

double ExtM5Buffer[];
double ExtM21Buffer[];
double ExtBid_TPBuffer[];
double ExtAsk_TPBuffer[];

double pt;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   if(Digits==3 || Digits==5) pt=10*Point;   else   pt=Point;
   
   double StopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL);
   Shift = (MathMax(StopLevel, AmountToLockIn + BreakEvenBuffer))*pt;
   
   IndicatorDigits(Digits);

//---- 3 indicator buffers mapping
   SetIndexBuffer(0,ExtM5Buffer);
   SetIndexBuffer(1,ExtM21Buffer);
   SetIndexBuffer(2,ExtBid_TPBuffer);
   SetIndexBuffer(3,ExtAsk_TPBuffer);
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
//---- index labels
   SetIndexLabel(0,"M5");
   SetIndexLabel(1,"M21");
   SetIndexLabel(2,"Bid - (AmountToLockIn + BreakEvenBuffer)");
   SetIndexLabel(3,"Ask + (AmountToLockIn + BreakEvenBuffer)");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int limit=rates_total-prev_calculated;
//---- main loop
   for(int i=0; i<limit; i++)
     {
      //---- ma_shift set to 0 because SetIndexShift called abowe
      ExtM5Buffer[i] = iMA(NULL,0,FastMa,FastMaShift, FastMaMethod, FastMaAppliedTo, i);
      ExtM21Buffer[i] = iMA(NULL,0,SlowMa,SlowMaShift, SlowMaMethod, SlowMaAppliedTo,i);
      ExtBid_TPBuffer[i] = Bid - Shift;
      ExtAsk_TPBuffer[i] = Ask + Shift;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
