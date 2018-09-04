import Foundation
import XCTest

@testable import Flagger

class TestFileSystem: FileSystem {
    
    let createExpectation = XCTestExpectation(description: "createFile")
    let removeExpectation = XCTestExpectation(description: "removeFile")
    let existsExpectation = XCTestExpectation(description: "fileExists")
    
    var created: Bool = true
    var createdURL: URL?
    var removed: Bool = true
    var removedURL: URL?
    var exists: Bool = true
    var existsURL: URL?
    
    func createFile(atURL url: URL) -> Bool {
        createdURL = url
        createExpectation.fulfill()
        return created
    }
    
    func removeFile(atURL url: URL) -> Bool {
        removedURL = url
        removeExpectation.fulfill()
        return removed
    }
    
    func fileExists(atURL url: URL) -> Bool {
        existsURL = url
        existsExpectation.fulfill()
        return exists
    }
    
    
}
