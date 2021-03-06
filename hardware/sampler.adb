with Pendulum_Io; use Pendulum_Io;
with System; use System;
with Tools; use Tools;

package body Sampler is

   protected body Sampler_Data  is
      function Get_Period return Time_Span is
      begin
         return Period;
      end Get_Period;

      function Get_Most_Left_Time return Time is
      begin
         return Most_Left_Time;
      end Get_Most_Left_Time;

      procedure Set_Period (Input : Time_Span) is
      begin
         Period := Input;
      end Set_Period;

      procedure Set_Most_Left_Time (Input : Time) is
      begin
         Most_Left_Time := Input;
      end Set_Most_Left_Time;
   end Sampler_Data;

   task Barrier_Sampler is
      pragma Priority (Priority'Last - 2);
   end Barrier_Sampler;

   task body Barrier_Sampler is
      Barrier_Sampler_Period : constant Time_Span := Microseconds (100);
      Next                   : Time := Clock;

      Circ_Buff_Length : constant Integer := 3;
      type Circ_Buff_Index_Type is new Integer;
      type Circ_Buff_Type is array (0..2) of Time;

      Circ_Buff_Index        : Integer := 0;
      Circ_Buff              : Circ_Buff_Type;
      Circ_Buff_Fall         : Circ_Buff_Type := (0..2 => Clock);
      Prev_Barrier           : Boolean := False;
      Curr_Barrier           : Boolean := False;

      Full_Round             : Boolean := False;
      T1, T2, Period         : Time_Span := Milliseconds (0);
      Most_Left              : Time := Clock;
      currT : Time;
   begin
      loop
         currT := Clock;
         Curr_Barrier := Get_Barrier;
         if Curr_Barrier /= Prev_Barrier then
            -- flank
            if Curr_Barrier then
               -- rising flank
               Circ_Buff(Circ_Buff_Index) := currT;
               Circ_Buff_Index := (Circ_Buff_Index + 1) mod Circ_Buff_Length;

               if Full_Round then
                  -- now Circ_Buff_Index points at the oldest rising flank
                  -- also in the Circ_Buff_Fall the pointer points at
                  -- the oldest falling flank

                  T1 := Circ_Buff ((Circ_Buff_Index + 1) mod Circ_Buff_Length)
                    - Circ_Buff_Fall ((Circ_Buff_Index + 1) mod Circ_Buff_Length);
                  T2 := Circ_Buff ((Circ_Buff_Index + 2) mod Circ_Buff_Length)
                    - Circ_Buff_Fall ( (Circ_Buff_Index + 2) mod Circ_Buff_Length);
                  if T1 < T2 then
                     -- beginning is between A and B
                     Most_Left := Circ_Buff_Fall((Circ_Buff_Index + 1) mod Circ_Buff_Length) + T1 / 2;
                  else
                     -- beginning is between B and C
                     Most_Left := Circ_Buff_Fall ((Circ_Buff_Index + 2) mod Circ_Buff_Length) + T2 / 2;
                  end if;

                  Sampler_Data.Set_Most_Left_Time (Most_Left);

                  Period := Circ_Buff((Circ_Buff_Index + 2) mod Circ_Buff_Length) - Circ_Buff(Circ_Buff_Index);
                  Sampler_Data.Set_Period (Period);
               end if;

            else
               -- falling flank
               Circ_Buff_Fall(Circ_Buff_Index) := currT;
            end if;
         end if;

         if Circ_Buff_Index = 2 then
            Full_Round := True;
         end if;

         if Most_Left + Period < currT then
            Most_Left := Most_Left + Period;
            Sampler_Data.Set_Most_Left_Time (Most_Left);
         end if;

         Prev_Barrier := Curr_Barrier;
         Next := Next + Barrier_Sampler_Period;

         delay until Next;

      end loop;
   end Barrier_Sampler;

end Sampler;
