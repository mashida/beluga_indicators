//+------------------------------------------------------------------+
//|                                     e0x_movement-logger-2.00.mq4 |
//|                                          Copyright 2020, mashida |
//|                                              https:/t.me/mashida |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, mashida"
#property link      "https:/t.me/mashida"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   4
//--- plot Up
#property indicator_label1  "Up"
#property indicator_type1   DRAW_NONE
//--- plot Down
#property indicator_label2  "Down"
#property indicator_type2   DRAW_NONE
//--- plot Positive
#property indicator_label3  "Positive"
#property indicator_type3   DRAW_HISTOGRAM
#property indicator_color3  clrDeepSkyBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2
//--- plot Negative
#property indicator_label4  "Negative"
#property indicator_type4   DRAW_HISTOGRAM
#property indicator_color4  clrDodgerBlue
#property indicator_style4  STYLE_SOLID
#property indicator_width4  2
//--- indicator buffers
double         UpBuffer[];
double         DownBuffer[];
double         PositiveBuffer[];
double         NegativeBuffer[];

double currentPrice = 0.0; // stores current price
double previousPrice = 0.0; // stores previous price
double p = 0.0; // this is shortage of _Point variable
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,UpBuffer);
   SetIndexBuffer(1,DownBuffer);
   SetIndexBuffer(2,PositiveBuffer);
   SetIndexBuffer(3,NegativeBuffer);
   SetIndexEmptyValue(0, 0);
   SetIndexEmptyValue(1, 0);
   SetIndexEmptyValue(2, 0);
   SetIndexEmptyValue(3, 0);
   p = _Point;

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
   if(prev_calculated == 0)
     {
      previousPrice = Close[1];
     }

   currentPrice = Close[0];   

   if(currentPrice > previousPrice)
     {
      UpBuffer[0] += currentPrice - previousPrice;
      //Print("UP | Current price: " + d(currentPrice) + " | previous price: " + d(previousPrice) + " | buffer[0]: " + d(UpBuffer[0]));
     }
   else
     {
      DownBuffer[0] += currentPrice - previousPrice;
      //Print("DOWN | Current price: " + d(currentPrice) + " | previous price: " + d(previousPrice) + " | buffer[0]: " + d(DownBuffer[0]));
     }
     
   if(UpBuffer[0] > MathAbs(DownBuffer[0]))
     {
      PositiveBuffer[0] = UpBuffer[0] - MathAbs(DownBuffer[0]);
      NegativeBuffer[0] = 0.0;
     }
   if(UpBuffer[0] < MathAbs(DownBuffer[0]))
     {
      NegativeBuffer[0] = UpBuffer[0] - MathAbs(DownBuffer[0]);
      PositiveBuffer[0] = 0.0;
     }
     
   previousPrice = currentPrice;

//--- return value of prev_calculated for next call
   return(rates_total);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double n(const double data, const int digits = 6)
  {
   return NormalizeDouble(data, digits);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string d(const double data, const int digits = 6)
  {
   return DoubleToStr(data, digits);
  }
//+------------------------------------------------------------------+
