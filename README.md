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
- Libraries tested
  - [sliemeobn/elementary](https://github.com/sliemeobn/elementary) v0.3.4
  - [vapor-community/HTMLKit](https://github.com/vapor-community/HTMLKit) v2.8.1
  - [JohnSundell/Plot](https://github.com/JohnSundell/Plot) v0.14.0
  - [pointfreeco/swift-html](https://github.com/pointfreeco/swift-html) v0.4.1
  - [RandomHashTags/swift-htmlkit](https://github.com/RandomHashTags/swift-htmlkit) v0.4.0 (this library)
<details>
<summary>Results</summary>
At least on my iMac (i9 9900k, 72GB RAM, 2TB) using macOS 15.0 and the Swift 6 compiler.

Worth noting that the metrics not shown below are relatively equal to each other.

<details>
<summary>Time (wall clock) [less is better] <i>[winner: swift-htmlkit by 2.8-15.5x]</i></summary>

```swift
Time (wall clock)
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() (ns) *   │    3847 │    4115 │    4191 │    4295 │    4395 │    5923 │   80057 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() (μs) *         │      21 │      22 │      22 │      22 │      23 │      36 │      95 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() (ns) * │    1348 │    1409 │    1427 │    1477 │    1520 │    1780 │   25990 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() (μs) *  │      13 │      14 │      14 │      15 │      15 │      24 │     134 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() (ns) * │    5137 │    5375 │    5479 │    5627 │    5751 │    9343 │   63323 │   10000 │
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
│ Benchmarks:Elementary simpleHTML() (K)      │     260 │     243 │     239 │     233 │     228 │     169 │      12 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() (K)            │      48 │      46 │      46 │      45 │      44 │      27 │      11 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() (K)    │     742 │     710 │     701 │     677 │     658 │     558 │      38 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() (K)     │      74 │      70 │      70 │      69 │      67 │      42 │       7 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() (K)    │     195 │     186 │     183 │     178 │     174 │     104 │      16 │   10000 │
╘═════════════════════════════════════════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╧═════════╛
```
</details>

<details>
<summary>Instructions [less is better] <i>[winner: swift-htmlkit by 9-124x]</i></summary>

```swift
Instructions
╒═════════════════════════════════════════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╤═════════╕
│ Test                                        │      p0 │     p25 │     p50 │     p75 │     p90 │     p99 │    p100 │ Samples │
╞═════════════════════════════════════════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╪═════════╡
│ Benchmarks:Elementary simpleHTML() (K) *    │      10 │      14 │      14 │      14 │      14 │      15 │      33 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() (K) *          │     135 │     137 │     137 │     137 │     137 │     140 │     172 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() *      │    1086 │    1086 │    1086 │    1089 │    1089 │    1089 │   17126 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() (K) *   │      74 │      79 │      79 │      79 │      80 │      83 │     121 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() (K) *  │      21 │      23 │      23 │      23 │      23 │      24 │      60 │   10000 │
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
│ Benchmarks:Plot simpleHTML() *              │      41 │      41 │      41 │      41 │      41 │      41 │      41 │   10000 │
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
│ Benchmarks:Plot simpleHTML() *              │      41 │      41 │      41 │      41 │      41 │      41 │      41 │   10000 │
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
│ Benchmarks:Plot simpleHTML() *              │     121 │     121 │     121 │     121 │     121 │     121 │     121 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() *      │       2 │       2 │       2 │       2 │       2 │       2 │       2 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() *       │      80 │      80 │      80 │      80 │      80 │      80 │      80 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() *      │      17 │      17 │      17 │      17 │      17 │      17 │      17 │   10000 │
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
│ Benchmarks:Plot simpleHTML() *              │      80 │      80 │      80 │      80 │      80 │      80 │      80 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() *      │       2 │       2 │       2 │       2 │       2 │       2 │       2 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() *       │      59 │      59 │      59 │      59 │      59 │      59 │      59 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() *      │       8 │       8 │       8 │       8 │       8 │       8 │       8 │   10000 │
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
│ Benchmarks:Elementary simpleHTML() (ns) *   │    4204 │    4491 │    4575 │    4675 │    4775 │    6831 │   48706 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() (μs) *         │      21 │      22 │      22 │      23 │      23 │      35 │      75 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() (ns) * │    1788 │    1870 │    1897 │    1923 │    1950 │    2879 │   26419 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() (μs) *  │      14 │      15 │      15 │      15 │      15 │      25 │      73 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() (ns) * │    5550 │    5827 │    5951 │    6083 │    6211 │    9327 │   38927 │   10000 │
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
│ Benchmarks:Elementary simpleHTML() (ns) *   │    7916 │    8319 │    8447 │    8623 │    8855 │   13183 │   55231 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:Plot simpleHTML() (μs) *         │      25 │      26 │      27 │      27 │      27 │      43 │      94 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLKit simpleHTML() (ns) * │    5340 │    5535 │    5599 │    5779 │    5883 │    9063 │   35437 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:SwiftHTMLPF simpleHTML() (μs) *  │      18 │      19 │      19 │      19 │      20 │      33 │     116 │   10000 │
├─────────────────────────────────────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Benchmarks:VaporHTMLKit simpleHTML() (μs) * │       9 │      10 │      10 │      10 │      10 │      19 │      80 │   10000 │
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