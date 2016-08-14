#property indicator_chart_window
#property indicator_buffers 5
//---- plot Line
#property indicator_label1  "M5"
#property indicator_label2  "M15"
#property indicator_label3  "M30"
#property indicator_label4  "H1"
#property indicator_label5  "H4"
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE
#property indicator_type3   DRAW_LINE
#property indicator_type4   DRAW_LINE
#property indicator_type5   DRAW_LINE
#property indicator_style1  STYLE_SOLID
#property indicator_style2  STYLE_SOLID
#property indicator_style3  STYLE_SOLID
#property indicator_style4  STYLE_SOLID
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
#property indicator_width2  1
#property indicator_width3  1
#property indicator_width4  1
#property indicator_width5  1

#property indicator_color1  clrYellow
#property indicator_color2  clrRed
#property indicator_color3  clrMagenta
#property indicator_color3  clrGreenYellow
#property indicator_color3  clrDeepSkyBlue


//--- indicator buffers
double         M5[];
double         M15[];
double         M30[];
double         H1[];
double         H4[];

int M5_tf = 5;
int M15_tf = 15;
int M30_tf = 30;
int H1_tf = 60;
int H4_tf = 240;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,M5,INDICATOR_DATA);
   SetIndexBuffer(1,M15,INDICATOR_DATA);
   SetIndexBuffer(1,M30,INDICATOR_DATA);
   SetIndexBuffer(1,H1,INDICATOR_DATA);
   SetIndexBuffer(1,H4,INDICATOR_DATA);

//---- line shifts when drawing
//   SetIndexShift(0,InpJawsShift);
//---- first positions skipped when drawing
//   SetIndexDrawBegin(0,InpJawsShift+InpJawsPeriod);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
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
//--- Get the number of bars available for the current symbol and chart period
   int bars=Bars(Symbol(),0);
   Comment("Bars=", bars);
//   Print("Bars = ",bars,", rates_total = ",rates_total,",  prev_calculated = ",prev_calculated);
//   Print("time[0] = ",time[0]," time[rates_total-1] = ",time[rates_total-1]);
//--- return value of prev_calculated for next call

   int limit=rates_total-prev_calculated;
//---- main loop
   
   if (Period() == 1) {
     for(int i=0; i<limit; i++)
     {
      //---- ma_shift set to 0 because SetIndexShift called abowe

      M5[i] = iMA(NULL,M5_tf,10,0,MODE_SMMA,PRICE_MEDIAN,i/M5_tf);
      M15[i] = iMA(NULL,M15_tf,10,0,MODE_SMMA,PRICE_MEDIAN,i/M15_tf);
      M30[i] = iMA(NULL,M30_tf,10,0,MODE_SMMA,PRICE_MEDIAN,i/M30_tf);
      H1[i] = iMA(NULL,H1_tf,10,0,MODE_SMMA,PRICE_MEDIAN,i/H1_tf);
      H4[i] = iMA(NULL,H4_tf,10,0,MODE_SMMA,PRICE_MEDIAN,i/H4_tf);

     }
   }
   return(rates_total);
  }