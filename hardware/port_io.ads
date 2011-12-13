with Low_Level_Types; use Low_Level_Types;

package Port_IO is
   procedure Port_Out(Port : in Word; Data : in Word);
   procedure Port_Out(Port : in Word; Data : in Byte);

   function Port_In(Port : in Word) return Word;
   function Port_In(Port : in Word) return Byte;
end Port_IO;
