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
   currT : Time;
   curr_Want, prev_Want : Boolean := False;
begin
   loop
      Left_Time := Sampler_Data.Get_Most_Left_Time;

      currT := Clock;

     -- Put_Line("current!");
     -- Print_Time(currT);
     -- Put_Line("left!");
     -- Print_Time(Left_Time);

      --      Put_Line(


      if currT - Left_Time < Milliseconds(1405) then

         Framebuffer_Data.Clear (0.0);
         Framebuffer_Data.Draw_String (0, "Jon!");
         Framebuffer_Data.Swap_Buffers;

         Painter_Task.Begin_Sweep (Sampler_Data.Get_Most_Left_Time,
                                   Sampler_Data.Get_Period,
                                   Forward);


         --Put_Line("Y");
         --Set_Leds (255);
         -- curr_Want := True;
      --else
         --Put_Line("N");
         --Reset_Leds;
         --curr_Want := True;
      end if;

--        if( curr_Want /= prev_Want ) then
--           if( curr_Want ) then
--              Set_Leds(255);
--           else
--              Reset_Leds;
--           end if;
--
--        end if;
--        prev_Want:=curr_Want;

      delay 0.005;
   end loop;

end Main;
