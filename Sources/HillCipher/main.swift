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
    
   
    
    print(result)
} catch {
    print(error)
}


print("やった")
