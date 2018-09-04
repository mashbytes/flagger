import Foundation

enum MessageFeatures: Flag {
    case canCompose
    case canDelete
    
    var identifier: String {
        switch self {
        case .canCompose: return "can-compose"
        case .canDelete: return "can-delete"
        }
    }
    
}

