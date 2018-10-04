import XCTest
@testable import Flagger

class URLPathFlagURLBuilderTests: XCTestCase {
    
    func testBuildsURLWithCorrectPath() {
        let host = "http://www.google.co.uk"
        let builder = URLPathFlagURLBuilder<TestFlags>(baseURL: URL(string: host)!)
        
        let result = builder.buildURL(forFlag: TestFlags.canFlyToTheMoon)
        guard case .success(let url) = result else {
            XCTAssertTrue(false, "Expected success result")
            return
        }
        XCTAssertEqual(url, URL(string: "\(host)/canFlyToTheMoon"))
    }
    
    
}
