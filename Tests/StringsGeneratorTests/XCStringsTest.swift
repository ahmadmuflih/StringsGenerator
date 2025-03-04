import Testing
@testable import StringsGenerator

struct XCStringsTest {

    @Test func sanitizedName() async throws {
        #expect(XCStrings(filePath: "./Path/To/File.xcstrings").sanitizedName == "File")
        #expect(XCStrings(filePath: "Path/To/File.xcstrings").sanitizedName == "File")
        #expect(XCStrings(filePath: "SomeFile.xcstrings").sanitizedName == "SomeFile")
    }

}
