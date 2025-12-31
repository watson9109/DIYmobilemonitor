include<BOSL2/std.scad>

$fs = 0.1;
PanelSize = [326, 197, 2];
PanelTailSize = [220, 12, PanelSize[2]];
PanelBezel = 2;

// ConBoardPos = 152;


FTSize = [0, 20, 1.5]; // 長さ * 幅 * 厚みだが、フレキの長さは測定しない。

ConBoardSize = [38, 69, 3];
ConNutPos = [ //コントローラボード背面から見た場合
    [1.7,  -1.7], 
    [15.5, -1.7],
    [15.5, -45.7]
];

Thick = 3;
MonitorBezel = 5;
MonitorCupSize = [PanelSize[0] + 2 * MonitorBezel, PanelSize[1] + PanelTailSize[1] + 2 * MonitorBezel, PanelSize[2] + Thick + ConBoardSize[2]];
MonitorCoverSize = [MonitorCupSize[0], MonitorCupSize[1], Thick];
MonitorSize = [MonitorCupSize[0], MonitorCupSize[1], MonitorCupSize[2] + MonitorCoverSize[2] + ConBoardSize[2]];

FTConnPos = 114.4; // パネル左端からの距離
FTConConnPos = 15; // コントローラボード上端からの距離
FTPath = [
    [- MonitorSize[0]/2 + FTConnPos, - PanelSize[1]/2],
    [- MonitorSize[0]/2 + FTConnPos, ConBoardSize[1]/2 - FTConConnPos],
    [- PanelSize[0]/2 + ConBoardSize[0] -10, ConBoardSize[1]/2 - FTConConnPos]
];

NutPos = [
    [   MonitorSize[0]/2 - MonitorBezel/2,   MonitorSize[1]/2 - MonitorBezel/2],
    [   MonitorSize[0]/2 - MonitorBezel/2, - MonitorSize[1]/2 + MonitorBezel/2],
    [ - MonitorSize[0]/2 + MonitorBezel/2,   MonitorSize[1]/2 - MonitorBezel/2],
    [ - MonitorSize[0]/2 + MonitorBezel/2, - MonitorSize[1]/2 + MonitorBezel/2]
];
InNut = [2, 3,  3.5]; // 内径 * 高さ * 外径

NutHead = [4.1, 1.5]; //ナットの頭の径 * 高さ

module NutHole(d, h) {
    cylinder(d = d, h = h);
}

module PanelWhole() {
    union() {
        cuboid (PanelSize, anchor=TOP){
            attach(FWD, FWD){
                cuboid (PanelTailSize);
            }
        }
    }
}

module DisplayArea() {
    cuboid ([PanelSize[0] - PanelBezel, PanelSize[1] - PanelBezel, MonitorCoverSize[2]], anchor=BOTTOM);
}

module MonitorCup() {
    difference(){
        cuboid(MonitorCupSize, anchor=TOP);

                back(PanelTailSize[1]/2) {
                    PanelWhole();
                }
                for (i = NutPos){
                    translate([i[0], i[1],  - InNut[1]]){
                        NutHole(InNut[2], InNut[1]);
                    }
                }
                translate([-(MonitorSize[0] - ConBoardSize[0])/2, PanelTailSize[1]/2, - MonitorCupSize[2]]){
                    cuboid(ConBoardSize, anchor=BOTTOM);
                    translate([-ConBoardSize[0]/2, ConBoardSize[1]/2, 0]){
                        for (i = ConNutPos){
                            translate([i[0], i[1],  0]){
                                NutHole(InNut[2], InNut[1] + ConBoardSize[2]);
                            }
                        }                        
                    }
                }
                translate([-MonitorSize[0]/2 + FTConnPos,  (PanelTailSize[1] - PanelSize[1])/2,  - MonitorCupSize[2]]){
                    cuboid([FTSize[1], FTSize[2], MonitorCupSize[2]], anchor=BOTTOM);
                }
                translate([0, 0, -MonitorCupSize[2]]){
                    linear_extrude(FTSize[2]){
                        stroke(FTPath, width=FTSize[1]);
                    }
                }
    }    
}

module MonitorCover() {
    difference(){
        cuboid(MonitorCoverSize, anchor=BOTTOM);

            back(PanelTailSize[1]/2) {
                DisplayArea();
            }
            for (i = NutPos){
                translate([i[0], i[1], 0]){
                    NutHole(InNut[0] + 0.2, MonitorCoverSize[2]);
                }
            }
            for (i = NutPos){
                translate([i[0], i[1],  MonitorCoverSize[2]-NutHead[1]]){
                    NutHole(NutHead[0], NutHead[1]);
                }
            }
    }
}

module main() { 
    MonitorCup();
    translate([0, MonitorSize[1] + 10, 0]){
        MonitorCover();
    }
}

main();



// やること
// 上蓋つくりと蓋を閉めるためのネジ穴
// 造形可能サイズに分割
// 基板を取り付ける部分の作成と基板ネジ穴



// difference(){
//     translate([0,0,22.5]){
//         cuboid ([80,120,50],center=true);
//     }
//     translate([129,0,0]){
//         import("HexBassFull.stl");
//     }


// }