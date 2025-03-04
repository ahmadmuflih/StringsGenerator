import Foundation

protocol LocalizationRenderable {
    func render() -> String
}

protocol LocalizationRenderableComposable: LocalizationRenderable {}

protocol LocalizationRenderableParentComposable: LocalizationRenderableComposable {
    var children: [any LocalizationRenderableComposable] { get }
    func addComposable(_ composable: LocalizationRenderableComposable)
}

final class LocalizationRootRenderable: LocalizationRenderable {
    
    let name: String
    
    private(set) var children = [any LocalizationRenderableParentComposable]()
    
    init(name: String) {
        self.name = name
    }
    
    func addComposable(_ parentComposable: any LocalizationRenderableParentComposable) {
        children.append(parentComposable)
    }
    
    func render() -> String {
        """
        // Generated code. do not remove
        import Foundation
        
        \(renderBundlePath())
        
        private let bundle = Bundle.current
        
        public struct \(name) {

        \(children.map { LocalizationTabRenderable(item: $0).render() }.joined(separator: "\n\n"))
        
        \tprivate init() {}
        
        }
        """
    }
    
    private func renderBundlePath() -> String {
        """
        extension Bundle {
            static let current: Bundle = {
            #if DEBUG
            if let testBundlePath = ProcessInfo.processInfo.environment["XCTestBundlePath"],
                let resourceBundle = Bundle(path: testBundlePath + "/../StringsKit_StringsKit.bundle") {
                return resourceBundle
            }
            #endif
            return Bundle.module
            }()
        }
        """
    }
}

final class LocalizationGroupRenderable: LocalizationRenderableParentComposable {
    let name: String
    
    private(set) var children = [any LocalizationRenderableComposable]()
    
    init(name: String) {
        self.name = name
    }
    
    func addComposable(_ composable: any LocalizationRenderableComposable) {
        children.append(composable)
    }
    
    func render() -> String {
        """
        public struct \(name) {

        \(children.map { LocalizationTabRenderable(item: $0).render() }.joined(separator: "\n\n"))
        
        \tprivate init() {}
        
        }
        """
    }
}

struct LocalizationItemRenderable: LocalizationRenderableComposable, Equatable {
    let funcName: String
    let key: String
    let tableName: String
    let placeholders: [Placeholder]
    
    func render() -> String {
        return if placeholders.isEmpty {
            """
            public static func \(funcName)() -> String {
            \tString(localized: "\(key)", table: "\(tableName)", bundle: bundle, comment: "") 
            }
            """
        } else {
            """
            public static func \(funcName)(\(placeholders.funcParameters())) -> String { 
            \tlet format = NSLocalizedString("\(key)", tableName: "\(tableName)", bundle: bundle, comment: "")
            \treturn String(format: format, arguments: \(placeholders.parameterNames()))
            }
            """
        }
    }
}

struct LocalizationTabRenderable: LocalizationRenderableComposable {
    let item: any LocalizationRenderableComposable
    
    func render() -> String {
        item.render()
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { "\t\($0)" }
            .joined(separator: "\n")
    }
}

private struct RegexValidator {
    let regex: String
    
    func validate(_ string: String) -> Bool {
        guard let regularExpression = try? NSRegularExpression(pattern: regex) else { return false }
        let range = NSRange(location: 0, length: string.utf16.count)
        return regularExpression.firstMatch(in: string, options: [], range: range) != nil
    }
}

enum Placeholder: CaseIterable {
    case string
    case int
    case float
    
    var regex: String {
        switch self {
        case .string: "%(\\d*\\$)?@"
        case .int: "%\\d*\\$?\\d*d"
        case .float: "%(\\d*\\$)?(\\.\\d+)?f"
        }
    }
    
    var type: CVarArg.Type {
        switch self {
        case .string: return String.self
        case .int: return Int.self
        case .float: return Float.self
        }
    }
    
    init?(placeholder: String) {
        if RegexValidator(regex: Placeholder.string.regex).validate(placeholder) {
            self = .string
        } else if RegexValidator(regex: Placeholder.int.regex).validate(placeholder) {
            self = .int
        } else if RegexValidator(regex: Placeholder.float.regex).validate(placeholder) {
            self = .float
        } else {
            return nil
        }
    }
}

extension Array where Element == Placeholder {
    func funcParameters() -> String {
        self.enumerated()
            .map { "_ arg\($0.offset + 1): \($0.element.type)" }
            .joined(separator: ", ")
    }
    
    func parameterNames() -> String {
        (1...self.count)
            .map { "arg\($0)" }
            .joined(separator: ", ")
            .wrapped(in: "[", and: "]")
    }
}

private extension String {
    func wrapped(in prefix: String, and suffix: String) -> String {
        return "\(prefix)\(self)\(suffix)"
    }
}
