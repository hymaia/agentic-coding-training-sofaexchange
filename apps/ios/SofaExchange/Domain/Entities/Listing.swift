import Foundation

struct Listing {
    let id: String
    let title: String
    let city: City
    let pricePerNightCents: Int
    let sofaType: SofaType
    let hasFreeWifi: Bool
    let createdAt: String
    let updatedAt: String

    var priceDisplay: String {
        String(format: NSLocalizedString("per_night_format", comment: ""), Double(pricePerNightCents) / 100.0)
    }
}
