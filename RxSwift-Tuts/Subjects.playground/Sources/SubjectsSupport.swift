import Foundation

public func example(_ desc : String, execute: ()-> Void) {
    print("\n--- Subjects:", desc, "---")
    execute()
}

public enum RxError: Error {
    case rxError
}
