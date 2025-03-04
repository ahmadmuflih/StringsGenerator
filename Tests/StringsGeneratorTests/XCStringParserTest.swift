import Testing
@testable import StringsGenerator

struct XCStringParserTest {

    @Test("Test Parse Failed", arguments: ["", "invalid json"])
    func parseFailed(_ input: String) {
        #expect(throws: (any Error).self) {
            try XCStringParser.parse(input)
        }
    }
    
    @Test
    func parseSuccess() throws {
        let result = try XCStringParser.parse(example)
        #expect(
            result ==
            LocalizationData(
                sourceLanguage: "en",
                strings: [
                    "simple_string": LocalizedString(
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
                    ),
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
        )
    }
}

private let example = """
{
  "sourceLanguage" : "en",
  "strings" : {
    "empty_string" : {
      "extractionState" : "manual"
    },
    "placeholder_string" : {
      "comment" : "String Comment",
      "extractionState" : "manual",
      "localizations" : {
        "en" : {
          "stringUnit" : {
            "state" : "translated",
            "value" : "My name is %@, i was born in %d"
          }
        }
      }
    },
    "plural_string" : {
      "extractionState" : "manual",
      "localizations" : {
        "en" : {
          "variations" : {
            "plural" : {
              "one" : {
                "stringUnit" : {
                  "state" : "translated",
                  "value" : "%d day"
                }
              },
              "other" : {
                "stringUnit" : {
                  "state" : "translated",
                  "value" : "%d days"
                }
              }
            }
          }
        }
      }
    },
    "simple_string" : {
      "extractionState" : "manual",
      "localizations" : {
        "en" : {
          "stringUnit" : {
            "state" : "translated",
            "value" : "Simple String"
          }
        }
      }
    }
  },
  "version" : "1.0"
}

"""
