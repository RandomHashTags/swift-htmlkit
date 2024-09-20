//
//  HTMLKitUtilities.swift
//
//
//  Created by Evan Anderson on 9/19/24.
//

// MARK: HTMLElementAttribute
public enum HTMLElementAttribute {
}

// MARK: CSSUnit
public extension HTMLElementAttribute {
    struct CSSUnit {
    }
}
public extension HTMLElementAttribute.CSSUnit { // https://www.w3schools.com/cssref/css_units.php
    // absolute
    static func centimeters(_ value: Float) -> Self { Self() }
    static func millimeters(_ value: Float) -> Self { Self() }
    /// 1 inch = 96px = 2.54cm
    static func inches(_ value: Float) -> Self      { Self() }
    /// 1 pixel = 1/96th of 1inch
    static func pixels(_ value: Float) -> Self      { Self() }
    /// 1 point = 1/72 of 1inch
    static func points(_ value: Float) -> Self      { Self() }
    /// 1 pica = 12 points
    static func picas(_ value: Float) -> Self       { Self() }
    
    // relative
    /// Relative to the font-size of the element (2em means 2 times the size of the current font)
    static func em(_ value: Float) -> Self             { Self() }
    /// Relative to the x-height of the current font (rarely used)
    static func ex(_ value: Float) -> Self             { Self() }
    /// Relative to the width of the "0" (zero)
    static func ch(_ value: Float) -> Self             { Self() }
    /// Relative to font-size of the root element
    static func rem(_ value: Float) -> Self            { Self() }
    /// Relative to 1% of the width of the viewport
    static func viewportWidth(_ value: Float) -> Self  { Self() }
    /// Relative to 1% of the height of the viewport
    static func viewportHeight(_ value: Float) -> Self { Self() }
    /// Relative to 1% of viewport's smaller dimension
    static func viewportMin(_ value: Float) -> Self    { Self() }
    /// Relative to 1% of viewport's larger dimension
    static func viewportMax(_ value: Float) -> Self    { Self() }
    /// Relative to the parent element
    static func percent(_ value: Float) -> Self        { Self() }
}

public extension HTMLElementAttribute {
    typealias height = CSSUnit
    typealias width = CSSUnit

    enum `as` : String {
        case audio, document, embed, fetch, font, image, object, script, style, track, video, worker
    }

    enum autocapitalize : String {
        case on, off
        case none
        case sentences, words, characters
    }

    /*enum AutoComplete { // TODO: support
        package enum Value : String {
            case off, on, tokenList([String])

            var rawValue: RawValue {
                return ""
            }
        }
    }*/

    enum blocking : String {
        case render
    }

    enum buttontype : String {
        case submit, reset, button
    }

    enum capture : String {
        case user, environment
    }

    enum contenteditable : String {
        case `true`, `false`
        case plaintextOnly

        public var htmlValue : String {
            switch self {
                case .plaintextOnly: return "plaintext-only"
                default:             return rawValue
            }
        }
    }

    enum controlslist : String {
        case nodownload, nofullscreen, noremoteplayback
    }

    enum crossorigin : String {
        case anonymous
        case useCredentials

        public var htmlValue : String {
            switch self {
                case .useCredentials: return "use-credentials"
                default:              return rawValue
            }
        }
    }

    enum decoding : String {
        case sync, async, auto
    }

    enum dir : String {
        case auto, ltr, rtl
    }

    enum dirname : String {
        case ltr, rtl
    }

    enum draggable : String {
        case `true`, `false`
    }

    enum download : String {
        case filename
    }

    enum enterkeyhint : String {
        case enter, done, go, next, previous, search, send
    }

    enum fetchpriority : String {
        case high, low, auto
    }

    enum formenctype : String {
        case applicationXWWWFormURLEncoded
        case multipartFormData
        case textPlain

        public var htmlValue : String {
            switch self {
                case .applicationXWWWFormURLEncoded: return "application/x-www-form-urlencoded"
                case .multipartFormData:             return "multipart/form-data"
                case .textPlain:                     return "text/plain"
            }
        }
    }

    enum formmethod : String {
        case get, post, dialog
    }

    enum formtarget : String {
        case _self, _blank, _parent, _top
    }

    enum hidden : String {
        case `true`
        case untilFound

        public var htmlValue : String {
            switch self {
                case .true: return ""
                case .untilFound: return "until-found"
            }
        }
    }

    enum httpequiv : String {
        case contentSecurityPolicy
        case contentType
        case defaultStyle
        case xUACompatible
        case refresh

        public var htmlValue : String {
            switch self {
                case .contentSecurityPolicy: return "content-security-policy"
                case .contentType:           return "content-type"
                case .defaultStyle:          return "default-style"
                case .xUACompatible:         return "x-ua-compatible"
                default:                     return rawValue
            }
        }
    }

    enum inputmode : String {
        case none, text, decimal, numeric, tel, search, email, url
    }

    enum loading : String {
        case eager, lazy
    }

    enum numberingtype : String {
        case a, A, i, I, one

        public var htmlValue : String {
            switch self {
                case .one: return "1"
                default:   return rawValue
            }
        }
    }

