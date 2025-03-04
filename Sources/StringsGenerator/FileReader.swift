struct FileReader {
    
    private struct ReadError: Error {
        let error: any Error
        
        var localizedDescription: String { "Error: Failed reading xcstrings file \(error)" }
    }
    
    private init() {}
    
    static func read(_ filePath: String) throws -> String {
        do {
            return try String(contentsOfFile: filePath, encoding: .utf8)
        } catch {
            print("File read error : \(String(describing: error.localizedDescription))")
            throw ReadError(error: error)
        }
    }
}
