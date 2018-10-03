import Foundation

protocol FlagURLRequestBuilder {
    associatedtype FlagType: Flag
    
    func buildURLRequest(forFlag flag: FlagType) -> Result<URLRequest, FlagURLRequestBuilderError>
    
}

enum FlagURLRequestBuilderError: Error {
    
    case invalidURL
    case other(Error)
    
}

struct AnyFlagURLRequestBuilder<TargetFlagType: Flag>: FlagURLRequestBuilder {
    
    private let buildFn: (TargetFlagType) -> Result<URLRequest, FlagURLRequestBuilderError>
    
    init<B: FlagURLRequestBuilder>(_ builder: B) where B.FlagType == TargetFlagType {
        buildFn = builder.buildURLRequest
    }
    
    func buildURLRequest(forFlag flag: TargetFlagType) -> Result<URLRequest, FlagURLRequestBuilderError> {
        return buildFn(flag)
    }
}
