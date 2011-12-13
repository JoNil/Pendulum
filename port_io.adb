-- Package Body Port_IO
-- Implements Port_In and Port_Out for words and bytes
-- Basis for digital IO with PC104 boards
-- Jorge Real - October, 2006


with System.Machine_Code; use System.Machine_Code;

package body Port_Io is

   function Port_In(Port : in Word) return Word is
      Tmp : Word;
   begin
      Asm ("inw %%dx, %0",
           Word'Asm_Output ("=a", Tmp),
           Word'Asm_Input  ("d",  Port),
           --"edx",
           "",
           True);
      return Tmp;
   end Port_In;
   pragma Inline (Port_In);
   
   function Port_In(Port : in Word) return Byte is
      Tmp : Byte;
   begin
      Asm ("inb %%dx, %0",
           Byte'Asm_Output ("=a", Tmp),
           Word'Asm_Input  ("d",  Port),
           --"edx",
           "",
           True);
      return Tmp;
   end Port_In;
   pragma Inline (Port_In);


   procedure Port_Out(Port : in Word; Data : in Word) is
   begin
      Asm ("outw %0, %%dx",
           No_Output_Operands,
           (Word'Asm_Input ("a", Data),
            Word'Asm_Input ("d", Port)),
           "edx", True);
   end Port_Out;
   pragma Inline (Port_Out);

   procedure Port_Out(Port : in Word; Data : in Byte) is
   begin
      Asm ("outb %0, %%dx",
           No_Output_Operands,
           (Byte'Asm_Input ("a", Data),
            Word'Asm_Input ("d", Port)),
           "edx", True);
   end Port_Out;
   pragma Inline (Port_Out);

end Port_Io;
