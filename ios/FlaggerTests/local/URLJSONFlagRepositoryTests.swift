import XCTest
@testable import Flagger

class URLJSONFlagRepositoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        try? FileManager.default.removeItem(at: temporaryDirectory)
        try? FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true, attributes: nil)

    }
    
    func testShouldReturnSuccessResultWhenWritingOnSucceeds() {
        let flag = TestFlags.canDiveToTheBottomOfTheOcean
        let directory = directoryForFlag(flag)
        
        let builder = FixedResultFlagURLBuilder<TestFlags>()
        builder.addResult(.success(directory), forFlag: flag)
        
        let cache = URLJSONFlagRepository<TestFlags, OnOffFlagStatus>(builder: builder)
        let callbackExpectation = XCTestExpectation(description: "Expected callback with result")
        cache.writeStatus(.on, ofFlag: flag) { result in
            guard case .success(let status) = result else {
                XCTAssertTrue(false, "Expected success result")
                return
            }
            XCTAssertEqual(status, .on)
            callbackExpectation.fulfill()
        }
        
        wait(for: [callbackExpectation], timeout: 1)
    }
    
    func testShouldReturnSuccessResultWhenWritingOffSucceeds() {
        let flag = TestFlags.canDiveToTheBottomOfTheOcean
        let directory = directoryForFlag(flag)
        
        let builder = FixedResultFlagURLBuilder<TestFlags>()
        builder.addResult(.success(directory), forFlag: flag)
        
        let cache = URLJSONFlagRepository<TestFlags, OnOffFlagStatus>(builder: builder)

        let callbackExpectation = XCTestExpectation(description: "Expected callback with result")

        cache.writeStatus(.off, ofFlag: flag) { result in
            guard case .success(let status) = result else {
                XCTAssertTrue(false, "Expected success result")
                return
            }
            XCTAssertEqual(status, .off)
            callbackExpectation.fulfill()
        }
        
        wait(for: [callbackExpectation], timeout: 1)
    }
    
    func testFailureResultIsReturnedWhenBuilderCannotCreateURL() {
        let flag = TestFlags.canDiveToTheBottomOfTheOcean
        
        let builder = FixedResultFlagURLBuilder<TestFlags>()
        builder.addResult(.failure(FlagURLBuilderError.buildFailed), forFlag: flag)

        let cache = URLJSONFlagRepository<TestFlags, OnOffFlagStatus>(builder: builder)
        
        let callbackExpectation = XCTestExpectation(description: "Expected callback with result")
        
        cache.writeStatus(.on, ofFlag: flag) { result in
            guard case .failure = result else {
                XCTAssertTrue(false, "Expected failure result")
                return
            }
            callbackExpectation.fulfill()
        }
        
        wait(for: [callbackExpectation], timeout: 1)
    }
    
    private func directoryForFlag(_ flag: Identifiable) -> URL {
        return temporaryDirectory.appendingPathComponent(flag.identifier)
    }
    
    private var temporaryDirectory: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(type(of: self))")
    }
    
}
