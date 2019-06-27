import Foundation

public func example(_ desc : String, execute: ()-> Void) {
    print("\n--- Observable:", desc, "---")
    execute()
}

public enum RxError: Error {
    case rxError
}
