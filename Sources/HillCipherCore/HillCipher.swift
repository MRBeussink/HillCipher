import Foundation
import Surge

public enum CipherFlag {
    case encrypt
    case decrypt
}

enum HillCipherError : Error {
    case InvalidKeySize
    case InvalidKeyElement
}

public final class HillCipher {
    private var key = [[Int]]()
    private var message = ""
    

    public init(key: String?, message: String?) throws {
        // assign key
        if let key = key {
            let nums = key.split(separator: " ")
            guard nums.count == 4 || nums.count == 9 else { throw HillCipherError.InvalidKeySize }
            
            let size = nums.count == 4 ? 2 : 3
            var counter = 0
            
            for row in 0..<size {
                for col in 0..<size {
                    guard let num = Int(nums[counter]) else { throw HillCipherError.InvalidKeyElement}
                    self.key[row][col] = num
                    counter+=1
                }
            }
            
        } else {
            print("Enter key formatted with spaces: ")
            let input = readLine()
            let nums = input!.split(separator: " ")
            guard nums.count == 4 || nums.count == 9 else { throw HillCipherError.InvalidKeySize }
            
            let size = nums.count == 4 ? 2 : 3
            var counter = 0
            
            for row in 0..<size {
                for col in 0..<size {
                    guard let num = Int(nums[counter]) else { throw HillCipherError.InvalidKeyElement}
                    self.key[row][col] = num
                    counter+=1
                }
            }
        }
        
        // assign message
        if let message = message {
            self.message = message
        } else {
            print("Enter the message: ")
        }
    }
    
    
    public func run() {
        print("やった")
    }
    
    // MARK: Private methods
    
    private func encrypt(message: String, with key: [[Int]]) -> String {
        
        return ""
    }
    
    
    private func decrypt(message: String, with key: [[Int]]) -> String {
        
        return ""
    }
}

// MARK: Error String Convertible Extension

extension HillCipherError : CustomStringConvertible {
    var description: String {
        switch self {
        case .InvalidKeyElement:
            return "Key must only contain integers seperated by spaces"
        case .InvalidKeySize:
            return "Key must be a square matrix of size 2*2 or 3*3"
        }
    }
}
