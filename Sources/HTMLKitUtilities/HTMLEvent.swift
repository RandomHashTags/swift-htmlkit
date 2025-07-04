
public enum HTMLEvent: String, HTMLParsable {
    case accept, afterprint, animationend, animationiteration, animationstart
    case beforeprint, beforeunload, blur
    case canplay, canplaythrough, change, click, contextmenu, copy, cut
    case dblclick, drag, dragend, dragenter, dragleave, dragover, dragstart, drop, durationchange
    case ended, error
    case focus, focusin, focusout, fullscreenchange, fullscreenerror
    case hashchange
    case input, invalid
    case keydown, keypress, keyup
    case languagechange, load, loadeddata, loadedmetadata, loadstart
    case message, mousedown, mouseenter, mouseleave, mousemove, mouseover, mouseout, mouseup
    case offline, online, open
    case pagehide, pageshow, paste, pause, play, playing, popstate, progress
    case ratechange, resize, reset
    case scroll, search, seeked, seeking, select, show, stalled, storage, submit, suspend
    case timeupdate, toggle, touchcancel, touchend, touchmove, touchstart, transitionend
    case unload
    case volumechange
    case waiting, wheel
}