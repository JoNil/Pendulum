with Low_Level_Types; use Low_Level_Types;
with Chars_8x5;       use Chars_8x5;
with Color;           use Color;

package body Framebuffer is

   subtype Character_Slice_Range_Type is Integer'Base range 0 .. 4;

   protected body Framebuffer_Data is

      procedure Clear (Color : Color_Type) is
      begin
         for Row in Row_Type'Range loop
            for Col in Column_Type'Range loop
               Set_Pixel (Row, Col, Color);
            end loop;
         end loop;
      end Clear;

      entry Swap_Buffer when not Swap_Requested is
      begin
         Swap_Requested := True;
      end Swap_Buffer;

      procedure Handel_Swap_Buffer is
      begin
         if Swap_Requested then
            Buffer_Selector := Buffer_Selector + 1;
         end if;
         Swap_Requested := False;
      end Handel_Swap_Buffer;

      procedure Draw_Char (Pos : Integer; Char : Character;
                           Char_Color       : Color_Type;
                           Background_Color : Color_Type) is
         Pattern     : array (Character_Slice_Range_Type) of Byte;
         Slice       : Byte := 0;
         Shifts      : Natural := 0;
      begin
         for I in Pattern'Range loop
            Pattern (I) := Char_Map (Char, I);
         end loop;

         for Slice_Index in Character_Slice_Range_Type loop
            Slice := Pattern (Slice_Index);

            for Row in Row_Type loop
               -- Is the last bit a one
               if (Slice and 16#1#) = 1 then
                  Set_Pixel (Row,
                             Pos + Slice_Index,
                             Char_Color);
               else
                  Set_Pixel (Row,
                             Pos + Slice_Index,
                             Background_Color);
               end if;

               -- Get the next bit
               Slice := Shift_Right (Slice, 1);
            end loop;
         end loop;
      end Draw_Char;

      procedure Draw_String (Pos : Integer; Str : String;
                             Char_Color       : Color_Type;
                             Background_Color : Color_Type) is
         Current_Pos : Integer := Pos;
      begin
         for I in Str'Range loop
            Draw_Char (Current_Pos, Str (I), Char_Color, Background_Color);
            Current_Pos := Current_Pos + 6;
         end loop;
      end Draw_String;

      procedure Draw_Image (X : Integer; Y : Integer; Img : Image_Type) is
      begin
         for X_Offset in Integer range 0 .. Img.Width loop
            for Y_Offset in Integer range 0 .. Img.Height loop
               Set_Pixel (X + X_Offset,
                          Y + Y_Offset,
                          Img.Data (X_Offset, Y_Offset));
            end loop;
         end loop;
      end Draw_Image;

      procedure Set_Pixel (Row : Integer; Col : Integer; Color : Color_Type) is
      begin
         if Row in Row_Type'Range and Col in Column_Type'Range then
            if Buffer_Selector = 0 then
               Buffer1 (Row, Col) := Color;
            else
               Buffer2 (Row, Col) := Color;
            end if;
         end if;
      end Set_Pixel;

      function Get_Pixel (Row : Integer; Col : Integer) return Color_Type is
      begin
         if Row in Row_Type'Range and Col in Column_Type'Range then
            if Buffer_Selector = 0 then
               return Buffer1 (Row, Col);
            else
               return Buffer2 (Row, Col);
            end if;
         else
            return Black;
         end if;
      end Get_Pixel;

      function Get_Back_Pixel (Row : Integer; Col : Integer) return Color_Type is
      begin
         if Row in Row_Type'Range and Col in Column_Type'Range then
            if Buffer_Selector = 0 then
               return Buffer2 (Row_Type (Row),
                               Column_Type (Col));
            else
               return Buffer1 (Row_Type (Row),
                               Column_Type (Col));
            end if;
         else
            return Black;
         end if;
      end Get_Back_Pixel;

      function Get_Rows return Integer is
      begin
         return Row_Type'Last + 1;
      end Get_Rows;

      function Get_Columns return Integer is
      begin
         return Column_Type'Last + 1;
      end Get_Columns;

   end Framebuffer_Data;
end Framebuffer;
