import Foundation

protocol FlagURLBuilder {
    
    func buildURL<F: Flag>(forFlag flag: F, usingContext context: Context) -> Result<URL, FlagURLBuilderError>
    
}

enum FlagURLBuilderError: Error {
    
    case buildFailed
    case other(Error)
    
}

