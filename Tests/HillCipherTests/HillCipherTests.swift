import Foundation
import XCTest
import Surge
import HillCipherCore

class HillCipherTests: XCTest {
    
    func testWikiEx() throws {
        
        let key = [[3, 3],
                   [2, 5]]
        let message = "HELP"
        
        let codec = try? HillCipher(codec: <#T##CodecFlag#>, message: <#T##String?#>, key: <#T##String?#>)
    }
}
