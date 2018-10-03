import Foundation

class InMemoryFlagRepository<F: Flag & Identifiable, S: FlagStatus & Codable>: FlagRepository {
    
    private var flags: [String: Data] = [:]
    
    func readStatus(ofFlag flag: F, callback: ReadCallback<S>?) {
        guard let data = flags[flag.identifier] else {
            callback?(.failure(.flagNotFound))
            return
        }
        let decoder = JSONDecoder()
        
        do {
            let decoded = try decoder.decode(S.self, from: data)
            callback?(.success(decoded))
        } catch {
            callback?(.failure(.other(error)))
        }
    }
    
    func writeStatus(_ status: S, ofFlag flag: F, callback: WriteCallback<S>?) {
        let encoder = JSONEncoder()
        
        do {
            let encoded = try encoder.encode(status)
            flags[flag.identifier] = encoded
            callback?(.success(status))
        } catch  {
            callback?(.failure(.other(error)))
        }
    }
    
    
}

