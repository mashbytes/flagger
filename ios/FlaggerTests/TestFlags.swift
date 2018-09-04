import Foundation
@testable import Flagger

enum TestFlags: String, Flag {
    
    case canFlyToTheMoon
    case canDiveToTheBottomOfTheOcean
    case canDrive
 
    var identifier: String {
        return rawValue
    }
    

}
