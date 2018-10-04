import Foundation

class URLJSONFlagRepository<F: Flag, S: FlagStatus & Codable>: FlagRepository {
    
    private let builder: AnyFlagURLBuilder<F>
    private let queue: DispatchQueue
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init<B: FlagURLBuilder>(builder: B, queue: DispatchQueue = DispatchQueue.global(qos: .background)) where F == B.FlagType {
        self.builder = AnyFlagURLBuilder(builder)
        self.queue = queue
    }
    
    func writeStatus(_ status: S, ofFlag flag: F, callback: WriteCallback<S>?) {
        queue.async {
            
            let result = self.builder.buildURL(forFlag: flag)
            switch result {
            case .success(let url):
                do {
                    let encoded = try self.encoder.encode(status)
                    try encoded.write(to: url)
                    callback?(.success(status))
                } catch {
                    callback?(.failure(.other(error)))
                }
            case .failure(let error):
                callback?(.failure(.other(error)))
            }
        }
    }
    
    func readStatus(ofFlag flag: F, callback: ReadCallback<S>?) {
        queue.async {
            let result = self.builder.buildURL(forFlag: flag)
            switch result {
            case .success(let url):
                do {
                    let data = try Data(contentsOf: url)
                    let status = try self.decoder.decode(S.self, from: data)
                    callback?(.success(status))
                } catch {
                    callback?(.failure(.other(error)))
                }
            case .failure(let error):
                callback?(.failure(.other(error)))
            }
        }
    }
    
}

/*
class DefaultFlagFileURLBuilder: FlagURLBuilder {
    
    private let directory: URL?
    
    init(searchPathDirectory: FileManager.SearchPathDirectory = .cachesDirectory, searchPathDomainMask: FileManager.SearchPathDomainMask = .userDomainMask, manager: FileManager = FileManager.default) {
        directory = manager.urls(for: searchPathDirectory, in: searchPathDomainMask).first
        // TODO: fail if directory is nil (and debug)
    }
    
    func buildURL(forFlag flag: DefaultFlagFileURLBuilder.FlagType) -> Result<URL, FlagURLBuilderError> {
        <#code#>
    }
    
    func buildURL<F: Flag>(forFlag flag: F, usingContext context: Context) -> Result<URL, FlagURLBuilderError> {
        guard let url = directory?.appendingPathComponent(context.identifier).appendingPathComponent(flag.identifier) else {
            return .failure(.buildFailed)
        }
        return .success(url)
    }

}
*/
