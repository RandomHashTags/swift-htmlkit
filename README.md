Write HTML using Swift Macros.

## Why Use?
- Swift Macros are powerful and offer performance benefits to alternative libraries relying on runtime performance (middleware, rendering, result builders, etc)
- Alternative libraries may not fit all situations and may restrict how the html is generated or manipulated, or is prone to html errors (by human error or otherwise)
- HTML macros enforce safety, can be used anywhere, and compile directly to strings which are easily manipulated
- The compiled output is valid, minified html
### Examples
```swift
let test:String = #html([
    #body([
        #div(
            attributes: [
                .class(["dark", "mode"]),
                .title("Hover over message"),
                .draggable(.false),
                .inputMode(.email),
                .hidden(.hidden)
            ],
            [
                "Random text",
                #div(),
                #a([#div([#abbr()])]),
                #div(),
                #button(disabled: true),
                #video(autoplay: true, controls: false, height: nil, preload: .auto, src: "ezclap", width: 5),
            ]
        )
    ])
])
```
```swift
func testExample2() {
    var test:TestStruct = TestStruct(name: "one", array: ["1", "2", "3"])
    XCTAssertEqual(test.html, "<p>one123</p>")
    
    test.name = "two"
    test.array = [4, 5, 6, 7, 8]
    XCTAssertEqual(test.html, "<p>two45678</p>")
}
struct TestStruct {
    var name:String
    var array:[CustomStringConvertible]
    
    var html : String { #p(["\(name)", "\(array.map({ "\($0)" }).joined())"]) }
}
```
