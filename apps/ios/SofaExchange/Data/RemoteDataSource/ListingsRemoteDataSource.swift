import Alamofire

final class ListingsRemoteDataSource {
    private let baseURL: String

    init(baseURL: String = "http://localhost:3000") {
        self.baseURL = baseURL
    }

    func fetchListings(query: SearchQuery) async throws -> [ListingDTO] {
        var params: Parameters = [:]
        if !query.cities.isEmpty {
            // Alamofire encodes arrays as repeated keys automatically
            params["city"] = query.cities.map(\.rawValue)
        }
        if let min = query.minPriceCents  { params["minPriceCents"] = min }
        if let max = query.maxPriceCents  { params["maxPriceCents"] = max }
        if let wifi = query.hasFreeWifi   { params["hasFreeWifi"]   = wifi }
        if let type = query.sofaType      { params["sofaType"]      = type.rawValue }

        return try await AF
            .request("\(baseURL)/listings", parameters: params)
            .serializingDecodable([ListingDTO].self)
            .value
    }
}
