@testable import StringsGenerator
import Testing
import XCTest

struct LocalizationRenderableTest {

    @Test
    func standardLocalization() {
        #expect(   
            LocalizationItemRenderable(
                funcName: "funcName",
                key: "key",
                tableName: "table-name",
                placeholders: []
            ).render() ==
                """
                public static func funcName() -> String {
                \tString(localized: "key", table: "table-name", bundle: bundle, comment: "") 
                }
                """
        )
    }
    
    @Test
    func placeholderLocalization() {
        #expect(
            LocalizationItemRenderable(
                funcName: "funcName",
                key: "key",
                tableName: "table-name",
                placeholders: [.int, .string, .float]
            ).render() ==
                """
                public static func funcName(_ arg1: Int, _ arg2: String, _ arg3: Float) -> String { 
                \tlet format = NSLocalizedString("key", tableName: "table-name", bundle: bundle, comment: "")
                \treturn String(format: format, arguments: [arg1, arg2, arg3])
                }
                """
        )
    }
    
    @Test
    func groupLocalization() {
        let group = LocalizationGroupRenderable(name: "Localazy")
        
        group.addComposable(StubComposable(name: "key1"))
        group.addComposable(StubComposable(name: "key2"))
        
        #expect(
            group.render() ==
                """
                public struct Localazy {
                
                \tfunc key1() -> String {
                \t\t"value-key1"
                \t}
                
                \tfunc key2() -> String {
                \t\t"value-key2"
                \t}
                
                \tprivate init() {}
                
                }
                """
        )
    }
    
    @Test
    func rootLocalization() {
        let root = LocalizationRootRenderable(name: "Localizations")
        
        root.addComposable(StubParent())
        root.addComposable(StubParent())
        
        #expect(
            root.render() ==
                """
                // Generated code. do not remove
                import Foundation
                
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
                
                private let bundle = Bundle.current

                public struct Localizations {
                
                \tThis is parent
                
                \tThis is parent
                
                \tprivate init() {}
                
                }
                """
        )
    }

}

private struct StubParent: LocalizationRenderableParentComposable {
    var children = [any LocalizationRenderableComposable]()
    
    func addComposable(_ composable: any LocalizationRenderableComposable) {}
    
    func render() -> String {
        """
        This is parent
        """
    }
}

private struct StubComposable: LocalizationRenderableComposable {
    let name: String
    func render() -> String {
        """
        func \(name)() -> String {
        \t"value-\(name)"
        }
        """
    }
}
