package Framebuffer is
   type Pixel_Type is delta 0.0 .. 1.0;

   protected Framebuffer_Data is
      procedure Init (Columns : Integer);
      procedure Set_Pixel (X, Y : Integer, Value : Pixel_Type);
      function Get_Pixel (X, Y : Integer) return Pixel_Type;
      function Get_Rows return Integer;
      function Get_Columns return Integer;
   private
      Rows    : constant Integer := 8;JoNil
      Columns : Integer := 0;
      Buffer  : array (0 .. 7, Positive range <>) of Element_Type;
   end Framebuffer_Data;

end Framebuffer;
