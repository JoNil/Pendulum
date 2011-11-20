with Low_Level_Types; use Low_Level_Types;
with Chars_8x5; use Chars_8x5;

package body Framebuffer is

   subtype Character_Slice_Range_Type is Integer'Base range 0 .. 4;

   protected body Framebuffer_Data is

      procedure Clear (Value : Pixel_Type) is
      begin
         for Row in Row_Type'Range loop
            for Columne in Column_Type'Range loop
               Set_Pixel (Row, Columne, Value);
            end loop;
         end loop;
      end Clear;

      procedure Swap_Buffers is
      begin
         Buffer_Selector := Buffer_Selector + 1;
      end Swap_Buffers;

      procedure Draw_Char (Pos : Column_Type; Char : Character) is
         Pattern     : array (Character_Slice_Range_Type) of Byte;
         Slice       : Byte := 0;
         Shifts      : Natural := 0;
      begin
         for I in Pattern'Range loop
            Pattern (I) := Char_Map (Char, I);
         end loop;

         for Slice_Index in Pattern'Range loop
            Slice := Pattern (Slice_Index);

            for Row in Row_Type loop
               -- Is the last bit a one
               if (Slice and 16#1#) = 1 then
                  Set_Pixel (Row,
                             Pos + Column_Type (Slice_Index),
                             1.0);
               else
                  Set_Pixel (Row,
                             Pos + Column_Type (Slice_Index),
                             0.0);
               end if;

               -- Get the next bit
               Slice := Shift_Right (Slice, 1);
            end loop;
         end loop;
      end Draw_Char;

      procedure Set_Pixel (Row : Row_Type;
                           Col : Column_Type; Value : Pixel_Type) is
      begin
         if Buffer_Selector = 0 then
            Buffer1 (Row, Col) := Value;
         else
            Buffer2 (Row, Col) := Value;
         end if;
      end Set_Pixel;

      function Get_Pixel (Row : Row_Type;
                          Col : Column_Type) return Pixel_Type is
      begin
         if Buffer_Selector = 0 then
            return Buffer1 (Row, Col);
         else
            return Buffer2 (Row, Col);
         end if;
      end Get_Pixel;

      function Get_Back_Pixel (Row : Row_Type;
                               Col : Column_Type) return Pixel_Type is
      begin
         if Buffer_Selector = 0 then
            return Buffer2 (Row, Col);
         else
            return Buffer1 (Row, Col);
         end if;
      end Get_Back_Pixel;

      function Get_Rows return Integer is
      begin
         return Integer (Row_Type'Last) + 1;
      end Get_Rows;

      function Get_Columns return Integer is
      begin
         return Integer (Column_Type'Last) + 1;
      end Get_Columns;

   end Framebuffer_Data;
end Framebuffer;
