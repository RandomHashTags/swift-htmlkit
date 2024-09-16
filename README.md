Write HTML using Swift Macros.

## Why Use?
- Swift Macros are powerful and offer performance benefits to alternative libraries relying on runtime performance
- Alternative libraries may not fit all situations and may restrict how the html is generated or manipulated, or is prone to html errors (by human error or otherwise)
- HTML macros enforces safety by default, can be used anywhere, and compile directly to strings which can be easily manipulated
- The compiled output is valid, minified html
## Syntax
- prepend the html element you want with the macro delimiter (`#<html element name>()`)
  - create `html` element: `#html(innerHTML: [])`
  - create `body` element: `#body()`
  - create `div` element: `#div()`
  - create `div` element with "dark" and "mode" classes: `#div(attributes: [.class(["dark", "mode"])])`
### Example
This html is compiled by following code
```html
<html><body><div class="dark mode" title="Hover over message" draggable="false" inputmode="email" hidden="hidden">Unconstrained text<div></div><a><div><abbr></abbr></div></a><div></div><button disabled></button><video autoplay preload="auto" src="ezclap" width="5"></video></div></body></html>
```
```swift
let test:String = #html(innerHTML: [
    #body(innerHTML: [
        #div(
            attributes: [
                .class(["dark", "mode"]),
                .title("Hover over message"),
                .draggable(.false),
                .inputMode(.email),
                .hidden(.hidden)
            ],
            innerHTML: [
                "Unconstrained text",
                #div(),
                #a(innerHTML: [#div(innerHTML: [#abbr()])]),
                #div(),
                #button(disabled: true),
                #video(autoplay: true, controls: false, height: nil, preload: .auto, src: "ezclap", width: 5),
            ]
        )
    ])
])
```
