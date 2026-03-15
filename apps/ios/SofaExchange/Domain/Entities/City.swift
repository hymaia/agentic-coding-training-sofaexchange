import Foundation

enum City: String, Codable, CaseIterable {
    case london    = "LONDON"
    case paris     = "PARIS"
    case milan     = "MILAN"
    case madrid    = "MADRID"
    case lisbon    = "LISBON"
    case berlin    = "BERLIN"
    case dublin    = "DUBLIN"
    case edinburgh = "EDINBURGH"
    case vienna    = "VIENNA"

    var displayName: String {
        NSLocalizedString("city_\(rawValue)", comment: "")
    }
}
