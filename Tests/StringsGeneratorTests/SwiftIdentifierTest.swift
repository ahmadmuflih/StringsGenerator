import Testing
@testable import StringsGenerator

struct SwiftIdentifierTest {

    @Test func values() throws {
        let swiftNameData = [
            "easy": "easy",
            "easyAndSimple": "easyAndSimple",
            "easy with some spaces": "easyWithSomeSpaces",
            "(looks) easy": "looksEasy",
            "looks-easy": "looksEasy",
            "looks+like^some-kind*of%easy": "looksLikeSomeKindOfEasy",
            "(looks) easy, but it's not really NeXT that easy!": "looksEasyButItSNotReallyNeXTThatEasy",
            "easy 123 and done...": "easy123AndDone",
            "123 easy!": "easy",
            "123 456easy": "easy",
            "123 😄": "😄",
            "🇳🇱": "🇳🇱",
            "🌂MakeItRain!": "🌂MakeItRain",
            "PRFXMyClass": "prfxMyClass",
            "NSSomeThing": "nsSomeThing",
            "MyClass": "myClass",
            "PRFX_MyClass": "prfx_MyClass",
            "PRFX-myClass": "prfxMyClass",
            "123NSSomeThing": "nsSomeThing",
            "PR123FXMyClass": "pr123FXMyClass",
            "title.subtitle": "titleSubtitle"
        ]
        
        swiftNameData.forEach {
            let sanitizedResult = SwiftIdentifier(name: $0.0, lowercaseStartingCharacters: true)
                .value
            
            #expect(sanitizedResult == $0.value)
        }
    }

}
