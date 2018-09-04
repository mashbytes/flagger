import Foundation

enum SampleContexts: Context {
    
    case user(String)
    case group(String)
    case appVersion(String)
    
    var identifier: String {
        switch self {
        case .user(let identifier): return "user-\(identifier)"
        case .group(let identifier): return "group-\(identifier)"
        case .appVersion(let identifier): return "appVersion-\(identifier)"
        }
    }
    
}

