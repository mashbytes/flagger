import Foundation

class StatusCodeFlagURLResponseTransformer<S: FlagStatus & HTTPStatusCodeDecodable>: FlagURLResponseTransformer {
    
    func transform(data: Data?, response: URLResponse?, error: Error?) -> Result<S, FlagURLResponseTransformerError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.unexpectedResponse)
        }
        if let error = error {
            return .failure(.other(error))
        }
        let code = httpResponse.statusCode
        let status = S(from: code)
        return .success(status)
    }
    
}
