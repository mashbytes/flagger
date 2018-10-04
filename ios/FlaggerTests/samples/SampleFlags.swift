import Foundation
@testable import Flagger

enum MessageFeatures: Flag {
    case canCompose
    case canDelete
    
    
}

extension MessageFeatures: Identifiable {
    
    var identifier: String {
        switch self {
        case .canCompose: return "can-compose"
        case .canDelete: return "can-delete"
        }
    }

}
