import Foundation

public func example(_ desc : String, execute: ()-> Void) {
    print("\n--- Observable:", desc, "---")
    execute()
}

public enum RxError: Error, LocalizedError {
    case observableError
    
    public var errorDescription: String? {
        switch self {
        case .observableError:
            return "RxSwift-Tuts Observable playground error!"
        }
    }
}
