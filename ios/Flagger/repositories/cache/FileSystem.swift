import Foundation

protocol FileSystem {
    
    func createFile(atURL url: URL) -> Bool
    
    func removeFile(atURL url: URL) -> Bool
    
    func fileExists(atURL url: URL) -> Bool
}
