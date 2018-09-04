import Foundation

class RemoteFlagRepository: FlagRepository {
    
    private let builder: FlagURLRequestBuilder
    private let transformer: FlagURLResponseTransformer
    private let session: URLSession
    
    init(builder: FlagURLRequestBuilder = DefaultFlagURLRequestBuilder(url: URL(string: "https://flagger.mashbytes.co.uk")!), transformer: FlagURLResponseTransformer = StatusCodeFlagURLResponseTransformer(), session: URLSession = URLSession.shared) {
        self.builder = builder
        self.transformer = transformer
        self.session = session
    }
    
    func readStatus<F: Flag>(ofFlag flag: F, forContext context: Context, callback: @escaping FlagCallback) {
        let result = builder.buildURLRequest(forFlag: flag, usingContext: context)
        switch result {
        case .success(let request):
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                guard let `self` = self else {
                    return
                }
                let result = self.transformer.transform(data: data, response: response, error: error, forFlag: flag)
                switch result {
                case .success(let status): callback(.success(status))
                case .failure(let error): callback(.failure(.other(error)))
                }
            }
            task.resume()
        case .failure(let error):
            callback(.failure(RepositoryError.other(error)))
        }
    }
    
    
}
