import Foundation

struct LocalizationGenerator {
    
    typealias FileName = String

    struct Param {
        let fileName: FileName
        let items: [Item]
        
        struct Item {
            let xcStringName: FileName
            let data: LocalizationData
        }
    }
    
    private init() {}
    
    static func generate(from param: Param) -> LocalizationRootRenderable {
        let root = LocalizationRootRenderable(
            name: param.fileName
        )
        
        for item in param.items {
            let parent = LocalizationGroupRenderable(
                name: SwiftIdentifier(name: item.xcStringName).value
            )
            for (key, value) in item.data.strings.sorted(by: { $0.key < $1.key }) {
                value.localizations?[item.data.sourceLanguage]?
                    .toLocalizationComposables(key: key, tableName: item.xcStringName)
                    .forEach(parent.addComposable)
            }
            root.addComposable(parent)
        }
        
        return root
    }
}

private extension Localization {
    func toLocalizationComposables(
        key: String,
        tableName: String
    ) -> [any LocalizationRenderableComposable] {

        var composables = [any LocalizationRenderableComposable]()

        if let stringUnit {
            composables.append(
                LocalizationItemRenderable(
                    funcName: SwiftIdentifier(name: key).value,
                    key: key,
                    tableName: tableName,
                    placeholders: stringUnit.value.getPlaceholders()
                )
            )
        }

        if let variations, let stringUnit = variations.plural?.first?.value.stringUnit {
            composables.append(
                LocalizationItemRenderable(
                    funcName: SwiftIdentifier(name: key).value,
                    key: key,
                    tableName: tableName,
                    placeholders: stringUnit.value.getPlaceholders()
                )
            )
        }

        return composables
    }
}

private extension String {
    func getPlaceholders() -> [Placeholder] {
        // Define a regular expression pattern to match the placeholders
        let pattern = Placeholder.allCases.map(\.regex).joined(separator: "|")
        var placeholders: [Placeholder] = []
        
        // Use NSRegularExpression to find matches in the string
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let matches = regex.matches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
            
            // For each match, map to the corresponding Placeholder case
            for match in matches {
                let matchString = (self as NSString).substring(with: match.range)
                
                if let placeholder = Placeholder(placeholder: matchString) {
                    placeholders.append(placeholder)
                }
            }
        }
        
        return placeholders
    }
}
