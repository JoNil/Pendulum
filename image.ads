with Ada.Unchecked_Deallocation;
with Color; use Color;

package Image is

   type Image_Data_Type is array (Integer range <>,
                                  Integer range <>) of Color_Type;
   type Image_Data_Type_Access is access Image_Data_Type;

   type Image_Type is
      record
         Width  : Integer;
         Height : Integer;
         Data   : Image_Data_Type_Access;
      end record;

   procedure Load (Filename : String; Image : in out Image_Type);
   procedure Unload (Image : in out Image_Type);

private
   procedure Free_Image_Data is new Ada.Unchecked_Deallocation
      (Object => Image_Data_Type, Name => Image_Data_Type_Access);
end Image;
