
/// Intermediate storage that renders dynamic HTML content optimally, with minimal overhead.
/// 
/// Made to outperform string concatenation in every way.
public struct HTMLOptimizedLiteral<each Literal: TextOutputStreamable> {
    public let reserveCapacity:Int

    public init(
        reserveCapacity: Int
    ) {
        self.reserveCapacity = reserveCapacity
    }

    @inlinable
    public func render(
        _ literals: (repeat each Literal)
    ) -> String {
        var string = ""
        string.reserveCapacity(reserveCapacity)
        for literal in repeat each literals {
            literal.write(to: &string)
        }
        return string
    }
}

extension StaticString: @retroactive TextOutputStreamable {
    @inlinable
    public func write(to target: inout some TextOutputStream) {
        self.withUTF8Buffer { buffer in
            target.write(String(decoding: buffer, as: UTF8.self))
        }
    }
}