import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    var selectedCities: [City]      = []
    var hasFreeWifi: Bool?           = nil
    var selectedSofaType: SofaType?  = nil

    func buildQuery() -> SearchQuery {
        SearchQuery(
            cities:      selectedCities,
            hasFreeWifi: hasFreeWifi,
            sofaType:    selectedSofaType
        )
    }
}
