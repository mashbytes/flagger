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
            let result = self.buildURL(forFlag: flag) { url in
                let container = Container(status: status)
                let encoded = try self.encoder.encode(container)
                
                try encoded.write(to: url)
                return .success(status)
            }
            callback?(result)
        }
    }
    
    func readStatus(ofFlag flag: F, callback: ReadCallback<S>?) {
        queue.async {
            let result = self.buildURL(forFlag: flag) { url in
                let data = try Data(contentsOf: url)
                let container = try self.decoder.decode(Container.self, from: data)
                let status = container.status
                return .success(status)
            }
            callback?(result)
        }
    }
    
    private func buildURL(forFlag flag: F, onSuccess: (URL) throws -> Result<S, RepositoryError>) -> Result<S, RepositoryError> {
        let result = builder.buildURL(forFlag: flag)
        switch result {
        case .success(let url):
            do {
                return try onSuccess(url)
            } catch {
                return .failure(.other(error))
            }
        case .failure(let error):
            return .failure(.other(error))
        }
    }

    private struct Container: Codable {
        let status: S
    }
}

