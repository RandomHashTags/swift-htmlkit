Write HTML using Swift Macros.

<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.9+-orange" alt="Requires at least Swift 5.9"></a> <img src="https://img.shields.io/badge/Platforms-Any-gold"> <a href="https://github.com/RandomHashTags/swift-htmlkit/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-Apache_2.0-blue" alt="Apache 2.0 License">

- [Why?](#why)
- [Examples](#examples)
  - [Basic](#basic)
  - [Advanced](#advanced)
- [Benchmarks](#benchmarks)
  - [Conclusion](#conclusion)
- [Contributing](#contributing)
- [Funding](#funding)

## Why?
- Swift Macros are powerful and offer performance benefits
- Alternative libraries may not fit all situations and may restrict how the html is generated/manipulated, prone to human error, or cost a constant performance overhead (middleware, rendering, result builders, etc)
- HTML macros enforce safety, can be used anywhere, and compile directly to strings which are easily manipulated
- The output is minified at no performance cost
## Examples
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
let _:String = #p(["\(string); \(integer); \(float)"])

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
- Libraries tested
  - [sliemeobn/elementary](https://github.com/sliemeobn/elementary) v0.3.4
  - [JohnSundell/Plot](https://github.com/JohnSundell/Plot) v0.14.0
  - [RandomHashTags/swift-htmlkit](https://github.com/RandomHashTags/swift-htmlkit) v0.5.0 (this library)
  - [pointfreeco/swift-html](https://github.com/pointfreeco/swift-html) v0.4.1
  - [vapor-community/HTMLKit](https://github.com/vapor-community/HTMLKit) v2.8.1
<details>
<summary>Results</summary>
At least on my iMac (i9 9900k, 72GB RAM, 2TB) using macOS 15.0 and the Swift 6 compiler.

Worth noting that the metrics not shown below are relatively equal to each other.

Output is from executing this command: `swift package -c release benchmark --grouping metric`

<details>
<summary>Time (wall clock) [less is better] <i>[winner: swift-htmlkit by 3-15x]</i></summary>

```swift
Time (wall clock)
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() (ns) *   │    4029 │    4323 │    4423 │    4535 │    4667 │    5639 │   51920 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() (μs) *         │      20 │      21 │      22 │      22 │      22 │      35 │    9180 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() (ns) * │    1271 │    1394 │    1415 │    1442 │    1508 │    1798 │   26558 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() (μs) *  │      12 │      13 │      13 │      13 │      14 │      29 │      95 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() (ns) * │    4709 │    4967 │    5063 │    5183 │    5299 │   10071 │   86300 │   10000 │
╘═════════════════════════════════════════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╛
```
</details>

<details>
<summary>Throughput (# / s) [more is better] <i>[winner: swift-htmlkit by 3-15x]</i></summary>

```swift
Throughput (# / s)
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() (K)      │     248 │     232 │     226 │     221 │     214 │     177 │      19 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() (K)            │      50 │      47 │      46 │      46 │      45 │      29 │       0 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() (K)    │     787 │     718 │     707 │     694 │     664 │     555 │      38 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() (K)     │      83 │      77 │      76 │      75 │      72 │      35 │      11 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() (K)    │     212 │     201 │     198 │     193 │     189 │      99 │      12 │   10000 │
╘═════════════════════════════════════════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╛
```
</details>

<details>
<summary>Instructions [less is better] <i>[winner: swift-htmlkit by 75-637x]</i></summary>

```swift
Instructions
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() (K) *    │      14 │      14 │      14 │      15 │      15 │      15 │      36 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() (K) *          │     118 │     122 │     122 │     122 │     122 │     125 │    2202 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() *      │     185 │     193 │     193 │     193 │     193 │     193 │   12079 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() (K) *   │      64 │      67 │      67 │      68 │      68 │      72 │     110 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() (K) *  │      17 │      20 │      20 │      20 │      20 │      20 │      42 │   10000 │
╘═════════════════════════════════════════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╛
```
</details>

<details>
<summary>Malloc (total) [less is better] <i>[winner: swift-htmlkit]</i></summary>

```swift
Malloc (total)
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() *        │       2 │       2 │       2 │       2 │       2 │       2 │       2 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() *              │      42 │      42 │      42 │      42 │      42 │      42 │      42 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() *      │       0 │       0 │       0 │       0 │       0 │       0 │       0 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() *       │      20 │      20 │      20 │      20 │      20 │      20 │      21 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() *      │       5 │       5 │       5 │       5 │       5 │       5 │       5 │   10000 │
╘═════════════════════════════════════════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╛
```

</details>

<details>
<summary>Object allocs [less is better] <i>[winner: swift-htmlkit]</i></summary>

```swift
Object allocs
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() *        │       2 │       2 │       2 │       2 │       2 │       2 │       2 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() *              │      42 │      42 │      42 │      42 │      42 │      42 │      42 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() *      │       0 │       0 │       0 │       0 │       0 │       0 │       0 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() *       │      14 │      14 │      14 │      14 │      14 │      14 │      14 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() *      │       5 │       5 │       5 │       5 │       5 │       5 │       5 │   10000 │
╘═════════════════════════════════════════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╛
```

</details>

<details>
<summary>Releases [less is better] <i>[winner: swift-htmlkit]</i></summary>

```swift
Releases
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() *        │       5 │       5 │       5 │       5 │       5 │       5 │       5 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() *              │     126 │     126 │     126 │     126 │     126 │     126 │     126 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() *      │       2 │       2 │       2 │       2 │       2 │       2 │       2 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() *       │      80 │      80 │      80 │      80 │      80 │      80 │      80 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() *      │      16 │      16 │      16 │      16 │      16 │      16 │      16 │   10000 │
╘═════════════════════════════════════════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╛
```

</details>

<details>
<summary>Retains [less is better] <i>[winner: swift-htmlkit & Elementary]</i></summary>

```swift
Retains
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() *        │       2 │       2 │       2 │       2 │       2 │       2 │       2 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() *              │      82 │      82 │      82 │      82 │      82 │      82 │      82 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() *      │       2 │       2 │       2 │       2 │       2 │       2 │       2 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() *       │      59 │      59 │      59 │      59 │      59 │      59 │      59 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() *      │       7 │       7 │       7 │       7 │       7 │       7 │       7 │   10000 │
╘═════════════════════════════════════════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╛
```

</details>

<details>
<summary>Time (user CPU) [less is better] <i>[winner: swift-htmlkit]</i></summary>

```swift
Time (user CPU)
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() (ns) *   │    4501 │    4807 │    4907 │    5019 │    5147 │    6643 │   39542 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() (μs) *         │      20 │      21 │      22 │      22 │      23 │      34 │     272 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() (ns) * │    1606 │    1768 │    1798 │    1841 │    1891 │    3265 │   27394 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() (μs) *  │      12 │      13 │      13 │      14 │      14 │      29 │      76 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() (ns) * │    5175 │    5451 │    5543 │    5643 │    5755 │   11527 │   22320 │   10000 │
╘═════════════════════════════════════════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╛
```

</details>

<details>
<summary>Time (total CPU) [less is better] <i>[winner: swift-htmlkit]</i></summary>

```swift
Time (total CPU)
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() (ns) *   │    8142 │    8535 │    8687 │    8943 │    9159 │   11911 │   53014 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() (μs) *         │      24 │      26 │      26 │      26 │      27 │      41 │    1154 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() (ns) * │    5052 │    5471 │    5527 │    5647 │    5867 │    9655 │   41376 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() (μs) *  │      16 │      17 │      17 │      18 │      18 │      36 │     109 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() (ns) * │    8994 │    9351 │    9495 │    9791 │    9967 │   18255 │   90987 │   10000 │
╘═════════════════════════════════════════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╛
```

</details>

</details>

### Conclusion
This library beats every other Swift HTML library in terms of performance & efficiency.

So stop wasting system resources and energy using other libraries by switching to this one.

## Contributing
Create a PR.

## Funding
Love this library? Consider supporting this project by sponsoring the developers.
- [RandomHashTags](https://github.com/sponsors/RandomHashTags)