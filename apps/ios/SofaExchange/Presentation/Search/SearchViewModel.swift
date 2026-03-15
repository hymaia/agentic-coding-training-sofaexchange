import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    var selectedCities: [City]      = []
    var minPriceCents: Int?          = nil
    var maxPriceCents: Int?          = nil
    var hasFreeWifi: Bool?           = nil
    var selectedSofaType: SofaType?  = nil

    func buildQuery() -> SearchQuery {
        SearchQuery(
            cities:        selectedCities,
            minPriceCents: minPriceCents,
            maxPriceCents: maxPriceCents,
            hasFreeWifi:   hasFreeWifi,
            sofaType:      selectedSofaType
        )
    }
}
