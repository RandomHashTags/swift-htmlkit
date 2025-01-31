//
//  Color.swift
//
//
//  Created by Evan Anderson on 12/10/24.
//

import HTMLKitUtilities
import SwiftSyntax
import SwiftSyntaxMacros

extension CSSStyle {
    public enum Color : HTMLParsable {
        case currentColor
        case hex(String)
        case hsl(SFloat, SFloat, SFloat, SFloat? = nil)
        case hwb(SFloat, SFloat, SFloat, SFloat? = nil)
        case inherit
        case initial
        case lab(SFloat, SFloat, SFloat, SFloat? = nil)
        case lch(SFloat, SFloat, SFloat, SFloat? = nil)
        indirect case lightDark(Color, Color)
        case oklab(SFloat, SFloat, SFloat, SFloat? = nil)
        case oklch(SFloat, SFloat, SFloat, SFloat? = nil)
        case rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: SFloat? = nil)
        case transparent

        case aliceBlue
        case antiqueWhite
        case aqua
        case aquamarine
        case azure
        case beige
        case bisque
        case black
        case blanchedAlmond
        case blue
        case blueViolet
        case brown
        case burlyWood
        case cadetBlue
        case chartreuse
        case chocolate
        case coral
        case cornflowerBlue
        case cornsilk
        case crimson
        case cyan
        case darkBlue
        case darkCyan
        case darkGoldenRod
        case darkGray, darkGrey
        case darkGreen
        case darkKhaki
        case darkMagenta
        case darkOliveGreen
        case darkOrange
        case darkOrchid
        case darkRed
        case darkSalmon
        case darkSeaGreen
        case darkSlateBlue
        case darkSlateGray, darkSlateGrey
        case darkTurquoise
        case darkViolet
        case deepPink
        case deepSkyBlue
        case dimGray, dimGrey
        case dodgerBlue
        case fireBrick
        case floralWhite
        case forestGreen
        case fuchsia
        case gainsboro
        case ghostWhite
        case gold
        case goldenRod
        case gray, grey
        case green
        case greenYellow
        case honeyDew
        case hotPink
        case indianRed
        case indigo
        case ivory
        case khaki
        case lavender
        case lavenderBlush
        case lawnGreen
        case lemonChiffon
        case lightBlue
        case lightCoral
        case lightCyan
        case lightGoldenRodYellow
        case lightGray, lightGrey
        case lightGreen
        case lightPink
        case lightSalmon
        case lightSeaGreen
        case lightSkyBlue
        case lightSlateGray, lightSlateGrey
        case lightSteelBlue
        case lightYellow
        case lime
        case limeGreen
        case linen
        case magenta
        case maroon
        case mediumAquaMarine
        case mediumBlue
        case mediumOrchid
        case mediumPurple
        case mediumSeaGreen
        case mediumSlateBlue
        case mediumSpringGreen
        case mediumTurquoise
        case mediumVioletRed
        case midnightBlue
        case mintCream
        case mistyRose
        case moccasin
        case navajoWhite
        case navy
        case oldLace
        case olive
        case oliveDrab
        case orange
        case orangeRed
        case orchid
        case paleGoldenRod
        case paleGreen
        case paleTurquoise
        case paleVioletRed
        case papayaWhip
        case peachPuff
        case peru
        case pink
        case plum
        case powderBlue
        case purple
        case rebeccaPurple
        case red
        case rosyBrown
        case royalBlue
        case saddleBrown
        case salmon
        case sandyBrown
        case seaGreen
        case seaShell
        case sienna
        case silver
        case skyBlue
        case slateBlue
        case slateGray, slateGrey
        case snow
        case springGreen
        case steelBlue
        case tan
        case teal
        case thistle
        case tomato
        case turquoise
        case violet
        case wheat
        case white
        case whiteSmoke
        case yellow
        case yellowGreen

