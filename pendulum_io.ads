-- Pendulum_IO
-- Package for various operations on the X3 Pendulum
-- connected to the parallel port in standard mode
--
-- Jorge Real. September 2005

with Low_Level_Types; use Low_Level_Types;

package Pendulum_Io is

   function Get_Sync return Boolean;    -- Returns True if Sync=1; False otherwise
   function Get_Barrier return Boolean; -- Returns True if Barrier=0; False otherwise

   procedure Reset_Leds;                -- Blanks LEDs column
   procedure Set_Leds (B : in Byte);    -- Lights LEDs whose position is 1 in B

end Pendulum_Io;
