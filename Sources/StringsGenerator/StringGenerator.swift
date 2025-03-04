import Foundation
import ArgumentParser

@main
struct StringGenerator: ParsableCommand {
    @Option(help: "XCStrings files path")
    var input: [String]

    @Option(help: "The output path")
    var output: String

    func run() throws {
        do {
            let xcStrings = input.map { XCStrings(filePath: $0) }
            let generatedLocalization = LocalizationGenerator
                .generate(from: LocalizationGenerator.Param(
                    fileName: "Strings",
                    items: try xcStrings.map {
                        .init(xcStringName: $0.sanitizedName, data: try getLocalizationData(of: $0))
                    }
                ))
            try FileWriter.write(contents: generatedLocalization.render(), to: output)
        } catch {
            print(error)
            throw error
        }
    }
    
    private func getLocalizationData(of xcstrings: XCStrings) throws -> LocalizationData {
        let content = try FileReader.read(xcstrings.filePath)
        return try XCStringParser.parse(content)
    }
}
