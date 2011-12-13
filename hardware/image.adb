package body Image is
-- TODO: Implement Load
-- TODO: Make shure images
   procedure Load (Filename : String; Image : in out Image_Type) is
   begin
      Image.Width  := 1;
      Image.Height := 1;
      Image.Data   := new Image_Data_Type (0 .. 1, 0 .. 1);
   end Load;

   procedure Unload (Image : in out Image_Type) is
   begin
      Free_Image_Data (Image.Data);
   end Unload;

end Image;
