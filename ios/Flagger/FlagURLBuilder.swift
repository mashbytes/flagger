import Foundation

protocol FlagURLBuilder {
    associatedtype FlagType: Flag
    
    func buildURL(forFlag flag: FlagType) -> Result<URL, FlagURLBuilderError>
    
}

enum FlagURLBuilderError: Error {
    
    case buildFailed
    case other(Error)
    
}

struct AnyFlagURLBuilder<TargetFlagType: Flag>: FlagURLBuilder {
    
    private let buildFn: (TargetFlagType) -> Result<URL, FlagURLBuilderError>
    
    init<B: FlagURLBuilder>(_ builder: B) where B.FlagType == TargetFlagType {
        buildFn = builder.buildURL
    }
    
    func buildURL(forFlag flag: TargetFlagType) -> Result<URL, FlagURLBuilderError> {
        return buildFn(flag)
    }
    
}
