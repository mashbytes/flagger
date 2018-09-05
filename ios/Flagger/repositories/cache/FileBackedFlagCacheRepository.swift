import Foundation

class FileBackedFlagCacheRepository: WriteableFlagRepository {
    
    private let builder: FlagURLBuilder
    private let fileSystem: FileSystem
    private let queue: DispatchQueue
    
    init(builder: FlagURLBuilder = DefaultFlagFileURLBuilder(), fileSystem: FileSystem = FileManagerFileSystem(), queue: DispatchQueue = DispatchQueue.global(qos: .background)) {
        self.builder = builder
        self.fileSystem = fileSystem
        self.queue = queue
    }
    
    func writeStatus<F>(_ status: FlagStatus, ofFlag flag: F, forContext context: Context) where F : Flag {
        queue.async {
            let result = self.builder.buildURL(forFlag: flag, usingContext: context)
            
            switch result {
            case .success(let url):
                switch status {
                case .enabled:
                    // TODO handle response
                    _ = self.fileSystem.createFile(atURL: url)
                case .disabled:
                    _ = self.fileSystem.removeFile(atURL: url)
                }
            case .failure(_):
                break
            }
            
        }
    }
    
    func readStatus<F: Flag>(ofFlag flag: F, forContext context: Context, callback: @escaping FlagCallback) {
        queue.async {
            let result = self.builder.buildURL(forFlag: flag, usingContext: context)
            switch result {
            case .success(let url):
                if self.fileSystem.fileExists(atURL: url) {
                    callback(.success(.enabled))
                    return
                }
                callback(.success(.disabled))
            case .failure(let error):
                callback(.failure(RepositoryError.other(error)))
                
            }
        }
    }
    
}


class DefaultFlagFileURLBuilder: FlagURLBuilder {
    
    private let directory: URL?
    
    init(searchPathDirectory: FileManager.SearchPathDirectory = .cachesDirectory, searchPathDomainMask: FileManager.SearchPathDomainMask = .userDomainMask, manager: FileManager = FileManager.default) {
        directory = manager.urls(for: searchPathDirectory, in: searchPathDomainMask).first
        // TODO: fail if directory is nil (and debug)
    }
    
    func buildURL<F: Flag>(forFlag flag: F, usingContext context: Context) -> Result<URL, FlagURLBuilderError> {
        guard let url = directory?.appendingPathComponent(context.identifier).appendingPathComponent(flag.identifier) else {
            return .failure(.buildFailed)
        }
        return .success(url)
    }

}
