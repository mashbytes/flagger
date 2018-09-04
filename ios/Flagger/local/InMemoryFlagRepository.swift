import Foundation

class InMemoryFlagRepository: WriteableFlagRepository {
    
    private var flags = Set<String>()
    
    func readStatus<F: Flag>(ofFlag flag: F, forContext context: Context, callback: @escaping FlagCallback) {
        let key =  compositeIdentifier(ofFlag: flag, forContext: context)
        if flags.contains(key) {
            callback(.success(.enabled))
            return
        }
        callback(.success(.disabled))
    }
    
    func writeStatus<F: Flag>(_ status: FlagStatus, ofFlag flag: F, forContext context: Context) {
        let key =  compositeIdentifier(ofFlag: flag, forContext: context)
        flags.insert(key)
    }
    
    private func compositeIdentifier(ofFlag flag: Flag, forContext context: Context) -> String {
        return "\(context.identifier)-\(flag.identifier)"
    }
    
}

