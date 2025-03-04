import Foundation

struct XCStringParser {
    private enum Error: Swift.Error {
        case conversionError
        case decodeError(any Swift.Error)
        var localizedDescription: String {
            return switch self {
            case .conversionError: "Error: Unable to convert JSON string to Data"
            case .decodeError(let error): "Error: Unable to parse JSON \(error)"
            }
        }
    }
    private init() {}
    
    static func parse(_ xcstringJson: String) throws -> LocalizationData {
        if let jsonData = xcstringJson.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(LocalizationData.self, from: jsonData)
            } catch {
                throw Error.decodeError(error)
            }
        } else {
            throw Error.conversionError
        }
    }
}
