import Foundation

class Sample {
    
    func foo() {
        MessageFeatures.canCompose.getStatus() { result in
            switch result {
            case .success(let status): break
            case .failure(_): break
            }
        }
    }
    
}
