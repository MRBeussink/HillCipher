import Foundation
import Surge


public typealias ExtendedEuclidianResult = (gcd: Int, x: Int, y: Int)


public enum CodecFlag {
    case encode
    case decode
    case both
    case neither
}


public enum HillCipherError : Error {
    case InvalidKeySize
    case InvalidKeyElement
    case SingularMatrix
    case NoModularInverse
    case InvalidMessageLength
}


public final class HillCipher {
    
    private var message = ""
    private var key = Matrix<Double>(rows: 2, columns: 2, repeatedValue: 0.0)
    private var codec: CodecFlag

    public init(codec: CodecFlag, message: String? = nil, key: String? = nil) throws {
        
        self.codec = codec
        
        
        // validate message
        validate(message: message)
        
        // validate key
        do {
            try validate(key: key)
        } catch {
            throw error
        }
        
        
        // check that message and key sizes correspond
        if self.message.count % self.key.rows != 0 {
            throw HillCipherError.InvalidMessageLength
        }
 
    }
    
    
    public func run() {
        
        switch codec {
        case .both:
            let ciphertext = encrypt()
            print("Cipher text = \(ciphertext)")
            self.message = ciphertext
            let plaintext = decrypt()
            print("Message = \(plaintext)")
        case .encode:
            print(encrypt())
        case .decode:
            print(decrypt())
        case .neither:
            print("You must choose a flag")
        }
        
        
    }
    
    
    public func encrypt() -> String {
        
        let plaintext = message.replacingOccurrences(of: " ", with: "").uppercased()
        let alphabet: [Character] = ["A", "B", "C", "D", "E", "F", "G",
                                     "H", "I", "J", "K", "L", "M", "N",
                                     "O", "P", "Q", "R", "S", "T", "U",
                                     "V", "W", "X", "Y", "Z"]
        let M = plaintext.map { Double(alphabet.firstIndex(of: $0)!) }
        var ciphertext = ""
        
        let size = key.rows
        
        for b in 0 ..< M.count where b % size == 0 {
            var block =  [Double]()
            for i in b..<b+size {
                block.append(M[i])
            }
            
            let m = Matrix<Double>(row: block)
            var c = Surge.mul(m, key)
            
            
            let row = c[row: 0]
            for j in row {
                let n = Int(j) % 26
                ciphertext.append(alphabet[n])
            }
            
            //print(ciphertext)
        }
            
        
        return ciphertext
    }
    
    public func decrypt() -> String {
        var plaintext = ""
        
        let inverseKey = invKey()
        let ciphertext = message.replacingOccurrences(of: " ", with: "").uppercased()
        let alphabet: [Character] = ["A", "B", "C", "D", "E", "F", "G",
                                     "H", "I", "J", "K", "L", "M", "N",
                                     "O", "P", "Q", "R", "S", "T", "U",
                                     "V", "W", "X", "Y", "Z"]
        let C = ciphertext.map { Double(alphabet.firstIndex(of: $0)!) }
        
        let size = inverseKey.rows
        
        for b in 0 ..< C.count where b % size == 0 {
            var block =  [Double]()
            for i in b..<b+size {
                block.append(C[i])
            }
            
            let c = Matrix<Double>(row: block)
            var m = Surge.mul(c, inverseKey)
            
            
            let row = m[row: 0]
            for j in row {
                let n = Int(j) % 26
                plaintext.append(alphabet[n])
            }
            
            //print(plaintext)
        }
        
        return plaintext
    }
    
    private func invKey() -> Matrix<Double> {
        
        let det = abs(mod(x: Int(Surge.det(key)!), n: 26))
        let invDet = extendedGCD(for: det, and: 26)
        
        // find adj(key)
        var adjKey = adj(a: key)
        
        var invKey = Matrix<Double>(rows: adjKey.rows, columns: adjKey.columns, repeatedValue: 0.0)
        
        for i in 0..<invKey.rows {
            for j in 0..<invKey.columns {
                invKey[i, j] = Double(mod(x:((invDet.x) * Int(adjKey[i, j])), n: 26))
            }
        }
        
        return invKey
    }
    
    
    // MARK: Validation
    
