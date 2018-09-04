import Foundation

class DefaultFlagURLRequestBuilder: FlagURLRequestBuilder {
    
    private let builder: FlagURLBuilder
    
    init(builder: FlagURLBuilder) {
        self.builder = builder
    }
    
    func buildURLRequest<F>(forFlag flag: F, usingContext context: Context) -> Result<URLRequest, FlagURLRequestBuilderError> where F : Flag {
        let result = builder.buildURL(forFlag: flag, usingContext: context)
        
        switch result {
        case .success(let url): return .success(URLRequest(url: url))
        case .failure(let error): return .failure(FlagURLRequestBuilderError.other(error))
        }
    }
    
}
