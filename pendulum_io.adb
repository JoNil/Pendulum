-- Pendulum_IO
-- Package for various operations on the X3 Pendulum
-- connected to the digial IO card of the PC104 board
--
-- Connections:
--    Sync:    Digital input 0
--    Barrier: Digital input 1
--    LEDS:    Digtal outputs 0..7
--
-- Jorge Real. October 2006

with Port_IO;    use Port_IO;
with Interfaces; use Interfaces;


package body Pendulum_Io is

   Base : Word := 16#300#;  -- Digital IO base address

   --------------
   -- Get_Sync --
   --------------

   function Get_Sync return Boolean is
   begin
      return (Port_In(Base) and 16#02#) /= Byte(0);
   end Get_Sync;

   -----------------
   -- Get_Barrier --
   -----------------

     function Get_Barrier return Boolean is
     begin
        return (Port_In(Base) and 16#01#) /= Byte(0);
     end Get_Barrier;

   ----------------
   -- Reset_Leds --
   ----------------

   procedure Reset_Leds is
   begin
      Port_Out(Base,Byte(255));
   end Reset_Leds;

   --------------
   -- Set_Leds --
   --------------

   procedure Set_Leds (B : in Byte) is
   begin
      Port_Out(Base,B xor 16#FF#);
   end Set_Leds;

end Pendulum_Io;

