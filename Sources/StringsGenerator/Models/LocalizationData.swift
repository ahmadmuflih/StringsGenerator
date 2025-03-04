import Foundation

typealias Key = String
typealias Value = String
typealias LangID = String

struct LocalizationData: Codable, Equatable {
    let sourceLanguage: String
    let strings: [Key: LocalizedString]
}

struct LocalizedString: Codable, Equatable {
    let localizations: [LangID: Localization]?
}

struct Localization: Codable, Equatable {
    let stringUnit: StringUnit?
    let variations: Variations? 
}

struct StringUnit: Codable, Equatable {
    let value: String
}

struct Variations: Codable, Equatable {
    let plural: [String: Localization]?
    
    struct Localization: Codable, Equatable {
        let stringUnit: StringUnit?
    }
}
