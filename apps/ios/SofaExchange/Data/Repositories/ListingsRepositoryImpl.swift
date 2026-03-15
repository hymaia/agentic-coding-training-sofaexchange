final class ListingsRepositoryImpl: ListingsRepositoryProtocol {
    private let remoteDataSource: ListingsRemoteDataSource

    init(remoteDataSource: ListingsRemoteDataSource = ListingsRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func search(query: SearchQuery) async throws -> [Listing] {
        let dtos = try await remoteDataSource.fetchListings(query: query)
        return dtos.compactMap { $0.toDomain() }
    }
}
