with Image; use Image;
with Color; use Color;

package Framebuffer is

   Number_Of_Columns : constant Integer := 82;

   subtype Row_Type is Integer'Base range 0 .. 7;
   subtype Column_Type is Integer'Base range 0 .. Number_Of_Columns;
   type Buffer_Type is array (Row_Type, Column_Type) of Color_Type;
   type Buffer_Selector_Type is mod 2;

   protected Framebuffer_Data is
      procedure Clear (Color : Color_Type);
      entry Swap_Buffer;
      procedure Handel_Swap_Buffer; -- Should not be used to application code
      procedure Draw_Char (Pos              : Integer; Char : Character;
                           Char_Color       : Color_Type;
                           Background_Color : Color_Type);
      procedure Draw_String (Pos              : Integer; Str : String;
                             Char_Color       : Color_Type;
                             Background_Color : Color_Type);
      procedure Draw_Image (X : Integer; Y : Integer; Img : Image_Type);
      procedure Set_Pixel (Row : Integer; Col : Integer; Color : Color_Type);
      function Get_Pixel (Row : Integer; Col : Integer) return Color_Type;
      function Get_Back_Pixel (Row : Integer; Col : Integer) return Color_Type;
      function Get_Rows return Integer;
      function Get_Columns return Integer;
   private
      Swap_Requested  : Boolean := False;
      Buffer_Selector : Buffer_Selector_Type := 0;
      Buffer1         : Buffer_Type;
      Buffer2         : Buffer_Type;
   end Framebuffer_Data;
end Framebuffer;
