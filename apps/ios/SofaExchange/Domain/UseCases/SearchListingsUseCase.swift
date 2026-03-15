final class SearchListingsUseCase {
    private let repository: ListingsRepositoryProtocol

    init(repository: ListingsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: SearchQuery) async throws -> [Listing] {
        try await repository.search(query: query)
    }
}
