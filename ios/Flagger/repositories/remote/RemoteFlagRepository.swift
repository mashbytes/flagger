import Foundation

class RemoteFlagRepository<F: Flag, S: FlagStatus>: ReadableFlagRepository {

    private let requestBuilder: AnyFlagURLRequestBuilder<F>
    private let responseTransformer: AnyFlagURLResponseTransformer<S>
    private let session: URLSession
    
    init<B: FlagURLRequestBuilder, T: FlagURLResponseTransformer>(requestBuilder: B, responseTransformer: T, session: URLSession = URLSession.shared) where F == B.FlagType, S == T.FlagStatusType {
        self.requestBuilder = AnyFlagURLRequestBuilder(requestBuilder)
        self.responseTransformer = AnyFlagURLResponseTransformer(responseTransformer)
        self.session = session
    }
    
    func readStatus(ofFlag flag: F, callback: ReadCallback<S>?) {
        let result = requestBuilder.buildURLRequest(forFlag: flag)
        switch result {
        case .success(let request):
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                guard let `self` = self else {
                    return
                }
                let result = self.responseTransformer.transform(data: data, response: response, error: error)
                switch result {
                case .success(let status): callback?(.success(status))
                case .failure(let error): callback?(.failure(.other(error)))
                }
            }
            task.resume()
        case .failure(let error):
            callback?(.failure(RepositoryError.other(error)))
        }
    }
    
}
