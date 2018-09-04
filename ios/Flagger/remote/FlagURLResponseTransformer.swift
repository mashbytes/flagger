import Foundation

protocol FlagURLResponseTransformer {
    
    func transform<F: Flag>(data: Data?, response: URLResponse?, error: Error?, forFlag flag: F) -> Result<FlagStatus, FlagURLResponseTransformerError>
    
}

enum FlagURLResponseTransformerError: Error {
    
    case transformationFailed
    case unexpectedResponse
    case other(Error)
    
}
