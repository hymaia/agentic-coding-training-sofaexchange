import Foundation

enum SofaType: String, Codable, CaseIterable {
    case sofaBed    = "SOFA_BED"
    case simpleSofa = "SIMPLE_SOFA"

    var displayName: String {
        NSLocalizedString("sofa_type_\(rawValue)", comment: "")
    }
}
