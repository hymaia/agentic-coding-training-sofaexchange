import Foundation
import Combine

@MainActor
final class ResultsViewModel: ObservableObject {
    private let searchUseCase: SearchListingsUseCase

    enum State {
        case idle
        case loading
        case success([Listing])
        case failure(Error)
    }

    @Published var state: State = .idle

    init(useCase: SearchListingsUseCase = SearchListingsUseCase(repository: ListingsRepositoryImpl())) {
        self.searchUseCase = useCase
    }

    func search(query: SearchQuery) {
        state = .loading
        Task {
            do {
                let listings = try await searchUseCase.execute(query: query)
                state = .success(listings)
            } catch {
                state = .failure(error)
            }
        }
    }
}
