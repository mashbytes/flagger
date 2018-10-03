import Foundation

class DefaultFlagURLRequestBuilder<F: Flag>: FlagURLRequestBuilder {
    
    private let builder: AnyFlagURLBuilder<F>
    
    init<B: FlagURLBuilder>(builder: B) where B.FlagType == F {
        self.builder = AnyFlagURLBuilder(builder)
    }
    
    func buildURLRequest(forFlag flag: F) -> Result<URLRequest, FlagURLRequestBuilderError> {
        let result = builder.buildURL(forFlag: flag)
        
        switch result {
        case .success(let url): return .success(URLRequest(url: url))
        case .failure(let error): return .failure(FlagURLRequestBuilderError.other(error))
        }
    }
    
}
