import Foundation

protocol Flag {
    
}

protocol FlagStatus {
    
}

protocol Identifiable {
    
    var identifier: String { get }
    
}

enum Toggle {
    case on, off
}

protocol Toggleable {
    
    var toggle: Toggle { get }
}

protocol HTTPStatusCodeDecodable {
    
    init(from code: Int)
    
}

