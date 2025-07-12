
public enum HTMLResultRepresentation: Equatable, Sendable {


    // MARK: Literal


    /// The result is represented normally as a literal.
    case literal
    /// The result is represented as an optimized literal by differentiating the immutable and mutable parts of the literal.
    case literalOptimized


    // MARK: Chunked


    /// The result is represented as an `Array` of literals of length up-to `chunkSize`.
    /// 
    /// - Parameters:
    ///   - optimized: Whether or not to use optimized literals. Default is `true`.
    ///   - chunkSize: The maximum size of an individual literal. Default is `1024`.
    case chunked(optimized: Bool = true, chunkSize: Int = 1024)

    /// The result is represented as an `InlineArray` of literals of length up-to `chunkSize`.
    /// 
    /// - Parameters:
    ///   - optimized: Whether or not to use optimized literals. Default is `true`.
    ///   - chunkSize: The maximum size of an individual literal. Default is `1024`.
    case chunkedInline(optimized: Bool = true, chunkSize: Int = 1024)



    // MARK: Streamed



    /// The result is represented as an `AsyncStream` of literals of length up-to `chunkSize`.
    /// 
    /// - Parameters:
    ///   - optimized: Whether or not to use optimized literals. Default is `true`.
    ///   - chunkSize: The maximum size of an individual literal. Default is `1024`.
    /// - Warning: The values are yielded synchronously.
    case streamed(optimized: Bool = true, chunkSize: Int = 1024)

    /// The result is represented as an `AsyncStream` of literals of length up-to `chunkSize`.
    /// 
    /// - Parameters:
    ///   - optimized: Whether or not to use optimized literals. Default is `true`.
    ///   - chunkSize: The maximum size of an individual literal. Default is `1024`.
    ///   - suspendDuration: Duration to sleep the `Task` that is yielding the stream results.
    /// - Warning: The values are yielded asynchronously.
    case streamedAsync(optimized: Bool = true, chunkSize: Int = 1024, suspendDuration: Duration? = nil)
}