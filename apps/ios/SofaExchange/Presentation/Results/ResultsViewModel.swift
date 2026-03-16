import Foundation
import Combine

@MainActor
final class ResultsViewModel: ObservableObject {
    private let baseURL = "http://localhost:3000"
    private var cancellables = Set<AnyCancellable>()

    @Published private var incomingQuery: SearchQuery = SearchQuery()
    @Published private var serializedQuery: String = "{}"
    @Published private var requestQueryItems: [URLQueryItem] = []
    @Published private var fetchCycle: Int = 0
    @Published private var rawListingsDTO: [ListingDTO] = []
    @Published private var mappedListings: [Listing] = []

    enum State {
        case idle
        case loading
        case success([Listing])
        case failure(Error)
    }

    @Published var state: State = .idle

    init() {
        setupBindings()
    }

    func search(query: SearchQuery) {
        state = .loading
        incomingQuery = query
    }

    private func setupBindings() {
        $incomingQuery
            .sink { [weak self] query in
                self?.serializedQuery = self?.serialize(query: query) ?? "{}"
            }
            .store(in: &cancellables)

        $serializedQuery
            .sink { [weak self] serialized in
                self?.requestQueryItems = self?.deserializeToQueryItems(serialized) ?? []
            }
            .store(in: &cancellables)

        $requestQueryItems
            .sink { [weak self] _ in
                self?.fetchCycle += 1
            }
            .store(in: &cancellables)

        $fetchCycle
            .dropFirst()
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.fetchListings()
                }
            }
            .store(in: &cancellables)

        $rawListingsDTO
            .sink { [weak self] dtos in
                self?.mappedListings = dtos.compactMap { $0.toDomain() }
            }
            .store(in: &cancellables)

        $mappedListings
            .sink { [weak self] listings in
                guard let self else { return }
                if case .loading = self.state {
                    self.state = .success(listings)
                } else if case .idle = self.state {
                    self.state = .success(listings)
                }
            }
            .store(in: &cancellables)
    }

    private func fetchListings() async {
        do {
            guard var components = URLComponents(string: "\(baseURL)/listings") else {
                throw URLError(.badURL)
            }
            components.queryItems = requestQueryItems.isEmpty ? nil : requestQueryItems
            guard let url = components.url else {
                throw URLError(.badURL)
            }

            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let dtos = try JSONDecoder().decode([ListingDTO].self, from: data)
            rawListingsDTO = dtos
        } catch {
            state = .failure(error)
        }
    }

    private func serialize(query: SearchQuery) -> String {
        let wire = QueryWire(
            cities: query.cities.map(\.rawValue),
            hasFreeWifi: query.hasFreeWifi,
            sofaType: query.sofaType?.rawValue
        )
        let data = try? JSONEncoder().encode(wire)
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
    }

    private func deserializeToQueryItems(_ serialized: String) -> [URLQueryItem] {
        guard let data = serialized.data(using: .utf8),
              let wire = try? JSONDecoder().decode(QueryWire.self, from: data) else {
            return []
        }

        var items: [URLQueryItem] = []
        items.append(contentsOf: wire.cities.map { URLQueryItem(name: "city", value: $0) })
        if let wifi = wire.hasFreeWifi { items.append(URLQueryItem(name: "hasFreeWifi", value: String(wifi))) }
        if let type = wire.sofaType { items.append(URLQueryItem(name: "sofaType", value: type)) }
        return items
    }
}

private struct QueryWire: Codable {
    let cities: [String]
    let hasFreeWifi: Bool?
    let sofaType: String?
}
