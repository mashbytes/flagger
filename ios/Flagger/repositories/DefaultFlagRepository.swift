import Foundation

class DefaultFlagRepository<F: Flag, S: FlagStatus>: ReadableFlagRepository {
    typealias FlagType = F
    typealias FlagStatusType = S
    
    private let cache: AnyFlagRepository<F, S>
    private let remote: AnyReadableFlagRepository<F, S>
    
    init<C: FlagRepository, R: ReadableFlagRepository>(cache: C, remote: R) where F == C.FlagType, F == R.FlagType, S == C.FlagStatusType, S == R.FlagStatusType {
        self.cache = AnyFlagRepository(cache)
        self.remote = AnyReadableFlagRepository(remote)
    }
    
    func readStatus(ofFlag flag: F, callback: ReadCallback<S>?) {
        cache.readStatus(ofFlag: flag, callback: callback)
        remote.readStatus(ofFlag: flag) { result in
            if case .success(let status) = result {
                self.cache.writeStatus(status, ofFlag: flag, callback: nil)
            }
            callback?(result)
        }
    }
    
}

