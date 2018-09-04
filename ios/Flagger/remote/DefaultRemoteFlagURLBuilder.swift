import Foundation

class DefaultRemoteFlagURLBuilder: FlagURLBuilder {
    
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func buildURL<F>(forFlag flag: F, usingContext context: Context) -> Result<URL, FlagURLBuilderError> where F : Flag {
        return .success(baseURL.appendingPathComponent(context.identifier).appendingPathComponent(flag.identifier))
    }
    
    
    
}