        // MARK: init
        public init?(context: HTMLExpansionContext) {
            switch context.key {
            case "currentColor": self = .currentColor
            case "inherit": self = .inherit
            case "initial": self = .initial
            case "transparent": self = .transparent

            case "aliceBlue": self = .aliceBlue
            case "antiqueWhite": self = .antiqueWhite
            case "aqua": self = .aqua
            case "aquamarine": self = .aquamarine
            case "azure": self = .azure
            case "beige": self = .beige
            case "bisque": self = .bisque
            case "black": self = .black
            case "blanchedAlmond": self = .blanchedAlmond
            case "blue": self = .blue
            case "blueViolet": self = .blueViolet
            case "brown": self = .brown
            case "burlyWood": self = .burlyWood
            case "cadetBlue": self = .cadetBlue
            case "chartreuse": self = .chartreuse
            case "chocolate": self = .chocolate
            case "coral": self = .coral
            case "cornflowerBlue": self = .cornflowerBlue
            case "cornsilk": self = .cornsilk
            case "crimson": self = .crimson
            case "cyan": self = .cyan
            case "darkBlue": self = .darkBlue
            case "darkCyan": self = .darkCyan
            case "darkGoldenRod": self = .darkGoldenRod
            case "darkGray": self = .darkGray
            case "darkGrey": self = .darkGrey
            case "darkGreen": self = .darkGreen
            case "darkKhaki": self = .darkKhaki
            case "darkMagenta": self = .darkMagenta
            case "darkOliveGreen": self = .darkOliveGreen
            case "darkOrange": self = .darkOrange
            case "darkOrchid": self = .darkOrchid
            case "darkRed": self = .darkRed
            case "darkSalmon": self = .darkSalmon
            case "darkSeaGreen": self = .darkSeaGreen
            case "darkSlateBlue": self = .darkSlateBlue
            case "darkSlateGray": self = .darkSlateGray
            case "darkSlateGrey": self = .darkSlateGrey
            case "darkTurquoise": self = .darkTurquoise
            case "darkViolet": self = .darkViolet
            case "deepPink": self = .deepPink
            case "deepSkyBlue": self = .deepSkyBlue
            case "dimGray": self = .dimGray
            case "dimGrey": self = .dimGrey
            case "dodgerBlue": self = .dodgerBlue
            case "fireBrick": self = .fireBrick
            case "floralWhite": self = .floralWhite
            case "forestGreen": self = .forestGreen
            case "fuchsia": self = .fuchsia
            case "gainsboro": self = .gainsboro
            case "ghostWhite": self = .ghostWhite
            case "gold": self = .gold
            case "goldenRod": self = .goldenRod
            case "gray": self = .gray
            case "grey": self = .grey
            case "green": self = .green
            case "greenYellow": self = .greenYellow
            case "honeyDew": self = .honeyDew
            case "hotPink": self = .hotPink
            case "indianRed": self = .indianRed
            case "indigo": self = .indigo
            case "ivory": self = .ivory
            case "khaki": self = .khaki
            case "lavender": self = .lavender
            case "lavenderBlush": self = .lavenderBlush
            case "lawnGreen": self = .lawnGreen
            case "lemonChiffon": self = .lemonChiffon
            case "lightBlue": self = .lightBlue
            case "lightCoral": self = .lightCoral
            case "lightCyan": self = .lightCyan
            case "lightGoldenRodYellow": self = .lightGoldenRodYellow
            case "lightGray": self = .lightGray
            case "lightGrey": self = .lightGrey
            case "lightGreen": self = .lightGreen
            case "lightPink": self = .lightPink
            case "lightSalmon": self = .lightSalmon
            case "lightSeaGreen": self = .lightSeaGreen
            case "lightSkyBlue": self = .lightSkyBlue
            case "lightSlateGray": self = .lightSlateGray
            case "lightSlateGrey": self = .lightSlateGrey
            case "lightSteelBlue": self = .lightSteelBlue
            case "lightYellow": self = .lightYellow
            case "lime": self = .lime
            case "limeGreen": self = .limeGreen
            case "linen": self = .linen
            case "magenta": self = .magenta
            case "maroon": self = .maroon
            case "mediumAquaMarine": self = .mediumAquaMarine
            case "mediumBlue": self = .mediumBlue
            case "mediumOrchid": self = .mediumOrchid
            case "mediumPurple": self = .mediumPurple
            case "mediumSeaGreen": self = .mediumSeaGreen
            case "mediumSlateBlue": self = .mediumSlateBlue
            case "mediumSpringGreen": self = .mediumSpringGreen
            case "mediumTurquoise": self = .mediumTurquoise
            case "mediumVioletRed": self = .mediumVioletRed
            case "midnightBlue": self = .midnightBlue
            case "mintCream": self = .mintCream
            case "mistyRose": self = .mistyRose
            case "moccasin": self = .moccasin
            case "navajoWhite": self = .navajoWhite
            case "navy": self = .navy
            case "oldLace": self = .oldLace
            case "olive": self = .olive
            case "oliveDrab": self = .oliveDrab
            case "orange": self = .orange
            case "orangeRed": self = .orangeRed
            case "orchid": self = .orchid
            case "paleGoldenRod": self = .paleGoldenRod
            case "paleGreen": self = .paleGreen
            case "paleTurquoise": self = .paleTurquoise
            case "paleVioletRed": self = .paleVioletRed
            case "papayaWhip": self = .papayaWhip
            case "peachPuff": self = .peachPuff
            case "peru": self = .peru
            case "pink": self = .pink
            case "plum": self = .plum
            case "powderBlue": self = .powderBlue
            case "purple": self = .purple
            case "rebeccaPurple": self = .rebeccaPurple
            case "red": self = .red
            case "rosyBrown": self = .rosyBrown
            case "royalBlue": self = .royalBlue
            case "saddleBrown": self = .saddleBrown
            case "salmon": self = .salmon
            case "sandyBrown": self = .sandyBrown
            case "seaGreen": self = .seaGreen
            case "seaShell": self = .seaShell
            case "sienna": self = .sienna
            case "silver": self = .silver
            case "skyBlue": self = .skyBlue
            case "slateBlue": self = .slateBlue
            case "slateGray": self = .slateGray
            case "slateGrey": self  = .slateGrey
            case "snow": self = .snow
            case "springGreen": self = .springGreen
            case "steelBlue": self = .steelBlue
            case "tan": self = .tan
            case "teal": self = .teal
            case "thistle": self = .thistle
            case "tomato": self = .tomato
            case "turquoise": self = .turquoise
            case "violet": self = .violet
            case "wheat": self = .wheat
            case "white": self = .white
            case "whiteSmoke": self = .whiteSmoke
            case "yellow": self = .yellow
            case "yellowGreen": self = .yellowGreen
            default: return nil
            }
        }

        /// - Warning: Never use.
        public var key : String { "" }

        // MARK: HTML value
        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .hex(let hex): return "#" + hex
            case .rgb(let r, let g, let b, let a):
                var string:String = "rbg(\(r),\(g),\(b)"
                if let a:SFloat = a {
                    string += ",\(a)"
                }
                return string + ")"
            default: return "\(self)".lowercased()
            }
        }

        @inlinable
        public var htmlValueIsVoidable : Bool { false }
    }
}