import XCTest
@testable import Flagger

class URLPathFlagURLBuilderTests: XCTestCase {
    
    func testBuildsURLWithCorrectPath() {
        let host = "http://www.google.co.uk"
        let builder = URLPathFlagURLBuilder(baseURL: URL(string: host)!)
        
        let result = builder.buildURL(forFlag: TestFlags.canFlyToTheMoon, usingContext: StaticContext())
        guard case .success(let url) = result  else {
            XCTAssertTrue(false, "Expected success result")
            return
        }
        XCTAssertEqual(url, URL(string: "\(host)/canFlyToTheMoon"))
    }
    
    func testBuildsURLWithContextAwareCorrectPath() {
        let host = "http://www.google.co.uk"
        let builder = URLPathFlagURLBuilder(baseURL: URL(string: host)!)
        
        let result = builder.buildURL(forFlag: TestFlags.canFlyToTheMoon, usingContext: StaticContext(identifier: "user/123"))
        guard case .success(let url) = result else {
            XCTAssertTrue(false, "Expected success result")
            return
        }
        XCTAssertEqual(url, URL(string: "\(host)/user/123/canFlyToTheMoon"))
    }

    
}
