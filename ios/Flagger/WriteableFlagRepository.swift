import Foundation

protocol WriteableFlagRepository: FlagRepository {
    
    func writeStatus<F: Flag>(_ status: FlagStatus, ofFlag flag: F, forContext context: Context)
    
}

extension WriteableFlagRepository {
    
    func writeStatus<F: Flag>(_ status: FlagStatus, ofFlag flag: F) {
        writeStatus(status, ofFlag: flag, forContext: StaticContext())
    }
}


