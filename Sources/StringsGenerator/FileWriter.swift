import Foundation

struct FileWriter {
    
    private struct WriteError: Error {
        let error: any Error
        
        var localizedDescription: String { "Error: Failed writing generated file \(error)" }
    }
    
    private init() {}
    
    static func write(contents: String, to filePath: String) throws {
        do {
            try contents.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            throw WriteError(error: error)
        }
    }
}
