Write HTML using Swift Macros.

## Why?
- Swift Macros are powerful and offer performance benefits
- Alternative libraries may not fit all situations and may restrict how the html is generated/manipulated, prone to human error, or cost a constant performance overhead (middleware, rendering, result builders, etc)
- HTML macros enforce safety, can be used anywhere, and compile directly to strings which are easily manipulated
- The output is minified at no performance cost
## Examples
```swift
let test:String = #html([
    #body([
        #div(
            class: ["dark-mode", "row"],
            draggable: .false,
            hidden: .true,
            inputmode: .email,
            title: "Hey, you're pretty cool",
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
