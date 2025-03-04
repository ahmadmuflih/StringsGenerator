import Testing
@testable import StringsGenerator

struct LocalizationGeneratorTest {
    @Test func generate() {
        let data = LocalizationData(
            sourceLanguage: "en",
            strings: [
                "simple string": LocalizedString(
                    localizations: [
                        "en": Localization(
                            stringUnit: StringUnit(
                                value: "Simple String"
                            ),
                            variations: nil
                        )
                    ]
                ),
                "empty_string": LocalizedString(
                    localizations: nil
                )
            ]
        )
        
        let data2 = LocalizationData(
            sourceLanguage: "en",
            strings: [
                "placeholder_string": LocalizedString(
                    localizations: [
                        "en": Localization(
                            stringUnit: StringUnit(
                                value: "My name is %@, i was born in %d"
                            ),
                            variations: nil
                        )
                    ]
                ),
                "plural_string": LocalizedString(
                    localizations: [
                        "en": Localization(
                            stringUnit: nil,
                            variations: Variations(
                                plural: [
                                    "one": Variations.Localization(
                                        stringUnit: StringUnit(value: "%d day")
                                    ),
                                    "other": Variations.Localization(
                                        stringUnit: StringUnit(value: "%d days")
                                    )
                                ]
                            )
                        )
                    ]
                )
            ]
        )
        
        let result = LocalizationGenerator.generate(from: .init(
            fileName: "Localizations",
            items: [
                .init(xcStringName: "Strings1", data: data),
                .init(xcStringName: "Strings2", data: data2)
            ]
        ))
        
        #expect(result.children.count == 2)

        assert(
            parent: result.children[0],
            withName: "strings1",
            children: [
                LocalizationItemRenderable(
                    funcName: "simpleString",
                    key: "simple string",
                    tableName: "Strings1",
                    placeholders: []
                )
            ]
        )
        
        assert(
            parent: result.children[1],
            withName: "strings2",
            children: [
                LocalizationItemRenderable(
                    funcName: "placeholder_string",
                    key: "placeholder_string",
                    tableName: "Strings2",
                    placeholders: [.string, .int]
                ),
                LocalizationItemRenderable(
                    funcName: "plural_string",
                    key: "plural_string",
                    tableName: "Strings2",
                    placeholders: [.int]
                )
            ]
        )
    }
    
    @Test func generateMultipleItem() {
        let data = LocalizationData(
            sourceLanguage: "en",
            strings: [
                "minutes": LocalizedString(
                    localizations: [
                        "en": Localization(
                            stringUnit: StringUnit(
                                value: "Minutes"
                            ),
                            variations: Variations(
                                plural: [
                                    "one": Variations.Localization(
                                        stringUnit: StringUnit(value: "%d Minute")
                                    ),
                                    "other": Variations.Localization(
                                        stringUnit: StringUnit(value: "%d Minutes")
                                    )
                                ]
                            )
                        )
                    ]
                )
            ]
        )
        
        let result = LocalizationGenerator.generate(from: .init(
            fileName: "Localizations",
            items: [
                .init(xcStringName: "Strings", data: data)
            ]
        ))
        
        #expect(result.children.count == 1)

        assert(
            parent: result.children[0],
            withName: "strings",
            children: [
                LocalizationItemRenderable(
                    funcName: "minutes",
                    key: "minutes",
                    tableName: "Strings",
                    placeholders: []
                ),
                LocalizationItemRenderable(
                    funcName: "minutes",
                    key: "minutes",
                    tableName: "Strings",
                    placeholders: [.int]
                )
            ]
        )
    }
    
    private func assert(
        parent: LocalizationRenderableParentComposable,
        withName name: String,
        children: [LocalizationItemRenderable]
    ) {
        #expect((parent as? LocalizationGroupRenderable)?.name == name)
        #expect(parent.children as? [LocalizationItemRenderable] == children)
    }
}
