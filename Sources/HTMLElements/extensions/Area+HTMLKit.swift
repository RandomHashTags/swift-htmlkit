
extension Area {
    public init(
        shape: Shape? = nil,
        alt: Alt? = nil,
        href: Href? = nil,
        download: Download? = nil,
        ping: Ping? = nil,
        referrerpolicy: ReferrerPolicy? = nil,
        rel: String? = nil,
        target: Target? = nil,
        _ innerHTML: () -> Sendable...
    ) {
        self.init(shape: shape, alt: alt, href: href, download: download, ping: ping, referrerpolicy: referrerpolicy, rel: rel, target: target)
    }
    public init(
        shape: Shape? = nil,
        alt: Alt? = nil,
        href: Href? = nil,
        download: Download? = nil,
        ping: Ping? = nil,
        referrerpolicy: ReferrerPolicy? = nil,
        rel: String? = nil,
        target: Target? = nil,
        _ innerHTML: Sendable...
    ) {
        self.init(shape: shape, alt: alt, href: href, download: download, ping: ping, referrerpolicy: referrerpolicy, rel: rel, target: target)
    }
}