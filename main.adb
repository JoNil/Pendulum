pragma Task_Dispatching_Policy (FIFO_Within_Priorities);
pragma Locking_Policy (Ceiling_Locking);

with Tools;           use Tools;
with Ada.Text_IO;     use Ada.Text_IO;
with Ada.Real_Time;   use Ada.Real_Time;
with Low_Level_Types; use Low_Level_Types;
with Sampler;         use Sampler;
with Pendulum_Io_Sim; use Pendulum_Io_Sim;
with Framebuffer;     use Framebuffer;
with Painter;         use Painter;
with Color;           use Color;
with System;          use System;

procedure Main is
   pragma Priority (Priority'Last - 3);
   Left_Time   : Time;
   Stage       : Integer;
   Curr_T      : Time := Clock;
   Curr_Period : Time_Span;
   Time_Since  : Time_Span;
   Offset      : constant Time_Span := Milliseconds (163);
begin

   Framebuffer_Data.Clear (Black);
   Framebuffer_Data.Draw_String (0, "Max&Jonathan", Red, Black);
   Framebuffer_Data.Swap_Buffer;

   loop
      Left_Time := Sampler_Data.Get_Most_Left_Time;

      Curr_T := Clock;

      Curr_Period := Sampler_Data.Get_Period;

      Time_Since := Curr_T - Left_Time;

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

end Main;
