// F-Roof: A multi-function single-layer roof
// https://github.com/f-roof
// Author: Mihai Oltean; https://tcreate.org
//---------------------------------------------------------------------------------------
include <params.scad>
include <params_house.scad>
include <params_truss.scad>

//---------------------------------------------------------------------------------------
use <truss.scad>
use <house_no_roof.scad>

use <basic components/gutter.scad>
use <basic components/solar_panels.scad>
use <basic components/metal_profiles.scad>
use <basic components/screws_nuts_washers.scad>
use <basic components/metal_tiles.scad>

include <basic components/params_solar_panels.scad>
include <basic components/params_metal_profiles.scad>
include <basic components/params_gutter.scad>
//---------------------------------------------------------------------------------------
module roof_solar_panel_side()
{
    for (i = [0:5])
        translate([distance_between_trusses * i, 0, 0]) 
        rotate([-90, 0, 0])
            angle_beam(truss_top_chord_length, angle_roof);
            
     // T profiles
        for (i = [0 : 3])
            translate([0, 0,  0])
            translate([0, first_T_at + (solar_panel_size[1] + T_profile_thick + 2 * tolerance_between_panels) * i, 0])
            T_40_4(6000);
            
        // solar panels
        for (k = [0 : 3])
        for (i = [0 : 2])
            translate([0, 0, 0 + T_profile_thick / 2 + tolerance_between_panels])
            translate([k * solar_panel_size[0], first_T_at + tolerance_between_panels + (solar_panel_size[1] + T_profile_thick + 2 * tolerance_between_panels) * i, 0])
            solar_panel_Hyundai()
            ;
         // screws

        for (k = [0 : 2])
        for (i = [0 : 3]){
            //translate([0, 0,  -10])
            translate([k * distance_between_trusses + truss_side_small_size / 2, first_T_at + (solar_panel_size[1] + T_profile_thick + 2 * tolerance_between_panels) * i, 
            4.1]) mirror([0,0,1]){
                translate([0, -10, 0])
                    M8_sunken (100);
                translate([0, 10, 0])
                    M8_sunken (100);
            }
            }        
}
//---------------------------------------------------------------------------------------
module roof_standard_tiles_side()
{
    for (i = [0 : 5]){
        translate([distance_between_trusses * i, 0, 0]) 
            translate ([truss_side_small_size, 0, 0])   
                rotate([0, 0, 180]) 
                    angle_beam(truss_top_chord_length, angle_roof);
                
        translate([i * distance_between_metal_tiles, 31, start_point_metal_tile])             
            rotate([90, 0, 0])
                roof_tile(4300);
    }
    // wood bars to put the metal roof tiles on it
    for (i = [0 : 10]){
        translate([0, 0, i * distance_between_roof_metal_tiles_support + start_point_metal_tile])
            color("yellow") cube([6000, 30, 40]);
    }
}
//---------------------------------------------------------------------------------------
module roof()
{  
    // metal frame over existing house frame
    // just to reinforce the existing base
    translate([0, 0, 0] + [0, 25, 40]){
        rotate([0, 90, 0]) 
        rectangular_tube(6000, 80, truss_side_small_size);
    }    
    // metal frame, other side
    translate([0, base_house_width - 60, 0] + [0, -25, 40]){
        rotate([0, 90, 0]) 
        rectangular_tube(6000, 60, truss_side_small_size);
    }    
    //now the real roof
    translate([0, 0, truss_base_bar_side_long + 40]){

        translate([0, -0, 0])
            rotate([angle_roof, 0, 0]) 
                roof_solar_panel_side()
                ;
        translate([0, base_house_width + 0, 0])
            rotate([90-angle_roof, 0, 0]) 
                roof_standard_tiles_side();

        for (i = [0 : 5]){
            translate([distance_between_trusses * i, -130 + 60 + 25, 0]){
                truss(angle_roof);
            for (k=[0:27]){
                translate([0, 
                cos(angle_roof) * 155 * k, 
                sin(angle_roof) * 155 * (k)]){
                    translate([-80, 0, -17.5]) 
                        //stair_step(200)
                        ;
                    }
            }
        }
    }       
       
            // gutters
        for (i = [0 : 5]){ // num columns
            translate([distance_between_trusses * i, 0, 0]){
            for (k=[0:4]){ // num rows
                translate([0, 
                cos(angle_roof) * gutter_lindab_radius * k, 
                sin(angle_roof) * gutter_lindab_radius * (k)]){
                    translate([20 + 40, 0, 120 - 17.5])
                        gutter_Lindab(1000)
                    ;
            }
        }
    }
}    
}

// top ridge
    translate ([0, base_house_width / 2, 2800])
       rotate([0, 90, 0])
           ridge(base_length, ridge_radius);
}
//---------------------------------------------------------------------------------------
module house_with_roof()
{
// house
    translate([0, 0, -house_height-2 * base_beam_side]) 
        house();

    // wood frame on the top of the  house
    color("maroon") translate([0, 0, -2 * base_beam_side]) roof_wood_house_support();

    roof();
}
//---------------------------------------------------------------------------------------
house_with_roof();

//roof();

//roof_solar_panel_side();

//roof_tiles_side();