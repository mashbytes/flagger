import XCTest
@testable import Flagger

class URLPathFlagURLBuilderTests: XCTestCase {
    
    func testBuildsURLWithCorrectPath() {
        let host = "http://www.google.co.uk"
        let builder = URLPathFlagURLBuilder(baseURL: URL(string: host)!)
        
        guard case .success(let url) = builder.buildURL(forFlag: TestFlags.canFlyToTheMoon, usingContext: StaticContext()) else {
            XCTAssertTrue(false, "Expected success result")
            return
        }
        XCTAssertEqual(url, URL(string: "\(host)/canFlyToTheMoon"))
    }
    
    func testBuildsURLWithContextAwareCorrectPath() {
        let host = "http://www.google.co.uk"
        let builder = URLPathFlagURLBuilder(baseURL: URL(string: host)!)
        
        guard case .success(let url) = builder.buildURL(forFlag: TestFlags.canFlyToTheMoon, usingContext: StaticContext(identifier: "user/123")) else {
            XCTAssertTrue(false, "Expected success result")
            return
        }
        XCTAssertEqual(url, URL(string: "\(host)/user/123/canFlyToTheMoon"))
    }

    
}
