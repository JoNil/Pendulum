pragma Task_Dispatching_Policy (FIFO_Within_Priorities);
pragma Locking_Policy (Ceiling_Locking);

with Tools;           use Tools;
--with Ada.Text_IO;     use Ada.Text_IO;
with Ada.Real_Time;   use Ada.Real_Time;
with Low_Level_Types; use Low_Level_Types;
with Sampler;         use Sampler;
--with Pendulum_Io_Sim; use Pendulum_Io_Sim;
with Pendulum_Io; use Pendulum_Io;
with Framebuffer;     use Framebuffer;
with Painter;         use Painter;
with Color;           use Color;
with System;          use System;
with Math;            use Math;

procedure Main is



   task Sweep_Starter_Task is
      pragma Priority (Priority'Last - 3);
   end Sweep_Starter_Task;

   task body Sweep_Starter_Task is

      Left_Time         : Time;
      Stage             : Integer;
      Curr_T            : Time := Clock;
      Curr_Period       : Time_Span;
      Time_Since        : Time_Span;
      Offset_Percentage : constant Integer := 10; --14; -- 10.0 / 92.0;
      Offset            : Time_Span := Milliseconds (0);

   begin
      loop
         Left_Time := Sampler_Data.Get_Most_Left_Time;

         Curr_T := Clock;

         Curr_Period := Sampler_Data.Get_Period;

         Time_Since := Curr_T - Left_Time;

         Offset := Curr_Period / 2 * Offset_Percentage / 100;

         if Time_Since < Milliseconds (50) then
            Stage := 1;
         elsif Stage = 1 and Time_Since > Offset then
            Framebuffer_Data.Handel_Swap_Buffer;
            Painter_Task.Begin_Sweep (Left_Time,
                                      Curr_Period,
                                      Forward);
            Stage := 2;
         elsif Stage = 2 and Time_Since > Curr_Period / 2 + Offset then
            Framebuffer_Data.Handel_Swap_Buffer;
            Painter_Task.Begin_Sweep (Left_Time + Curr_Period / 2,
                                      Curr_Period,
                                      Backward);
            Stage := 0;
         end if;
         delay 0.001;
      end loop;
   end Sweep_Starter_Task;


   Temp : Float := 0.0;
begin

   loop


      Framebuffer_Data.Clear (Black);
      Framebuffer_Data.Draw_String (0, Float'Image(Cos(Temp)), Red, Black);
      Framebuffer_Data.Swap_Buffer;

      delay 2.0;

      Framebuffer_Data.Clear (Black);
      Framebuffer_Data.Swap_Buffer;

      delay 1.0;

      Framebuffer_Data.Clear (Black);
      Framebuffer_Data.Draw_String (0, Float'Image(Temp), Red, Black);
      Framebuffer_Data.Swap_Buffer;

      delay 2.0;

      Framebuffer_Data.Clear (Black);
      Framebuffer_Data.Swap_Buffer;

      Temp := modo(Temp + 0.01, 1.0);

      delay 1.0;
   end loop;

end Main;