    enum popover : String {
        case auto, manual
    }
    enum popovertargetaction : String {
        case hide, show, toggle
    }

    enum preload : String {
        case none, metadata, auto
    }

    enum referrerpolicy : String {
        case noReferrer
        case noReferrerWhenDowngrade
        case origin
        case originWhenCrossOrigin
        case sameOrigin
        case strictOrigin
        case strictOriginWhenCrossOrigin
        case unsafeURL

        public var htmlValue : String {
            switch self {
                case .noReferrer:                  return "no-referrer"
                case .noReferrerWhenDowngrade:     return "no-referrer-when-downgrade"
                case .originWhenCrossOrigin:       return "origin-when-cross-origin"
                case .strictOrigin:                return "strict-origin"
                case .strictOriginWhenCrossOrigin: return "strict-origin-when-cross-origin"
                case .unsafeURL:                   return "unsafe-url"
                default:                           return rawValue
            }
        }
    }

    enum Role { // TODO: support
        public enum Value : String {
            case alert
            case alertdialog
            case application
            case article

            case banner
            case button

            case cell
            case checkbox
            case columnheader
            case combobox
            case command
            case comment
            case complementary
            case composite
            case contentinfo

            case definition
            case dialog
            case directory
            //case document(Document)

            case feed
            case figure
            case form

            case generic
            case grid
            case gridcell
            case group

            case heading

            case img
            case input

            case landmark
            case link
            case list
            case listbox
            case listitem
            case log

            case main
            case mark
            case marquee
            case math
            case menu
            case menubar
            case menuitem
            case menuitemcheckbox
            case menuitemradio
            case meter

            case navigation
            case none
            case note

            case option
            
            case presentation
            case progressbar

            case radio
            case radiogroup
            case range
            case region
            case roletype
            case row
            case rowgroup
            case rowheader

            case scrollbar
            case search
            case searchbox
            case section
            case sectionhead
            case select
            case separator
            case slider
            case spinbutton
            case status
            case structure
            case suggestion
            case `switch`

            case tab
            case table
            case tablist
            case tabpanel
            case term
            case textbox
            case timer
            case toolbar
            case tooltip
            case tree
            case treegrid
            case treeitem

            case widget
            case window

            /*package var rawValue : RawValue {
                switch self {
                    case .document(let bro):
                        return bro.rawValue
                    default:
                        return "\(self)"
                }
            }*/

            public enum Document : String {
                case associationlist
                case associationlistitemkey
                case associationlistitemvalue
                case blockquote
                case caption
                case code
                case deletion
                case emphasis
                case figure
                case heading
                case img
                case insertion
                case list
                case listitem
                case mark
                case meter
                case paragraph
                case strong
                case `subscript`
                case superscript
                case term
                case time
            }
        }
    }

    enum sandbox : String {
        case allowDownloads
        case allowForms
        case allowModals
        case allowOrientationLock
        case allowPointerLock
        case allowPopups
        case allowPopupsToEscapeSandbox
        case allowPresentation
        case allowSameOrigin
        case allowScripts
        case allowStorageAccessByUserActiviation
        case allowTopNavigation
        case allowTopNavigationByUserActivation
        case allowTopNavigationToCustomProtocols

        public var htmlValue : String {
            switch self {
                case .allowDownloads:                      return "allow-downloads"
                case .allowForms:                          return "allow-forms"
                case .allowModals:                         return "allow-modals"
                case .allowOrientationLock:                return "allow-orientation-lock"
                case .allowPointerLock:                    return "allow-pointer-lock"
                case .allowPopups:                         return "allow-popups"
                case .allowPopupsToEscapeSandbox:          return "allow-popups-to-escape-sandbox"
                case .allowPresentation:                   return "allow-presentation"
                case .allowSameOrigin:                     return "allow-same-origin"
                case .allowScripts:                        return "allow-scripts"
                case .allowStorageAccessByUserActiviation: return "allow-storage-access-by-user-activation"
                case .allowTopNavigation:                  return "allow-top-navigation"
                case .allowTopNavigationByUserActivation:  return "allow-top-navigation-by-user-activation"
                case .allowTopNavigationToCustomProtocols: return "allow-top-navigation-to-custom-protocols"
            }
        }
    }

    enum scripttype : String {
        case importmap, module, speculationrules
    }

    enum scope : String {
        case row, col, rowgroup, colgroup
    }

    enum shadowrootmode : String {
        case open, closed
    }
    enum shadowrootclonable : String {
        case `true`, `false`
    }

    enum shape : String {
        case rect, circle, poly, `default`
    }

    enum spellcheck : String {
        case `true`, `false`
    }

    enum target : String {
        case _self, _blank, _parent, _top, _unfencedTop
    }

    enum kind : String {
        case subtitles, captions, chapters, metadata
    }

    enum translate : String {
        case yes, no
    }

    enum virtualkeyboardpolicy : String {
        case auto, manual
    }

    enum wrap : String {
        case hard, soft
    }

    enum writingsuggestions : String {
        case `true`, `false`
    }
}
