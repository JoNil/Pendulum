package Framebuffer is
   type Row_Type is range 0 .. 7;
   type Column_Type is range 0 .. 75;
   type Pixel_Type is delta 0.1 range 0.0 .. 1.1;
   type Buffer_Type is array (Row_Type, Column_Type) of Pixel_Type;

   protected Framebuffer_Data is
      procedure Set_Pixel (Row : Row_Type; Col : Column_Type; Value : Pixel_Type);
      function Get_Pixel (Row : Row_Type; Col : Column_Type) return Pixel_Type;
      function Get_Rows return Integer;
      function Get_Columns return Integer;
   private
      Buffer  : Buffer_Type;
   end Framebuffer_Data;
end Framebuffer;
