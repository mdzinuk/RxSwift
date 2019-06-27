import Foundation
public func example(_ desc : String, execute: ()-> Void) {
    print("\n--- Operators:", desc, "---")
    execute()
}

public enum RxError: Error {
    case operatorError
    
    public var errorDescription: String? {
        switch self {
        case .operatorError:
            return "RxSwift-Tuts operators playground error!"
        }
    }
}
