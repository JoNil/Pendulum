package Framebuffer is
   type Pixel_Type is delta 0.0 .. 1.0;

   procedure Init (N : Integer);
   procedure Set_Pixel (X, Y : Integer, Value : Pixel_Type);
   function Get_Pixel (X, Y : Integer) return Pixel_Type;

end Framebuffer;
