import Foundation

protocol FlagURLResponseTransformer {
    associatedtype FlagStatusType: FlagStatus
    
    func transform(data: Data?, response: URLResponse?, error: Error?) -> Result<FlagStatusType, FlagURLResponseTransformerError>
    
}

enum FlagURLResponseTransformerError: Error {
    
    case transformationFailed
    case unexpectedResponse
    case other(Error)
    
}

struct AnyFlagURLResponseTransformer<TargetFlagStatusType: FlagStatus>: FlagURLResponseTransformer {
    
    private let transformFn: (Data?, URLResponse?, Error?) -> Result<FlagStatusType, FlagURLResponseTransformerError>
    
    init<T: FlagURLResponseTransformer>(_ transformer: T) where T.FlagStatusType == TargetFlagStatusType {
        transformFn = transformer.transform
    }
    
    func transform(data: Data?, response: URLResponse?, error: Error?) -> Result<TargetFlagStatusType, FlagURLResponseTransformerError> {
        return transformFn(data, response, error)
    }

}
