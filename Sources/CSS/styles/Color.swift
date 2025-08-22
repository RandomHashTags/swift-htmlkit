
import HTMLKitUtilities

extension CSSStyle {
    @frozen
    public enum Color: HTMLInitializable {
        case currentColor
        case hex(String)
        case hsl(Swift.Float, Swift.Float, Swift.Float, Swift.Float? = nil)
        case hwb(Swift.Float, Swift.Float, Swift.Float, Swift.Float? = nil)
        case inherit
        case initial
        case lab(Swift.Float, Swift.Float, Swift.Float, Swift.Float? = nil)
        case lch(Swift.Float, Swift.Float, Swift.Float, Swift.Float? = nil)
        indirect case lightDark(Color, Color)
        case oklab(Swift.Float, Swift.Float, Swift.Float, Swift.Float? = nil)
        case oklch(Swift.Float, Swift.Float, Swift.Float, Swift.Float? = nil)
        case rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Swift.Float? = nil)
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

        /// - Warning: Never use.
        public var key: String { "" }

        // MARK: HTML value
        @inlinable
        public func htmlValue(encoding: HTMLEncoding, forMacro: Bool) -> String? {
            switch self {
            case .hex(let hex): return "#" + hex
            case .rgb(let r, let g, let b, let a):
                var string = "rbg(\(r),\(g),\(b)"
                if let a {
                    string += ",\(a)"
                }
                return string + ")"
            default: return "\(self)".lowercased()
            }
        }
    }
}