with Ada.Real_Time; use Ada.Real_Time;

package Sampler is
   protected Sampler_Data is
      function Get_Period return Time_Span;
      function Get_Most_Left_Time return Time;
      procedure Set_Period (Input : Time_Span);
      procedure Set_Most_Left_Time (Input : Time);
   private
      Period         : Time_Span;
      Most_Left_Time : Time;
   end Sampler_Data;
end Sampler;
