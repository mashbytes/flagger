import Foundation

protocol FlagURLRequestBuilder {
    
    func buildURLRequest<F: Flag>(forFlag flag: F, usingContext context: Context) -> Result<URLRequest, FlagURLRequestBuilderError>
    
}

enum FlagURLRequestBuilderError: Error {
    
    case invalidURL
    case other(Error)
    
}
