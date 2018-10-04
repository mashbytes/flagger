import Foundation

class URLPathFlagURLBuilder<F: Flag & Identifiable>: FlagURLBuilder {
    
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func buildURL(forFlag flag: F) -> Result<URL, FlagURLBuilderError> {
        return .success(baseURL.appendingPathComponent(flag.identifier))
    }
    
}
