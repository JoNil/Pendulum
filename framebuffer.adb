package body Framebuffer is
   protected body Framebuffer_Data is

      procedure Set_Pixel (Row : Row_Type; Col : Column_Type; Value : Pixel_Type) is
      begin
         Buffer (Row, Col) := Value;
      end Set_Pixel;

      function Get_Pixel (Row : Row_Type; Col : Column_Type) return Pixel_Type is
      begin
         return Buffer (Row, Col);
      end Get_Pixel;

      function Get_Rows return Integer is
      begin
         return Integer(Row_Type'Last) + 1;
      end Get_Rows;

      function Get_Columns return Integer is
      begin
         return Integer(Column_Type'Last) + 1;
      end Get_Columns;

   end Framebuffer_Data;
end Framebuffer;
