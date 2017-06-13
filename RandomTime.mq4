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
#property  indicator_chart_window
#property  indicator_buffers 1
#property  indicator_color1  Red
//--- indicator parameters
input string Indicator="default";

//input string ParamsAsList="";
//--- indicator buffers
double ExtTradeSignalBuffer[];
//--- right input parameters flag
// bool      ExtParameters=false;
static int SELL = -1;
static int BUY = 1;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   IndicatorDigits(Digits+1);
//--- drawing settings
//   SetIndexStyle(0,DRAW_HISTOGRAM);
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

bool ArrowBuyCreate(const long            chart_ID=0,        // chart's ID
                    const string          name="ArrowBuy",   // sign name
                    const ENUM_OBJECT     type=OBJ_ARROW_BUY,// type
                    const int             sub_window=0,      // subwindow index
                    datetime              time=0,            // anchor point time
                    double                price=0,           // anchor point price
                    const color           clr=C'3,95,172',   // sign color
                    const ENUM_LINE_STYLE style=STYLE_SOLID, // line style (when highlighted)
                    const int             width=3,           // line size (when highlighted)
                    const bool            back=false,        // in the background
                    const bool            selection=false,   // highlight to move
                    const bool            hidden=true,       // hidden in the object list
                    const long            z_order=0)         // priority for mouse click
  {
//--- set anchor point coordinates if they are not set
   ChangeArrowEmptyPoint(time,price);
//--- reset the error value
   ResetLastError();
//--- create the sign
   if(!ObjectCreate(chart_ID,name,type,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create \"Buy\" sign! Error code = ",GetLastError());
      return(false);
     }
//--- set a sign color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set a line style (when highlighted)
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set a line size (when highlighted)
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the sign by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//| Check anchor point values and set default values                 |
//| for empty ones                                                   |
//+------------------------------------------------------------------+
void ChangeArrowEmptyPoint(datetime &time,double &price)
  {
//--- if the point's time is not set, it will be on the current bar
   if(!time)
      time=TimeCurrent();
//--- if the point's price is not set, it will have Bid value
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }


double IndicateTimedTrade(int i, datetime dt, double open)
{
//   if (MathMod(TimeMinute(dt),10) == 5)
//   if (TimeMinute(dt) == 15 || TimeMinute(dt) == 45)
   if (TimeMinute(dt) == 0){
      if(!ArrowBuyCreate(0,"ArrowBuy_"+(string)i,OBJ_ARROW_UP,0,dt,open,clrRed))
         return 0;
      return BUY;
   }

//   if (MathMod(TimeMinute(dt),10) == 0)
//   if (TimeMinute(dt) == 0 || TimeMinute(dt) == 30)
   if (TimeMinute(dt) == 5){
      if(!ArrowBuyCreate(0,"ArrowSell_"+(string)i,OBJ_ARROW_DOWN,0,dt,open,clrDeepSkyBlue))
         return 0;
      return SELL;
   }

   return 0;
}

int IndicateCustomTrade()
{
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
  
   ArraySetAsSeries(ExtTradeSignalBuffer,false);
   ArraySetAsSeries(open,false);
   ArraySetAsSeries(time,false);
//--- first calculation or number of bars was changed
   if(prev_calculated==0)
      ArrayInitialize(ExtTradeSignalBuffer,0);
  
   int i,limit;
   
   if(prev_calculated==0)
      limit=0;
   else
      limit=prev_calculated-1;

   for(i=limit; i<rates_total && !IsStopped(); i++){
      ExtTradeSignalBuffer[i]=IndicateTimedTrade(i, time[i], open[i]);
   }
   
   return(rates_total);
  }
//+------------------------------------------------------------------+
