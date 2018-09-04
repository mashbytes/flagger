import XCTest
@testable import Flagger

class DefaultFlagURLRequestBuilderTests: XCTestCase {
    
    func testReturnsFailureShouldBuilderFail() {
        let flag = TestFlags.canFlyToTheMoon
        
        let builder = FixedResultFlagURLBuilder()
        builder.addResult(.failure(FlagURLBuilderError.buildFailed), forFlag: flag)
        
        let requestBuilder = DefaultFlagURLRequestBuilder(builder: builder)
        let result = requestBuilder.buildURLRequest(forFlag: flag, usingContext: StaticContext())
        
        guard case .failure = result else {
            XCTAssertTrue(false, "Expected success result")
            return
        }
        
    }
    
    func testReturnsCorrectURLRequestWhenBuilderSucceeds() {
        let flag = TestFlags.canFlyToTheMoon
        let url = urlForFlag(flag)

        let builder = FixedResultFlagURLBuilder()
        builder.addResult(.success(url), forFlag: flag)
        
        let requestBuilder = DefaultFlagURLRequestBuilder(builder: builder)
        let result = requestBuilder.buildURLRequest(forFlag: flag, usingContext: StaticContext())
        
        guard case .success(let request) = result else {
            XCTAssertTrue(false, "Expected success result")
            return
        }

        XCTAssertEqual(request.url, url)
    }
    
    private func urlForFlag(_ flag: Flag) -> URL {
        return URL(string: "http://www.google.co.uk")!.appendingPathComponent("\(type(of: self))").appendingPathComponent(flag.identifier)
    }

}
