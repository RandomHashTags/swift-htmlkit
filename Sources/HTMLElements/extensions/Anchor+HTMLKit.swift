
extension Anchor {
    public init(
        attributionsrc: AttributionSrc? = nil,
        download: Download? = nil,
        href: Href? = nil,
        hreflang: Hreflang? = nil,
        ping: Ping? = nil,
        referrerpolicy: ReferrerPolicy? = nil,
        rel: Rel? = nil,
        target: Target? = nil,
        _ innerHTML: Sendable...
    ) {
        self.init(attributionsrc: attributionsrc, download: download, href: href, hreflang: hreflang, ping: ping, referrerpolicy: referrerpolicy, rel: rel, target: target)
    }
    public init(
        attributionsrc: AttributionSrc? = nil,
        download: Download? = nil,
        href: Href? = nil,
        hreflang: Hreflang? = nil,
        ping: Ping? = nil,
        referrerpolicy: ReferrerPolicy? = nil,
        rel: Rel? = nil,
        target: Target? = nil,
        _ innerHTML: () -> Sendable...
    ) {
        self.init(attributionsrc: attributionsrc, download: download, href: href, hreflang: hreflang, ping: ping, referrerpolicy: referrerpolicy, rel: rel, target: target)
    }
}