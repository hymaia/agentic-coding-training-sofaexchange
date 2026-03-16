import Foundation

final class ListingsRemoteDataSource {
    private let baseURL: String

    init(baseURL: String = "http://localhost:3000") {
        self.baseURL = baseURL
    }

    func fetchListings(query: SearchQuery) async throws -> [ListingDTO] {
        guard var components = URLComponents(string: "\(baseURL)/listings") else {
            throw URLError(.badURL)
        }

        var queryItems: [URLQueryItem] = []
        queryItems.append(contentsOf: query.cities.map { URLQueryItem(name: "city", value: $0.rawValue) })
        if let wifi = query.hasFreeWifi { queryItems.append(URLQueryItem(name: "hasFreeWifi", value: String(wifi))) }
        if let type = query.sofaType { queryItems.append(URLQueryItem(name: "sofaType", value: type.rawValue)) }
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([ListingDTO].self, from: data)
    }
}
