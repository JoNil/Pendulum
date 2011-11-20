pragma Task_Dispatching_Policy(FIFO_Within_Priorities);
pragma Locking_Policy(Ceiling_Locking);

with Tools;           use Tools;
with Ada.Text_IO;     use Ada.Text_IO;
with Ada.Real_Time;   use Ada.Real_Time;
with Low_Level_Types; use Low_Level_Types;
with Sampler;         use Sampler;
with Pendulum_Io_Sim; use Pendulum_Io_Sim;
with Framebuffer;     use Framebuffer;
with Painter;         use Painter;

procedure Main is
   Left_Time : Time;
   Stage : Integer;
   Curr_T : Time := Clock;
   Time_Since : Time_Span;
begin
   loop
      Left_Time := Sampler_Data.Get_Most_Left_Time;

      Curr_T := Clock;

      Time_Since := Curr_T - Left_Time;

      if Time_Since < Milliseconds(50) then
         Stage := 1;
      elsif Time_Since > Milliseconds(50) and stage = 1 then

         Framebuffer_Data.Clear (0.0);
         Framebuffer_Data.Draw_String (0, "Jon!"); -- this should be somewhere else
         Framebuffer_Data.Swap_Buffers;
         Stage := 2;
      elsif stage = 2 and Time_Since > Milliseconds(200) then
         Painter_Task.Begin_Sweep (Sampler_Data.Get_Most_Left_Time,
                                   Sampler_Data.Get_Period,
                                   Forward);
         Stage := 3;
      elsif stage = 3 and Time_Since > Milliseconds(1500) then
         Framebuffer_Data.Clear (0.0);
         Framebuffer_Data.Draw_String (0, "Jon!"); -- this should be somewhere else
         Framebuffer_Data.Swap_Buffers;
         Stage := 4;
      elsif stage = 4 and Time_Since > Milliseconds(1700) then
         Painter_Task.Begin_Sweep (Sampler_Data.Get_Most_Left_Time+Sampler_Data.Get_Period/2,
                                   Sampler_Data.Get_Period,
                                   Forward);
         Stage := 0;
      end if;
      delay 0.005;
   end loop;

end Main;
