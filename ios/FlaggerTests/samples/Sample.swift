import Foundation
@testable import Flagger

class Sample {
    
    func foo() {
        let repository = InMemoryFlagRepository<MessageFeatures, OnOffFlagStatus>()
        MessageFeatures.canCompose.getStatus(usingRepository: repository) { result in
            switch result {
            case .success(let status):
                print("Status \(status)")
            case .failure(let error):
                print("Error \(error)")
            }
        }
            
    }
    
}
