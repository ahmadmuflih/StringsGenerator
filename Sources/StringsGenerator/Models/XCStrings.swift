import Foundation

struct XCStrings: Hashable {
    let filePath: String
    
    var sanitizedName: String {
        ((filePath as NSString).lastPathComponent as NSString).deletingPathExtension
    }
}
