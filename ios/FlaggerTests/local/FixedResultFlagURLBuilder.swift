import Foundation
@testable import Flagger

class FixedResultFlagURLBuilder: FlagURLBuilder {
    
    private var results: [String: Result<URL, FlagURLBuilderError>] = [:]
    
    func addResult(_ result: Result<URL, FlagURLBuilderError>, forFlag flag: Flag) {
        results[flag.identifier] = result
    }
    
    func buildURL<F>(forFlag flag: F, usingContext context: Context) -> Result<URL, FlagURLBuilderError> where F : Flag {
        return results[flag.identifier]!
    }
    
}
