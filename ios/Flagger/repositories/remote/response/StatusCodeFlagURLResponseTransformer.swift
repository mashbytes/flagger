import Foundation

class StatusCodeFlagURLResponseTransformer: FlagURLResponseTransformer {
    
    func transform<F>(data: Data?, response: URLResponse?, error: Error?, forFlag flag: F) -> Result<FlagStatus, FlagURLResponseTransformerError> where F : Flag {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.unexpectedResponse)
        }
        switch httpResponse.statusCode {
        case 200: return .success(.enabled)
        case 404: return .success(.disabled)
        default: return .failure(.unexpectedResponse)
        }
    }
    
}
