
public enum HTMLExpansionResultType: Sendable {


    // MARK: Literal


    /// - Returns: The normal encoded literal.
    case literal

    /// Reduces overhead when working with dynamic content.
    /// 
    /// - Returns: An optimized literal by differentiating the immutable and mutable parts of the encoded literal.
    //case literalOptimized


    // MARK: Chunked


    /// - Parameters:
    ///   - optimized: Whether or not to use optimized literals. Default is `true`.
    ///   - chunkSize: The maximum size of an individual literal. Default is `1024`.
    ///   - Returns: An array of encoded literals of length up-to `chunkSize`.
    case chunked(optimized: Bool = true, chunkSize: Int = 1024)

    #if compiler(>=6.2)
    /// - Parameters:
    ///   - optimized: Whether or not to use optimized literals. Default is `true`.
    ///   - chunkSize: The maximum size of an individual literal. Default is `1024`.
    /// - Returns: An `InlineArray` of encoded literals of length up-to `chunkSize`.
    case chunkedInline(optimized: Bool = true, chunkSize: Int = 1024)
    #endif



    // MARK: Streamed



    /// - Parameters:
    ///   - optimized: Whether or not to use optimized literals. Default is `true`.
    ///   - chunkSize: The maximum size of an individual literal. Default is `1024`.
    /// - Returns: An `AsyncStream` of encoded literals of length up-to `chunkSize`.
    /// - Warning: The values are yielded synchronously.
    case streamed(optimized: Bool = true, chunkSize: Int = 1024)

    /// - Parameters:
    ///   - optimized: Whether or not to use optimized literals. Default is `true`.
    ///   - chunkSize: The maximum size of an individual literal. Default is `1024`.
    ///   - afterYield: Work to execute after yielding a result. The `Int` closure parameter is the index of the yielded result.
    /// - Returns: An `AsyncStream` of encoded literals of length up-to `chunkSize`.
    /// - Warning: The values are yielded synchronously in a new `Task`. Populate `afterYield` with async work to make it completely asynchronous.
    case streamedAsync(
        optimized: Bool = true,
        chunkSize: Int = 1024,
        _ afterYield: @Sendable (Int) async throws -> Void = { yieldIndex in }
    )
}

// MARK: HTMLExpansionResultTypeAST
public enum HTMLExpansionResultTypeAST: Sendable {
    case literal
    //case literalOptimized

    case chunked(optimized: Bool = true, chunkSize: Int = 1024)

    #if compiler(>=6.2)
    case chunkedInline(optimized: Bool = true, chunkSize: Int = 1024)
    #endif

    case streamed(optimized: Bool = true, chunkSize: Int = 1024)
    case streamedAsync(
        optimized: Bool = true,
        chunkSize: Int = 1024,
        yieldVariableName: String? = nil,
        afterYield: String? = nil
    )
}