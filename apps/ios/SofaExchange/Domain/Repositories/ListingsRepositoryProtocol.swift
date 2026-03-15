struct SearchQuery {
    var cities: [City]       = []
    var minPriceCents: Int?  = nil
    var maxPriceCents: Int?  = nil
    var hasFreeWifi: Bool?   = nil
    var sofaType: SofaType?  = nil
}

protocol ListingsRepositoryProtocol {
    func search(query: SearchQuery) async throws -> [Listing]
}
