import Foundation

class FileManagerFileSystem: FileSystem {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func createFile(atURL url: URL) -> Bool {
        return fileManager.createFile(atPath: url.absoluteString, contents: nil, attributes: nil)
    }
    
    func removeFile(atURL url: URL) -> Bool {
        try? fileManager.removeItem(atPath: url.absoluteString)
        return !fileExists(atURL: url)
    }
    
    func fileExists(atURL url: URL) -> Bool {
        return fileManager.fileExists(atPath: url.absoluteString)
    }
    
    
    
}
