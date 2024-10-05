Write HTML using Swift Macros.
- [Why?](#why)
- [Examples](#examples)
  - [Basic](#basic)
  - [Advanced](#advanced)
- [Benchmarks](#benchmarks)

## Why?
- Swift Macros are powerful and offer performance benefits
- Alternative libraries may not fit all situations and may restrict how the html is generated/manipulated, prone to human error, or cost a constant performance overhead (middleware, rendering, result builders, etc)
- HTML macros enforce safety, can be used anywhere, and compile directly to strings which are easily manipulated
- The output is minified at no performance cost
## Examples
<style>
    details { padding-left:20px }
    summary { margin-left:-20px }
</style>
### Basic
<details>
<summary>How do I use this library?</summary>

Syntax: `#<html element>(attributes: [], <element specific attributes>: V?, _ innerHTML: [ExpressibleByStringLiteral])`
#### Examples

```swift
// <div class="dark"><p>Macros are beautiful</p></div>
#div(attributes: [.class(["dark"])], [
    #p(["Macros are beautiful"])
])

// <a href="https://github.com/RandomHashTags/litleagues" target="_blank"></a>
#a(href: "https://github.com/RandomHashTags/litleagues", target: ._blank)

// <input id="funny-number" max="420" min="69" name="funny_number" step="1" type="number" value="69">
#input(
    attributes: [.id("funny-number")],
    max: 420,
    min: 69,
    name: "funny_number",
    step: 1,
    type: .number,
    value: "69"
)

// html example
let test:String = #html([
    #body([
        #div(
            attributes: [
                .class(["dark-mode", "row"]),
                .draggable(.false),
                .hidden(.true),
                .inputmode(.email),
                .title("Hey, you're pretty cool")
            ],
            [
                "Random text",
                #div(),
                #a([
                    #div([
                        #abbr()
                    ]),
                    #address()
                ]),
                #div(),
                #button(disabled: true),
                #video(autoplay: true, controls: false, preload: .auto, src: "https://github.com/RandomHashTags/litleagues", width: .centimeters(1)),
            ]
        )
    ])
])
```
</details>

<details>
<summary>How do I encode variables?</summary>
Using String Interpolation.

#### Example
```swift
let string:String = "any string value", integer:Int = -69, float:Float = 3.14159

// ✅ DO
let _:String = #p(["\(string) \(integer); \(float)"])

// ❌ DON'T
let _:String = #p([string, "; ", String(describing: integer), "; ", float.description])
```

</details>

### Advanced
<details>
<summary>I need a custom element!</summary>

Use the `#custom(tag:isVoid:attributes:innerHTML:)` macro.
#### Example
We want to show the [Apple Pay button](https://developer.apple.com/documentation/apple_pay_on_the_web/displaying_apple_pay_buttons_using_javascript#3783424):
```swift
#custom(tag: "apple-pay-button", isVoid: false, attributes: [.custom("buttonstyle", "black"), .custom("type", "buy"), .custom("locale", "el-GR")])
```
becomes
```html
<apple-pay-button buttonstyle="black" type="buy" locale="el-GR"></apple-pay-button>
```

</details>

<details>
<summary>I need a custom attribute!</summary>

Use `HTMLElementAttribute.custom(id:value:)`
#### Example
We want to show the [Apple Pay button](https://developer.apple.com/documentation/apple_pay_on_the_web/displaying_apple_pay_buttons_using_javascript#3783424):
```swift
#custom(tag: "apple-pay-button", isVoid: false, attributes: [.custom("buttonstyle", "black"), .custom("type", "buy"), .custom("locale", "el-GR")])
```
becomes
```html
<apple-pay-button buttonstyle="black" type="buy" locale="el-GR"></apple-pay-button>
```

</details>

<details>
<summary>I need to listen for events!</summary>

> <strong>WARNING</strong>
>
> Inline event handlers are an outdated way to handle events.
>
> General consensus considers this \"bad practice\" and you shouldn't mix your HTML and JavaScript.
>
> This remains deprecated to encourage use of other techniques.
>
> Learn more at https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Building_blocks/Events#inline_event_handlers_—_dont_use_these.

Use the `HTMLElementAttribute.event(<type>, "<value>")`.
#### Example
```swift
#div(attributes: [.event(.click, "doThing()"), .event(.change, "doAnotherThing()")])
```
</details>

## Benchmarks
<details>
<summary>Methodology</summary>
Coming soon
</details>

## Contributing
Create a PR.