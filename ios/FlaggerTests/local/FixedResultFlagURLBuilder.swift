import Foundation
@testable import Flagger

class FixedResultFlagURLBuilder<F: Flag & Identifiable>: FlagURLBuilder {
    
    private var results: [String: Result<URL, FlagURLBuilderError>] = [:]
    
    func addResult(_ result: Result<URL, FlagURLBuilderError>, forFlag flag: F) {
        results[flag.identifier] = result
    }
    
    func buildURL(forFlag flag: F) -> Result<URL, FlagURLBuilderError> {
        return results[flag.identifier]!
    }
    
}
