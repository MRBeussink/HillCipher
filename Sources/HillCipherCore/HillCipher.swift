import Foundation
import Surge


public typealias ExtendedEuclidianResult = (gcd: Int, x: Int, y: Int)


public enum CodecFlag {
    case encode
    case decode
    case both
}


public enum HillCipherKeyError : Error {
    case InvalidKeySize
    case InvalidKeyElement
    case SingularMatrix
    case NoModularInverse
}


public final class HillCipher {
    
    private var message = ""
    private var key = [[Int]]()
    private var codec: CodecFlag
    

    public init(message: String?, key: String?, codec: CodecFlag) throws {
        
        self.codec = codec
        
        // validate message
        if let message = message {
            self.message = message
        } else {
            var valid = false
            repeat {
                print("Enter message: ")
                
                if let line = readLine() {
                    self.message = line
                    valid = true
                }
                
            } while !valid
            
        }
        
        // validate key
        if let key = key {
            let strs = key.split(separator: " ")
            if strs.count == 4 {
                
            } else if strs.count == 9 {
                
            } else {
                throw HillCipherKeyError.InvalidKeySize
            }
            
        } else {
            var nums = [[Int]]()
            var valid = false
            repeat {
                print("Enter each row of key with elements seperated by ")
                
                var inputs = [[String]]()
            
                for i in 0...3 {
                    if let line = readLine() {
                        for s in line.split(separator: " ") {
                            if let num = Int(s) {
                                nums[i].append(num)
                            } else {
                                fatalError("Key must only contain integers")
                            }
                        }
                    }
                if inputs[0].count != inputs.count { break }
                }
                
                do {
                    try valid = validate(nums)
                } catch {
                    print(error)
                    nums = [[Int]]()
                }
                
            } while !valid
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
    
    
    // MARK: Validation
    
    private func validate(_ key: [[Int]]) throws -> Bool {
        
        guard key.count == key[0].count && ( key.count == 2 || key.count == 3 )
            else { throw HillCipherKeyError.InvalidKeySize }
        
        let floats = key.map { $0.map { Float($0) } }
        let detKey = det(Matrix(floats))!
        
        // (1) validate that key is nonsingular matrix, i.e. det(k) != 0
        guard detKey != 0.0 else { throw HillCipherKeyError.SingularMatrix }
        
        // (2) validate that det(key) is co-prime with 26, i.e. gcd(det(key), 26) = 1
        guard extendedGCD(for: Int(detKey), and: 26).gcd == 1
            else { throw HillCipherKeyError.NoModularInverse }
        
        return true
    }
}


// MARK: Error String Convertible Extension

extension HillCipherKeyError : CustomStringConvertible {
    public var description: String {
        switch self {
        case .InvalidKeyElement:
            return "Key must only contain integers seperated by spaces"
        case .InvalidKeySize:
            return "Key must be a square matrix of size 2*2 or 3*3"
        case .SingularMatrix:
            return "Given key matrix is singular"
        case .NoModularInverse:
            return "Given key matrix is not invertible under (mod 26)"
        }
    }
}


/*
func det(_ matrix: [[Int]]) -> Int {
    if matrix.count == 2 {
        return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    } else if matrix.count == 3 {
        let a = matrix[0][0] * det([[matrix[1][1], matrix[1][2]], [matrix[2][1], matrix[2][2]]])
        let b = matrix[0][1] * det([[matrix[1][0], matrix[1][2]], [matrix[2][0], matrix[2][2]]])
        let c = matrix[0][2] * det([[matrix[1][0], matrix[1][1]], [matrix[2][0], matrix[2][1]]])
        return a - b + c
    } else {
        fatalError("Only matrices of size 2x2 or 3x3 are supported")
    }
}

func subMatrix(_ matrix: inout [[Int]], at corners: [Point]) -> [[Int]] {
    var result = [[Int]]()
    for i in corners[0].row ... corners[1].row {
        var row = [Int]()
        for j in corners[0].col ... corners[1].col {
            row.append(matrix[i][j])
        }
        result.append(row)
    }
    
    return result
}
*/
/*
public func gcd(a:Int, b:Int) -> Int {
    if a == b {
        return a
    } else {
        if a > b {
            return gcd(a:a-b,b:b)
        }
        else {
            return gcd(a:a,b:b-a)
        }
    }
}
*/

public func extendedGCD(for a: Int, and b: Int) -> ExtendedEuclidianResult {
    
    if (b == 0) { return (a, 1, 0) }
    
    let result = extendedGCD(for: b, and: a % b)
    
    let gcd = result.gcd
    let x = result.x
    let y = x - (a / b) * result.y
    
    return (gcd, x, y)
}
