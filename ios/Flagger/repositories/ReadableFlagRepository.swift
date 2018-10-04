import Foundation

protocol ReadableFlagRepository {
    associatedtype FlagType: Flag
    associatedtype FlagStatusType: FlagStatus
    
    typealias ReadCallback<S> = (Result<S, RepositoryError>) -> ()

    func readStatus(ofFlag flag: FlagType, callback: ReadCallback<FlagStatusType>?)
    
}

struct AnyReadableFlagRepository<TargetFlagType: Flag, TargetFlagStatusType: FlagStatus>: ReadableFlagRepository {
    
    private let readFn: (TargetFlagType, ReadCallback<TargetFlagStatusType>?) -> ()
    
    init<R: ReadableFlagRepository>(_ repository: R) where R.FlagStatusType == TargetFlagStatusType, R.FlagType == TargetFlagType {
        readFn = repository.readStatus
    }
    
    func readStatus(ofFlag flag: TargetFlagType, callback: ReadCallback<TargetFlagStatusType>?) {
        readFn(flag, callback)
    }
    
}
