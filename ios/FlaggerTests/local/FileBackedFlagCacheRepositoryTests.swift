import XCTest
@testable import Flagger

class FileBackedFlagCacheRepositoryTests: XCTestCase {
    
    func testShouldCreateFileForEnabledStatus() {
        let flag = TestFlags.canDiveToTheBottomOfTheOcean
        let directory = directoryForFlag(flag)
        let builder = FixedResultFlagURLBuilder()
        builder.addResult(.success(directory), forFlag: flag)
        
        let fileSystem = TestFileSystem()
        
        let cache = FileBackedFlagCacheRepository(builder: builder, fileSystem: fileSystem)
        cache.writeStatus(.enabled, ofFlag: flag)
        
        wait(for: [fileSystem.createExpectation], timeout: 1)
        XCTAssertNotNil(fileSystem.createdURL)
        XCTAssertEqual(fileSystem.createdURL!, directory)
    }
    
    func testShouldDeleteFileForDisabledStatus() {
        let flag = TestFlags.canDiveToTheBottomOfTheOcean
        let directory = directoryForFlag(flag)
        
        let builder = FixedResultFlagURLBuilder()
        builder.addResult(.success(directory), forFlag: flag)
        
        let fileSystem = TestFileSystem()
        
        let cache = FileBackedFlagCacheRepository(builder: builder, fileSystem: fileSystem)
        cache.writeStatus(.disabled, ofFlag: flag)
        
        wait(for: [fileSystem.removeExpectation], timeout: 1)
        XCTAssertNotNil(fileSystem.removedURL)
        XCTAssertEqual(fileSystem.removedURL!, directory)
    }
    
    func testShouldNotInteractWithFileSystemWhenURLBuilderFails() {
        let flag = TestFlags.canDiveToTheBottomOfTheOcean
        
        let builder = FixedResultFlagURLBuilder()
        builder.addResult(.failure(FlagURLBuilderError.buildFailed), forFlag: flag)

        let fileSystem = TestFileSystem()

        let cache = FileBackedFlagCacheRepository(builder: builder, fileSystem: fileSystem)
        cache.writeStatus(.enabled, ofFlag: flag)
        cache.writeStatus(.disabled, ofFlag: flag)
        
        XCTAssertNil(fileSystem.createdURL)
        XCTAssertNil(fileSystem.removedURL)
        XCTAssertNil(fileSystem.existsURL)
    }
    
    func testFailureResultIsReturnedWhenBuilderCannotCreateURL() {
        let flag = TestFlags.canDiveToTheBottomOfTheOcean
        
        let builder = FixedResultFlagURLBuilder()
        builder.addResult(.failure(FlagURLBuilderError.buildFailed), forFlag: flag)

        let callbackExpectation = XCTestExpectation(description: "Callback")
        var callbackResult: Result<FlagStatus, RepositoryError>?

        let cache = FileBackedFlagCacheRepository(builder: builder, fileSystem: TestFileSystem())
        cache.readStatus(ofFlag: flag) { result in
            callbackResult = result
            callbackExpectation.fulfill()
        }

        wait(for: [callbackExpectation], timeout: 1)
        XCTAssertNotNil(callbackResult)

        switch callbackResult! {
        case .failure:
            break
        default:
            XCTAssertFalse(true)
        }
    }
    
    func testStatusIsDisabledWhenDirectoryDoesNotExist() {
        let flag = TestFlags.canFlyToTheMoon
        let directory = directoryForFlag(flag)

        let builder = FixedResultFlagURLBuilder()
        builder.addResult(.success(directory), forFlag: flag)
        
        let fileSystem = TestFileSystem()
        fileSystem.exists = false

        let callbackExpectation = XCTestExpectation(description: "Callback")
        var callbackResult: Result<FlagStatus, RepositoryError>?
        
        let cache = FileBackedFlagCacheRepository(builder: builder, fileSystem: fileSystem)
        cache.readStatus(ofFlag: flag) { result in
            callbackResult = result
            callbackExpectation.fulfill()
        }
        
        wait(for: [callbackExpectation], timeout: 1)
        XCTAssertNotNil(callbackResult)
        
        switch callbackResult! {
        case .success(let status):
            XCTAssertEqual(.disabled, status)
        default:
            XCTAssertFalse(true)
        }
    }
    
    func testStatusIsEnabledWhenDirectoryDoesExist() {
        let flag = TestFlags.canFlyToTheMoon
        let directory = directoryForFlag(flag)
        
        let builder = FixedResultFlagURLBuilder()
        builder.addResult(.success(directory), forFlag: flag)
        
        let fileSystem = TestFileSystem()
        
        let callbackExpectation = XCTestExpectation(description: "Callback")
        var callbackResult: Result<FlagStatus, RepositoryError>?
        
        let cache = FileBackedFlagCacheRepository(builder: builder, fileSystem: fileSystem)
        cache.readStatus(ofFlag: flag) { result in
            callbackResult = result
            callbackExpectation.fulfill()
        }
        
        wait(for: [callbackExpectation], timeout: 1)
        XCTAssertNotNil(callbackResult)
        
        switch callbackResult! {
        case .success(let status):
            XCTAssertEqual(.enabled, status)
        default:
            XCTAssertFalse(true)
        }
    }
    
    private func directoryForFlag(_ flag: Flag) -> URL {
        return URL(string: "/")!.appendingPathComponent("\(type(of: self))").appendingPathComponent(flag.identifier)
    }
    
    
}
