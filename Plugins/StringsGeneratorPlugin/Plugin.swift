import PackagePlugin
import XcodeProjectPlugin
import Foundation

@main
struct StringsGeneratorPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: any Target) async throws -> [Command] {
        guard let target = target as? SourceModuleTarget else { return [] }
        
        let inputs = target.sourceFiles.map { $0.path }.filter { $0.extension == "xcstrings" }
        let output = context.pluginWorkDirectory
            .appending(subpath: "Strings+Generated.swift")
        
        guard !inputs.isEmpty else { return [] }
        
        let inputArguments = inputs.flatMap { ["--input", $0.string ] }
        let outputArguments = ["--output", output.string]

        return [
            .buildCommand(
                displayName: "Generating strong typed strings",
                executable: try context
                    .tool(named: "StringsGenerator").path,
                arguments: inputArguments + outputArguments,
                outputFiles: [output]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension StringsGeneratorPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
        let inputs = context.xcodeProject.filePaths.filter { $0.extension == "xcstrings" }
        let output = context.pluginWorkDirectory
            .appending(subpath: target.displayName)
            .appending(subpath: "Strings+Generated.swift")
        
        guard !inputs.isEmpty else { return [] }
        
        let inputArguments = inputs.flatMap { ["--input", $0.string ] }
        let outputArguments = ["--output", output.string]
        
        return [
            .buildCommand(
                displayName: "Generating strong typed strings",
                executable: try context
                    .tool(named: "StringsGenerator").path,
                arguments: inputArguments + outputArguments,
                outputFiles: [output]
            )
        ]
    }
}

#endif

