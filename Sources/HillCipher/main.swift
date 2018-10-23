import Foundation
import Utility
import HillCipherCore


let parser = ArgumentParser(commandName: "hill", usage: "[options]",
                            overview: "Preforms Hill encryption or decryption of message string.")
let encrypt = parser.add(option: "--encrypt", shortName: "-e", kind: Bool.self,
                         usage: "Turn on encryption")
let decrypt = parser.add(option: "--decrypt", shortName: "-d", kind: Bool.self,
                         usage: "Turn on decryption")

let arguments = Array(CommandLine.arguments.dropFirst())

do {
    
    let result = try parser.parse(arguments)
    var flag = CodecFlag.neither
    
    if arguments.isEmpty {
        flag = .both
    } else {
        let encode = result.get(encrypt)!
        let decode = result.get(decrypt)!
        
        if encode && decode {
            flag = .both
        } else if encode {
            flag = .encode
        } else if decode {
            flag = .decode
        } else {
            print("Flag not set")
        }
    }
    
    
    var codec = try HillCipher(codec: flag)
    
    codec.run()
} catch {
    print(error)
}


print("やった")
