import Foundation

public func example(_ desc : String, execute: ()-> Void) {
    print("\n--- DisposeBagAndSchedulers:", desc, "---")
    execute()
}

public enum RxError: Error {
    case rxError
}
