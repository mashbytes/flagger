import XCTest
@testable import Flagger

class StatusCodeFlagURLResponseTransformerTests: XCTestCase {
    
    private let url = URL(string: "http://www.google.co.uk")!
    private let transformer = StatusCodeFlagURLResponseTransformer<OnOffFlagStatus>()
    
    func testReturnsFailureIfStatusCodeIsNotPresent() {
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let result = transformer.transform(data: nil, response: response, error: nil)
        
        guard case .failure(.unexpectedResponse) = result else {
            XCTAssertTrue(false, "Expected failure result")
            return
        }
    }
    
    func testReturnsFailureIfError() {
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        let result = transformer.transform(data: nil, response: response, error: FlagURLResponseTransformerError.unexpectedResponse)
        
        guard case .failure = result else {
            XCTAssertTrue(false, "Expected failure result")
            return
        }
    }
    
    func testReturnsEnabledFor200Response() {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let result = transformer.transform(data: nil, response: response, error: nil)
        
        guard case .success(.on) = result else {
            XCTAssertTrue(false, "Expected success result")
            return
        }
    }
    
    func testReturnsDisabledFor404Response() {
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        let result = transformer.transform(data: nil, response: response, error: nil)
        
        guard case .success(.off) = result else {
            XCTAssertTrue(false, "Expected success result")
            return
        }
    }

    
}

extension OnOffFlagStatus: HTTPStatusCodeDecodable {
    
    public init(from code: Int) {
        switch code {
        case 200: self = .on
        default: self = .off
        }
    }
}
