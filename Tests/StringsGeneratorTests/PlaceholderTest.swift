import Testing
@testable import StringsGenerator

struct PlaceholderTest {

    @Test("Valid int", arguments: [
        "%d",
        "%1$d",
        "%2$d",
        "%10$d",
        "%02d",
        "%5$d",
        "%1$02d"
    ])
    func validInt(_ placeholder: String) async throws {
        #expect(Placeholder(placeholder: placeholder) == .int)
    }
    
    @Test("Valid string", arguments: [
        "%@",
        "%1$@",
        "%2$@",
    ])
    func validString(_ placeholder: String) async throws {
        #expect(Placeholder(placeholder: placeholder) == .string)
    }
    
    @Test("Valid float", arguments: [
        "%f",
        "%1$f",
        "%2$f",
        "%10$f",
        "%.2f"
    ])
    func validFloat(_ placeholder: String) async throws {
        #expect(Placeholder(placeholder: placeholder) == .float)
    }
    
    @Test("Invalid symbol", arguments: [
        "%x$d",
        "%1$1@"
    ])
    func invalidSymbol(_ placeholder: String) async throws {
        #expect(Placeholder(placeholder: placeholder) == nil)
    }
}
