import XCTest
@testable import Flagger

class StatusCodeFlagURLResponseTransformerTests: XCTestCase {
    
    private let url = URL(string: "http://www.google.co.uk")!
    private let transformer = StatusCodeFlagURLResponseTransformer()
    
    func testReturnsFailureIfStatusCodeIsNotPresent() {
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let result = transformer.transform(data: nil, response: response, error: nil, forFlag: TestFlags.canDrive)
        
        guard case .failure(.unexpectedResponse) = result else {
            XCTAssertTrue(false, "Expected failure result")
            return
        }
    }
    
    func testReturnsFailureIfNotExpectedStatusCode() {
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        let result = transformer.transform(data: nil, response: response, error: nil, forFlag: TestFlags.canDrive)
        
        guard case .failure(.unexpectedResponse) = result else {
            XCTAssertTrue(false, "Expected failure result")
            return
        }
    }
    
    func testReturnsEnabledFor200Response() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let result = transformer.transform(data: nil, response: response, error: nil, forFlag: TestFlags.canDrive)
        
        guard case .success(.enabled) = result else {
            XCTAssertTrue(false, "Expected success result")
            return
        }
    }
    
    func testReturnsDisabledFor404Response() {
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        let result = transformer.transform(data: nil, response: response, error: nil, forFlag: TestFlags.canDrive)
        
        guard case .success(.disabled) = result else {
            XCTAssertTrue(false, "Expected success result")
            return
        }
    }

    
}
