import XCTest
@testable import Flagger

class FileBackedFlagCacheRepositoryTests: XCTestCase {
    
    func testShouldReturnSuccessResultWhenWritingOnSucceeds() {
        let flag = TestFlags.canDiveToTheBottomOfTheOcean
        let directory = directoryForFlag(flag)
        let builder = FixedResultFlagURLBuilder<TestFlags>()
        builder.addResult(.success(directory), forFlag: flag)
        
        let cache = URLJSONFlagRepository<TestFlags, OnOffFlagStatus>(builder: builder)
        let callbackExpectation = XCTestExpectation(description: "Expected callback with result")
        cache.writeStatus(.on, ofFlag: flag) { result in
            callbackExpectation.fulfill()
            guard case .success(let status) = result else {
                XCTAssertTrue(false, "Expected success result")
                return
            }
            XCTAssertEqual(status, .on)
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
            callbackExpectation.fulfill()
            guard case .success(let status) = result else {
                XCTAssertTrue(false, "Expected success result")
                return
            }
            XCTAssertEqual(status, .off)
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
            callbackExpectation.fulfill()
            guard case .failure = result else {
                XCTAssertTrue(false, "Expected failure result")
                return
            }
        }
        
        wait(for: [callbackExpectation], timeout: 1)
    }
    
    private func directoryForFlag(_ flag: Identifiable) -> URL {
        return URL(string: "/")!.appendingPathComponent("\(type(of: self))").appendingPathComponent(flag.identifier)
    }
    
    
}
