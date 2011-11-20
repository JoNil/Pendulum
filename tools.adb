with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO; use Ada.Text_IO;
package body Tools is
   procedure Print_Time (T : Time) is
      TS : Time_Span;
      SC : Seconds_Count;
      DU : Duration;
   begin
      Split (T, SC, TS);
      DU := To_Duration (TS);
      Put_Line ("Time: " & SC'Img & ":" & DU'Img);
   end Print_Time;
end Tools;
