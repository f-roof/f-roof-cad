// F-Roof: A multi-function single-layer roof
// https://github.com/f-roof
// Author: Mihai Oltean; https://tcreate.org
// -----------------------------------------------------------------------------------
include <params_metal_tiles.scad>
// -----------------------------------------------------------------------------------
module roof_tile(length)
{
    cube([tile_width, length, 1]);
}
//------------------------------------------------------------------------------------
