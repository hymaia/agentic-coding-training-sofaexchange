struct SearchQuery {
    var cities: [City]       = []
    var hasFreeWifi: Bool?   = nil
    var sofaType: SofaType?  = nil
}

protocol ListingsRepositoryProtocol {
    func search(query: SearchQuery) async throws -> [Listing]
}
