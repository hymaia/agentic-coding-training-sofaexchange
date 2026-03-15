import XCTest
@testable import SofaExchange

final class SearchListingsUseCaseTests: XCTestCase {

    // MARK: - Mock

    final class MockListingsRepository: ListingsRepositoryProtocol {
        var capturedQuery: SearchQuery?
        var stubbedResult: [Listing] = []
        var stubbedError: Error?

        func search(query: SearchQuery) async throws -> [Listing] {
            capturedQuery = query
            if let error = stubbedError { throw error }
            return stubbedResult
        }
    }

    // MARK: - Tests

    func test_execute_passesQueryToRepositoryAndReturnsResult() async throws {
        // Arrange
        let mock = MockListingsRepository()
        let expectedListings = [
            Listing(
                id: "123",
                title: "Cozy Sofa in Paris",
                city: .paris,
                pricePerNightCents: 5000,
                sofaType: .sofaBed,
                hasFreeWifi: true,
                createdAt: "2024-01-01T00:00:00Z",
                updatedAt: "2024-01-01T00:00:00Z"
            )
        ]
        mock.stubbedResult = expectedListings

        let query = SearchQuery(
            cities: [.paris],
            minPriceCents: 1000,
            maxPriceCents: 10000,
            hasFreeWifi: true,
            sofaType: .sofaBed
        )

        let useCase = SearchListingsUseCase(repository: mock)

        // Act
        let result = try await useCase.execute(query: query)

        // Assert
        XCTAssertEqual(mock.capturedQuery?.cities, [.paris])
        XCTAssertEqual(mock.capturedQuery?.minPriceCents, 1000)
        XCTAssertEqual(mock.capturedQuery?.maxPriceCents, 10000)
        XCTAssertEqual(mock.capturedQuery?.hasFreeWifi, true)
        XCTAssertEqual(mock.capturedQuery?.sofaType, .sofaBed)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "123")
        XCTAssertEqual(result.first?.title, "Cozy Sofa in Paris")
    }

    func test_execute_propagatesRepositoryError() async {
        // Arrange
        let mock = MockListingsRepository()
        struct NetworkError: Error {}
        mock.stubbedError = NetworkError()
        let useCase = SearchListingsUseCase(repository: mock)

        // Act & Assert
        do {
            _ = try await useCase.execute(query: SearchQuery())
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
