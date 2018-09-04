import Foundation

struct StaticContext: Context {
    
    let identifier: String
    
    init(identifier: String = "") {
        self.identifier = identifier
    }
    
}

