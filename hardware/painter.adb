with Pendulum_Io; use Pendulum_Io;
with Low_Level_Types; use Low_Level_Types;
with Framebuffer;     use Framebuffer;
with Color;           use Color;

package body Painter is

   type Sweep_Count is range 0 .. Number_Of_Columns;

   task body Painter_Task is
      Sweep_Direction : Direction_Type := Forward;
      Sweep_Columne   : Integer := 0;
      Sweep_Color     : Color_Type := 0.0;
      Sweep_Period    : Time_Span := Milliseconds (0);
      Sweep_Time      : Time_Span := Milliseconds (0);
      Sweep_Start     : Time := Clock;
      Sweep_End       : Time := Clock;
      Sweep_Next      : Time := Clock;
      Sweep_Byte      : Byte := 16#0#;

      type Table_Range is range 0 .. 71;
      type Table_Array is array (Table_Range) of Float;

      Compensation_Table : constant Table_Array :=
        (2.1915106619916958, 1.843032902047559, 1.6269567292558034, 1.4766914086757512,
         1.364797936525244, 1.2775950884696798, 1.2073906322653913, 1.1494827834410608,
         1.100814524594594, 1.0593012729647429, 1.0234666648704933, 0.9922323348445221,
         0.9647902068042039, 0.9405215640293478, 0.9189439108170865, 0.8996750108450247,
         0.8824079068951325, 0.8668931700063041, 0.8529260318008974, 0.8403368909093648,
         0.8289841984389769, 0.8187490516820306, 0.8095310347980906, 0.8012449835878999,
         0.7938184446868249, 0.7871896634245222, 0.7813059791614583, 0.7761225384614423,
         0.7716012591184124, 0.7677099945553321, 0.7644218602906818, 0.7617146932801382,
         0.7595706218570846, 0.7579757293319975, 0.7569197985050445, 0.7563961277210808,
         0.7564014118909537, 0.756935684304061, 0.7580023172127829, 0.7596080812090913,
         0.7617632654541203, 0.7644818629810441, 0.7677818276987259, 0.7716854125282273,
         0.7762196014925123, 0.7814166527939731, 0.7873147752768651, 0.7939589676256686,
         0.8014020588138289, 0.8097060005675978, 0.8189434792123885, 0.8291999370750153,
         0.8405761253784613, 0.853191355444842, 0.8671876794151538, 0.8827353256262774,
         0.9000398532951283, 0.9193517024891058, 0.9409791425336675, 0.9653061409253664,
         0.9928175204571255, 1.0241351930647409, 1.06007173044325, 1.1017120058018612,
         1.1505421253890773, 1.2086618589093243, 1.2791531011674957, 1.366761012331649,
         1.4792598499237797, 1.6305040686253935, 1.8483622371662318, 2.200807024520271);

   begin
      loop
         accept Begin_Sweep (Edge_Time : Time;
                             Period    : Time_Span;
                             Direction : Direction_Type) do
            Sweep_Start     := Clock;
            Sweep_Time      := Period / 2 - 2 * (Sweep_Start - Edge_Time);
            Sweep_Direction := Direction;
         end Begin_Sweep;

         Sweep_Columne := 0;
         Sweep_End     := Sweep_Start + Sweep_Time;
         Sweep_Period  := Sweep_Time / Framebuffer_Data.Get_Columns;
         Sweep_Next    := Sweep_Start;

         while Clock < Sweep_End loop

            Sweep_Byte := 16#0#;
            for Sweep_Row in Row_Type'Range loop
               if Sweep_Direction = Forward then
                  Sweep_Color := Framebuffer_Data.Get_Back_Pixel
                    (Sweep_Row, Sweep_Columne);
               else
                  Sweep_Color := Framebuffer_Data.Get_Back_Pixel
                   (Sweep_Row, Column_Type'Last - Sweep_Columne -1 );
               end if;

               if Sweep_Color = Red then
                  Sweep_Byte := Sweep_Byte or
                    (Shift_Left (16#1#, Integer (Sweep_Row)));
               end if;
            end loop;

            Set_Leds (Sweep_Byte);
            if Sweep_Direction = Forward then
               Sweep_Next := Sweep_Next + Time_Span((Sweep_Period * Integer(35.0 * Float(Compensation_Table(Table_Range(Sweep_Columne))))) / 35);
            else
               Sweep_Next := Sweep_Next + Time_Span((Sweep_Period * Integer(35.0 * Float(Compensation_Table(Table_Range(Column_Type'Last - Sweep_Columne))))) / 35);
            end if;

            Sweep_Columne := Sweep_Columne + 1;
            delay until Sweep_Next;
         end loop;

         Reset_Leds;

      end loop;
   end Painter_Task;
end Painter;
