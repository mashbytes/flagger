import Foundation

class DefaultFlagRepository: FlagRepository {
    private let cache: WriteableFlagRepository
    private let remote: FlagRepository
    
    init(cache: WriteableFlagRepository = FileBackedFlagCacheRepository(), remote: FlagRepository = RemoteFlagRepository()) {
        self.cache = cache
        self.remote = remote
    }
    
    func readStatus<F: Flag>(ofFlag flag: F, forContext context: Context, callback: @escaping FlagCallback) {
        cache.readStatus(ofFlag: flag, forContext: context, callback: callback)
        remote.readStatus(ofFlag: flag, forContext: context) { result in
            if case .success(let status) = result {
                self.cache.writeStatus(status, ofFlag: flag, forContext: context)
            }
            callback(result)
        }
    }
    
}
