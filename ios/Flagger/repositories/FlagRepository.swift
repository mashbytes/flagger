import Foundation

typealias FlagCallback = (Result<FlagStatus, RepositoryError>) -> ()

protocol FlagRepository {
    
    func readStatus<F: Flag>(ofFlag flag: F, forContext context: Context, callback: @escaping FlagCallback)
    
}

extension FlagRepository {
    
    func readStatus<F: Flag>(ofFlag flag: F, callback: @escaping FlagCallback) {
        return readStatus(ofFlag: flag, forContext: StaticContext(), callback: callback)
    }
    
}

public enum Result<S, E: Error> {
    case success(S)
    case failure(E)
}

enum RepositoryError: Error {
    
    case other(Error)

}
