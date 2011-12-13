with Ada.Real_Time; use Ada.Real_Time;
with System;        use System;

package Painter is
   type Direction_Type is (Forward, Backward);
   task Painter_Task is
      pragma Priority (Priority'Last - 1);
      entry Begin_Sweep (Edge_Time : Time;
                         Period    : Time_Span;
                         Direction : Direction_Type);
   end Painter_Task;
end Painter;
