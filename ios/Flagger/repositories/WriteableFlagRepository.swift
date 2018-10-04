import Foundation

protocol WriteableFlagRepository {
    associatedtype FlagType: Flag
    associatedtype FlagStatusType: FlagStatus
    
    typealias WriteCallback<S> = (Result<S, RepositoryError>) -> ()

    func writeStatus(_ status: FlagStatusType, ofFlag flag: FlagType, callback: WriteCallback<FlagStatusType>?)
    
}

struct AnyWriteableFlagRepository<TargetFlagType: Flag, TargetFlagStatusType: FlagStatus>: WriteableFlagRepository {
    
    let writeFn: (TargetFlagStatusType, TargetFlagType, WriteCallback<TargetFlagStatusType>?) -> ()
    
    init<R: WriteableFlagRepository>(_ repository: R) where R.FlagStatusType == TargetFlagStatusType, R.FlagType == TargetFlagType {
        writeFn = repository.writeStatus
    }
    
    func writeStatus(_ status: TargetFlagStatusType, ofFlag flag: TargetFlagType, callback: WriteCallback<TargetFlagStatusType>?) {
        writeFn(status, flag, callback)
    }

}