    private func validate(message: String?) {
        
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
    }
    
    private func validate(key: String?) throws {
        if let key = key {
            let strs = key.split(separator: " ")
            let nums = strs.map { return Double($0)!}
            let c = nums.count
            
            if c == 4 {
                let matrix = [[nums[0], nums[1]],
                            [nums[2], nums[3]]]
                self.key = Matrix<Double>(matrix)
            } else if c == 9 {
                let matrix = [[nums[0], nums[1], nums[2]],
                            [nums[3], nums[4], nums[5]],
                            [nums[6], nums[7], nums[8]]]
                self.key = Matrix<Double>(matrix)
            }
        } else {
            var nums = [[Double]]()
            var lines = [String]()
            
            print("Enter each row of key with elements seperated by spaces: ")
            repeat {
                let line = readLine()!
                let row = line.split(separator: " ")
                lines.append(line)
                nums.append( row.map { Double($0)! } )
            } while nums[0].count != lines.count
            
            do {
                let matrix = Matrix<Double>(nums)
                try validate(key: matrix)
                self.key = matrix
            } catch {
                throw error
            }
        }
    }
    
    private func validate(key: Matrix<Double>) throws {
        
        guard key.rows == key.columns && ( key.rows == 2 || key.rows == 3 )
            else { throw HillCipherError.InvalidKeySize }
        
        let nums = key.map { $0.map { Double($0) } }
        let detKey = det(Matrix(nums))!
        
        // (1) validate that key is nonsingular matrix, i.e. det(k) != 0
        guard detKey != 0.0 else { throw HillCipherError.SingularMatrix }
        
        // (2) validate that det(key) is co-prime with 26, i.e. gcd(det(key), 26) = 1
        guard extendedGCD(for: Int(detKey), and: 26).gcd == 1
            else { throw HillCipherError.NoModularInverse }
    }
    
}


// MARK: Error String Convertible Extension

extension HillCipherError : CustomStringConvertible {
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
        case .InvalidMessageLength:
            return "Message does not evenly divide into length of key"
        }
    }
}

public func extendedGCD(for m: Int, and n: Int) -> ExtendedEuclidianResult {
    
    var a = abs(m)
    var b = abs(n)
    
    if a == 0 {
        return (b, 0, 1)
    } else {
        let r = extendedGCD(for: mod(x: b, n:a), and: a)
        return (r.gcd, r.y - (b/a) * r.x, r.x)
    }
}

public func mod(x: Int, n: Int) -> Int {
    return (x % n + n) % n
}

public func adj(a: Matrix<Double>) -> Matrix<Double> {
    var adjMatrix = Matrix<Double>(rows: a.rows, columns: a.columns, repeatedValue: 0.0)
    if a.rows == 2 {
        adjMatrix[0,0] = a[1,1]
        adjMatrix[0, 1] = -a[0,1]
        adjMatrix[1,0] = -a[1,0]
        adjMatrix[1,1] = a[0,0]
    } else {
        
        for r in 0..<a.rows {
            for c in 0..<a.columns {
                let adj = mod(x: Int(cofactor(r: r, c: c, from: a)), n: 26)
                adjMatrix[r, c] = Double(adj)
            }
            
        }
        adjMatrix = Surge.transpose(adjMatrix)
    }
    
    return adjMatrix
}

public func cofactor(r: Int, c: Int, from a: Matrix<Double>) -> Double {
    var cofactor = Matrix<Double>(rows: 2, columns: 2, repeatedValue: 0.0)
    
    var x = 0
    var y = 0
    
    for i in 0..<a.rows where i != r {
        for j in 0..<a.columns where j != c {
            cofactor[x, y] = a[i, j]
            y += 1
        }
        x += 1
        y = 0
    }
    
    
    if (r + c) % 2 != 0 {
        let det = -Surge.det(cofactor)!
        return det
    } else {
        let det = Surge.det(cofactor)!
        return det
    }
}
