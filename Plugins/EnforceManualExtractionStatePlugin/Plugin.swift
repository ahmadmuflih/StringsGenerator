import PackagePlugin

@main
struct EnforceManualExtractionStatePlugin: CommandPlugin {
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        for target in context.package.targets {
            guard let target = target as? SourceModuleTarget, target.kind != .test else {
                continue
            }

            for file in target.sourceFiles(withSuffix: ".xcstrings") {
                try XCStringsUpdater(filePath: file.path.string).update()
            }
        } 
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension EnforceManualExtractionStatePlugin: XcodeCommandPlugin {
    func performCommand(
        context: XcodeProjectPlugin.XcodePluginContext,
        arguments: [String]
    ) throws {
        let target = context.xcodeProject.targets.first!
        let inputs = target.inputFiles.map { $0.path }.filter { $0.extension == "xcstrings" }
        
        for file in inputs {
            try XCStringsUpdater(filePath: file.string).update()
        }
    }
}

#endif

private struct XCStringsUpdater {
    
    let filePath: String
    
    func update() throws {
        let fileContent = try read()
        let updatedContent = fileContent.replacingOccurrences(
            of: "\"extractionState\" : \"stale\"",
            with: "\"extractionState\" : \"manual\""
        )
        try write(contents: updatedContent)
    }
    
    private func read() throws -> String {
        try String(contentsOfFile: filePath, encoding: .utf8)
    }

    private func write(contents: String) throws {
        try contents.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
}

