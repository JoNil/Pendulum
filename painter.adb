with Pendulum_Io_Sim; use Pendulum_Io_Sim;
with Low_Level_Types; use Low_Level_Types;
with Framebuffer;     use Framebuffer;
with Color;           use Color;

package body Painter is
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

            Sweep_byte := 16#0#;

            for Sweep_Row in Row_Type'Range loop
               if Sweep_Direction = Forward then
                  Sweep_Color := Framebuffer_Data.Get_Back_Pixel
                    (Sweep_Row, Sweep_Columne);
               else
                  Sweep_Color := Framebuffer_Data.Get_Back_Pixel
                    (Sweep_Row, Column_Type'Last - Sweep_Columne);
               end if;

               if Sweep_Color = Red then
                  Sweep_Byte := Sweep_Byte or
                    (Shift_Left (16#1#, Integer (Sweep_Row)));
               end if;
            end loop;

            Set_Leds (Sweep_Byte);

            Sweep_Columne := Sweep_Columne + 1;
            Sweep_Next := Sweep_Next + Sweep_Period;
            delay until Sweep_Next;
         end loop;

         Reset_Leds;

      end loop;
   end Painter_Task;
end Painter;
