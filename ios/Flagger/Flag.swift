import Foundation

protocol Flag {
    
    var identifier: String { get }
    
    func getStatus(usingRepository repository: FlagRepository, inContext context: Context, callback: @escaping FlagCallback)
    
}

extension Flag {
    
    func getStatus(usingRepository repository: FlagRepository = DefaultFlagRepository(), inContext context: Context = StaticContext(), callback: @escaping FlagCallback) {
        repository.readStatus(ofFlag: self, forContext: context, callback: callback)
    }
}

enum FlagStatus {
    case enabled
    case disabled
}
