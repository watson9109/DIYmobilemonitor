include<BOSL2/std.scad>

$fs = 0.1;
Display_width = 326;
Display_height = 197; 
Display_tail_width = 220;
Display_tail_height = 12;
Display_depth = 2;
Display_bezel = 2;

Monitor_width = Display_width + 10;
Monitor_height = Display_height + Display_tail_height + 10;
Monitor_depth = Display_depth + 3;

module NutHole() {
    cylinder(d = 3.5, h = 4);
}

module Display_Whole() {
    union() {
        cube([Display_width, Display_height, Display_depth], anchor=TOP){
            attach(FWD, FWD){
                cube([Display_tail_width, Display_tail_height, Display_depth], center=true);
            }
        }
    }
}

module Display_Area() {
    cube([Display_width - Display_bezel, Display_height - Display_bezel, Display_depth], anchor=BOTTOM);
}

module MonitorCup() {
    difference(){
        cube([Monitor_width, Monitor_height, Monitor_depth], anchor=TOP);
        back(Display_tail_height/2) {
            Display_Whole();
        }
    }    
}

module MonitorCover() {
    difference(){
        cube([Monitor_width, Monitor_height, Display_depth], anchor=BOTTOM);
        back(Display_tail_height/2) {
            Display_Area();
        }
    }
}

module main() { 
    MonitorCup();
//    translate([0, Monitor_height + 10, 0]){
        MonitorCover();
//    }
}

main();

// やること
// 上蓋つくりと蓋を閉めるためのネジ穴
// 造形可能サイズに分割
// 基板を取り付ける部分の作成と基板ネジ穴



// difference(){
//     translate([0,0,22.5]){
//         cube([80,120,50],center=true);
//     }
//     translate([129,0,0]){
//         import("HexBassFull.stl");
//     }


// }