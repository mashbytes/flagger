import Foundation
@testable import Flagger

enum TestFlags: String, Flag {
    
    case canFlyToTheMoon
    case canDiveToTheBottomOfTheOcean
    case canDrive
 
    

}

extension TestFlags: Identifiable {
    
    var identifier: String {
        return rawValue
    }

}

enum OnOffFlagStatus: String, FlagStatus {
    case on, off
}

extension OnOffFlagStatus: Codable {
        
    
}
