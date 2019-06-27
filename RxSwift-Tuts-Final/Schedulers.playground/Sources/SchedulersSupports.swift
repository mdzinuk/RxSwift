import Foundation

public func example(_ desc : String, execute: ()-> Void) {
    print("\n--- Schedulers:", desc, "---")
    execute()
}

public enum RxError: Error {
    case schedulerError
    
    public var errorDescription: String? {
        switch self {
        case .schedulerError:
            return "RxSwift-Tuts schedulerError playground error!"
        }
    }
}
