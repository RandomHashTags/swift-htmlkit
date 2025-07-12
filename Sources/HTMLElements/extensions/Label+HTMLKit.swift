
extension HTMLElementTypes.Label {
    public init(
        for: For? = nil,
        _ innerHTML: () -> Sendable...
    ) {
        self.init(for: `for`)
    }
    public init(
        for: For? = nil,
        _ innerHTML: Sendable...
    ) {
        self.init(for: `for`)
    }
}