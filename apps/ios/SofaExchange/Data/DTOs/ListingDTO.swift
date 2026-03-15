struct ListingDTO: Decodable {
    let id: String
    let title: String
    let city: String          // raw string; mapped to domain enum in mapper
    let pricePerNightCents: Int
    let sofaType: String
    let hasFreeWifi: Bool
    let createdAt: String
    let updatedAt: String

    func toDomain() -> Listing? {
        guard let city     = City(rawValue: city),
              let sofaType = SofaType(rawValue: sofaType) else { return nil }
        return Listing(
            id: id,
            title: title,
            city: city,
            pricePerNightCents: pricePerNightCents,
            sofaType: sofaType,
            hasFreeWifi: hasFreeWifi,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
