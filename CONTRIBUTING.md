# Contributing

## Table of Contents

- [Rules](#rules)
  - [Variable naming](#variable-naming) <sup>[justification](#justification)</sup>
  - [Type annotation](#type-annotation)
    - [Protocols](#protocols)
    - [Variables](#variables) <sup>[exceptions](#exceptions) | [justification](#justification-1)</sup>
  - [Extensions](#extensions) <sup>[justification](#justification-2)</sup>
  - [Documentation](#documentation)

## Rules

The contributing rules of this project follows the Swift [API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) with exceptions, which are described below.

You can format your code running `swift format` with our given format file. Due to `swift-format` lacking in features, some of the exceptions outlined in this document are not enforceable nor auto-corrected. The maintainers will modify any code you commit to adhere to this document.

At the end of the day, you can write however you want. The maintainers will modify the syntax after merging.

### Variable naming

All public facing functions and variables should use `lowerCamelCase`. Non-public functions and variables should use `snake_case`, but it is not required. Snake case is recommended for `package`, `private` and `fileprivate` declarations.

#### Justification

`lowerCamelCase` is recommended by the Swift Language. `snake_case` is more readable and maintainable with larger projects.

### Type annotation

Declaring a native Swift type never contains spaces. The only exception is type aliases.

Example: declaring a dictionary should look like `[String:String]` instead of `Dictionary<String, String>`.

#### Protocols

As protocols outline an implementation, conformances and variables should always be separated by a single space between each token. Conformances should always be sorted alphabetically.

```swift
// ✅ DO
protocol Something : CustomStringConvertible, Hashable, Identifiable {
    var name : String { get }
    var digits : Int { get set }
    var headers : [String:String]? { mutating get }
}

// ❌ DON'T
protocol Something: Identifiable, Hashable,CustomStringConvertible {
    var name:String { get }
    var digits :Int { get set }
    var headers: [String:String]?{mutating get}
}
```

#### Variables

Always type annotate your variables. The syntax of the annotation should not contain any whitespace between the variable name, colon and the declared type. Computed properties should always be separated by a single space between each token.

```swift
// ✅ DO
let _:Int = 1
let string:String? = nil
let array:[UInt8] = []
let _:[String:String] = [:]
let _:[String:String] = [
    "one" : 1,
    "two": 2,
    "three": 3
]

// ❌ DON'T
let _ :Int = 1
let _: Int = -1
let _ : Int = 1
let _:[String :String] = [:]
let _:[String: String] = [:]
let _:[String : String] = [:]

// ⚠️ Exceptions
// sequence iteration
for _ in array {
}

// Closure parameters
let _:(Int, String) = { one, two in }
let _:(Int, String) = { $0; $1 }

// Unwrapping same name optional
if let string {
}

// Computed properties
var name : String {
    "rly"
}
var headers : [String:String] {
    [
        "one": 1,
        "two": 2
        "three" : 3
    ]
}
```

##### Exceptions

- when iterating over a sequence
- declaring or referencing parameters in a closure
- unwrapping same name optional variables
- computed properties

##### Justification

Reduces syntax noise, improves readability

### Extensions

If you're making an `extension` where all content is the same visibility: declare the visibility at the extension level. There are no exceptions.

#### Justification

Waste of disk space to declare the same visibility for every declaration.

### Documentation

Documenting your code is required if you have justification for a change or implementation, otherwise it is not required (but best practice to do so).