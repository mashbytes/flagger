import Foundation

protocol Flag {
    
}

protocol FlagStatus {
    
}

protocol Identifiable {
    
    var identifier: String { get }
    
}

protocol HTTPStatusCodeDecodable {
    
    init(from code: Int)
    
}

extension Flag {
    
    func getStatus<R: ReadableFlagRepository, S>(usingRepository repository: R, callback: @escaping (Result<S, RepositoryError>) -> ()) where R.FlagType == Self, R.FlagStatusType == S {
        repository.readStatus(ofFlag: self, callback: callback)
    }
    
}
