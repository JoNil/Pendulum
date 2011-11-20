with Pendulum_Io_Sim; use Pendulum_Io_Sim;
with Low_Level_Types; use Low_Level_Types;
with Framebuffer;     use Framebuffer;

package body Painter is
   task body Painter_Task is
      Sweep_Columne : Column_Type := 0;
      Sweep_Pixel   : Pixel_Type := 0.0;
      Sweep_Period  : Time_Span := Milliseconds (0);
      Sweep_Time    : Time_Span := Milliseconds (0);
      Sweep_Start   : Time := Clock;
      Sweep_End     : Time := Clock;
      Sweep_Next    : Time := Clock;
      Sweep_Byte    : Byte := 16#0#;

   begin
      loop
        accept Begin_Sweep (Most_Left_Time : Time;
                            Period         : Time_Span;
                            Direction      : Direction_Type) do
            Sweep_Start := Clock;
            Sweep_Time  := Period / 2 - 2 * (Sweep_Start - Most_Left_Time);
         end Begin_Sweep;

         Sweep_Columne := 0;
         Sweep_End     := Sweep_Start + Sweep_Time;
         Sweep_Period  := Sweep_Time / Framebuffer_Data.Get_Columns;
         Sweep_Next    := Sweep_Start;

         while Clock < Sweep_End loop

            Sweep_byte := 16#0#;

            for Sweep_Row in Row_Type'Range loop
               Sweep_Pixel := Framebuffer_Data.Get_Back_Pixel (Sweep_Row,
                                                               Sweep_Columne);
               if Sweep_Pixel = 1.0 then
                  Sweep_Byte := Sweep_Byte or (Shift_Left (16#1#, Integer (Sweep_Row)));
               end if;
            end loop;

            if Sweep_Columne /= Column_Type'Last then
               Sweep_Columne := Sweep_Columne + 1;
            end if;

            Set_Leds (Sweep_Byte);

            Sweep_Next := Sweep_Next + Sweep_Period;
            delay until Sweep_Next;
         end loop;
      end loop;
   end Painter_Task;
end Painter;
