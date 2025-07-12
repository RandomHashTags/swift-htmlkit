
extension HtmlRoot {
    public init(
        xmlns: Xmlns? = nil,
        _ innerHTML: () -> Sendable...
    ) {
        self.init(xmlns: xmlns)
    }
    public init(
        xmlns: Xmlns? = nil,
        _ innerHTML: Sendable...
    ) {
        self.init(xmlns: xmlns)
    }
}