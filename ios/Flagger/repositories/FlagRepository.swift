import Foundation


protocol FlagRepository: ReadableFlagRepository, WriteableFlagRepository {
    
}

struct AnyFlagRepository<TargetFlagType: Flag, TargetFlagStatusType: FlagStatus>: FlagRepository {
    
    private let writeRepository: AnyWriteableFlagRepository<TargetFlagType,TargetFlagStatusType>
    private let readRepository: AnyReadableFlagRepository<TargetFlagType,TargetFlagStatusType>
    
    init<R: FlagRepository>(_ repository: R) where R.FlagStatusType == TargetFlagStatusType, R.FlagType == TargetFlagType {
        writeRepository = AnyWriteableFlagRepository(repository)
        readRepository = AnyReadableFlagRepository(repository)
    }

    func writeStatus(_ status: TargetFlagStatusType, ofFlag flag: TargetFlagType, callback: WriteCallback<TargetFlagStatusType>?) {
        writeRepository.writeStatus(status, ofFlag: flag, callback: callback)
    }
    
    func readStatus(ofFlag flag: TargetFlagType, callback: ReadCallback<TargetFlagStatusType>?) {
        readRepository.readStatus(ofFlag: flag, callback: callback)
    }

}

public enum Result<S, E: Error> {
    case success(S)
    case failure(E)
}

enum RepositoryError: Error {
    
    case flagNotFound
    case other(Error)

}
