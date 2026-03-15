import XCTest
@testable import SofaExchange

final class ListingDTOTests: XCTestCase {

    // MARK: - Helpers

    private func makeDTO(
        id: String = "abc-123",
        title: String = "Great Sofa",
        city: String = "LONDON",
        pricePerNightCents: Int = 3500,
        sofaType: String = "SOFA_BED",
        hasFreeWifi: Bool = true,
        createdAt: String = "2024-01-01T00:00:00Z",
        updatedAt: String = "2024-01-02T00:00:00Z"
    ) -> ListingDTO {
        ListingDTO(
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

    // MARK: - Tests

    func test_toDomain_withValidData_returnsListing() {
        // Arrange
        let dto = makeDTO(city: "PARIS", sofaType: "SIMPLE_SOFA", hasFreeWifi: false)

        // Act
        let listing = dto.toDomain()

        // Assert
        XCTAssertNotNil(listing)
        XCTAssertEqual(listing?.id, "abc-123")
        XCTAssertEqual(listing?.title, "Great Sofa")
        XCTAssertEqual(listing?.city, .paris)
        XCTAssertEqual(listing?.pricePerNightCents, 3500)
        XCTAssertEqual(listing?.sofaType, .simpleSofa)
        XCTAssertEqual(listing?.hasFreeWifi, false)
        XCTAssertEqual(listing?.createdAt, "2024-01-01T00:00:00Z")
        XCTAssertEqual(listing?.updatedAt, "2024-01-02T00:00:00Z")
    }

    func test_toDomain_withAllCities_returnsNonNil() {
        // Verify every known city maps correctly
        let cityCases: [(String, City)] = [
            ("LONDON", .london), ("PARIS", .paris), ("MILAN", .milan),
            ("MADRID", .madrid), ("LISBON", .lisbon), ("BERLIN", .berlin),
            ("DUBLIN", .dublin), ("EDINBURGH", .edinburgh), ("VIENNA", .vienna),
        ]
        for (raw, expected) in cityCases {
            let dto = makeDTO(city: raw)
            XCTAssertEqual(dto.toDomain()?.city, expected, "Failed for city \(raw)")
        }
    }

    func test_toDomain_withUnknownCity_returnsNil() {
        // Arrange
        let dto = makeDTO(city: "ATLANTIS")

        // Act
        let listing = dto.toDomain()

        // Assert
        XCTAssertNil(listing, "Expected nil when city enum is unknown")
    }

    func test_toDomain_withUnknownSofaType_returnsNil() {
        // Arrange
        let dto = makeDTO(sofaType: "HAMMOCK")

        // Act
        let listing = dto.toDomain()

        // Assert
        XCTAssertNil(listing, "Expected nil when sofaType enum is unknown")
    }

    func test_toDomain_withBothUnknownCityAndSofaType_returnsNil() {
        // Arrange
        let dto = makeDTO(city: "NOWHERE", sofaType: "HAMMOCK")

        // Act
        let listing = dto.toDomain()

        // Assert
        XCTAssertNil(listing)
    }

    func test_priceDisplay_formatsCorrectly() {
        // Arrange
        let dto = makeDTO(pricePerNightCents: 3550)

        // Act
        let listing = dto.toDomain()

        // Assert
        XCTAssertEqual(listing?.priceDisplay, "€35.50 / night")
    }
}
