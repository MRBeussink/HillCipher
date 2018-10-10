import HillCipherCore

let hill = HillCipher()

do {
    try hill.run()
} catch {
    print("Whoops!  Something went wrong.")
}
