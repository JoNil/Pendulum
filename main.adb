pragma Task_Dispatching_Policy(FIFO_Within_Priorities);
pragma Locking_Policy(Ceiling_Locking);

with Ada.Text_IO;     use Ada.Text_IO;
with Ada.Real_Time;   use Ada.Real_Time;
with Low_Level_Types; use Low_Level_Types;
with Sampler;         use Sampler;
with Pendulum_Io_Sim; use Pendulum_Io_Sim;
with Framebuffer;     use Framebuffer;

procedure Main is
   Left_Time : Time;
begin

   Framebuffer_Data.Init (75);

   while True loop

      Left_Time := Sampler_Data.Get_Most_Left_Time;

      if abs(Clock - Left_Time) < Milliseconds(1405) then
         Set_Leds (255);
      else
         Reset_Leds;
      end if;
      delay 0.1;
   end loop;

end Main;
