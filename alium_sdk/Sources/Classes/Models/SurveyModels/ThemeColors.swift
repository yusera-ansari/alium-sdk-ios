//
//  ThemeColors.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//

//--color1 - #333333 Background Color
//        --color2 - #ffffff Question Text Color
//        --color3 - #00C764 Button Background Color
//        --color4 - #ffffff  Button Text Color
//
//
//        --color5 - #ffffff  Multiple Choice Background Color
//        --color6 - #00C764  Multiple Choice Icon Color
//        --color7 - #333 Multiple Choice Text Color
//
//        --color8 -  #ffffff Single Choice Background Color
//        --color9 -  #00C764 Single Choice Icon Color
//        --color10 - #333 Single Choice Text Color
//
//        --color11 - #fff NPS Button Background Color
//        --color12 - #333 NPS Button Text Color
//        --color13 - #ffc100 NPS Button selected bg
//        --color14 - #333 NPS Button selected Text Color
//
//
//        --color15 - #fff Opinion Button Background Color
//        --color16 - #333 Opinion Button Text Color
//        --color17 - #ffc100 Opinion Button selected bg
//        --color18 - #333 Opinion Button selected text color
//
//
//        --color19 - #fff Rating Button Background Color
//        --color20 - #333 Rating Button Text Color
//        --color21 - #ffc100 Rating Button selected bg
//        --color22 - #333 Rating utton selected text color
//
//        --color23 - #fff Toggle Icon Color
public struct ThemeColors:Codable{
    public var color1: String = "#88000000"
    public var color2: String = "#88000000"
    public var color3: String = "#88000000"
    public var color4: String = "#88000000"
    public var color5: String = "#88000000"
    public var color6: String = "#88000000"
    public var color7: String = "#88000000"
    public var color8: String = "#88000000"
    public var color9: String = "#88000000"
    public var color10: String = "#88000000"
    public var color11: String = "#88000000"
    public var color12: String = "#88000000"
    public var color13: String = "#88000000"
    public var color14: String = "#88000000"
    public var color15: String = "#88000000"
    public var color16: String = "#88000000"
    public var color17: String = "#88000000"
    public var color18: String = "#88000000"
    public var color19: String = "#88000000"
    public var color20: String = "#88000000"
    public var color21: String = "#88000000"
    public var color22: String = "#88000000"
    public var color23: String = "#88000000"
    
    enum CodingKeys: String, CodingKey {
        case color1  = "c1"
        case color2  = "c2"
        case color3  = "c3"
        case color4  = "c4"
        case color5  = "c5"
        case color6  = "c6"
        case color7  = "c7"
        case color8  = "c8"
        case color9  = "c9"
        case color10 = "c10"
        case color11 = "c11"
        case color12 = "c12"
        case color13 = "c13"
        case color14 = "c14"
        case color15 = "c15"
        case color16 = "c16"
        case color17 = "c17"
        case color18 = "c18"
        case color19 = "c19"
        case color20 = "c20"
        case color21 = "c21"
        case color22 = "c22"
        case color23 = "c23"
    }
}
