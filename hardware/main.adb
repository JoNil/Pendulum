pragma Task_Dispatching_Policy (FIFO_Within_Priorities);
pragma Locking_Policy (Ceiling_Locking);

with Tools;           use Tools;
with Ada.Real_Time;   use Ada.Real_Time;
with Low_Level_Types; use Low_Level_Types;
with Sampler;         use Sampler;
with Pendulum_Io; use Pendulum_Io;
with Framebuffer;     use Framebuffer;
with Painter;         use Painter;
with Color;           use Color;
with System;          use System;

procedure Main is

   task Sweep_Starter_Task is
      pragma Priority (Priority'Last - 3);
   end Sweep_Starter_Task;

   task body Sweep_Starter_Task is

      Left_Time         : Time             := Clock;
      Stage             : Integer          := 0;
      Curr_T            : Time             := Clock;
      Curr_Period       : Time_Span        := Milliseconds (0);
      Time_Since        : Time_Span;
      Offset_Percentage : constant Integer := 10;
      Offset            : Time_Span        := Milliseconds (0);

   begin
      loop
         Curr_T := Clock;
         Time_Since := Curr_T - Left_Time;

         if Stage = 0 then
            Left_Time := Sampler_Data.Get_Most_Left_Time;
            Offset := (Curr_Period * Offset_Percentage) / 200;
            Curr_Period := Sampler_Data.Get_Period;
            Stage := 1;
         elsif Stage = 1 and Time_Since > Offset then
              Framebuffer_Data.Handel_Swap_Buffer;
              Painter_Task.Begin_Sweep (Left_Time,
                                        Curr_Period,
                                        Forward);
            Stage := 2;
         elsif Stage = 2 and Time_Since > Curr_Period / 2 + Offset  then
            Framebuffer_Data.Handel_Swap_Buffer;
            Painter_Task.Begin_Sweep (Left_Time + Curr_Period / 2,
                                      Curr_Period,
                                      Backward);
            Stage := 0;
         end if;
         delay 0.000001;
      end loop;
   end Sweep_Starter_Task;

   Offset : Integer := 0;

begin

    loop
      Framebuffer_Data.Clear (Black);
      Framebuffer_Data.Draw_String (Offset, "Max&Jonathan", Red, Black);
      Framebuffer_Data.Swap_Buffer;
      Offset := Offset + 1;
      delay 0.2;
     end loop;

end Main;
