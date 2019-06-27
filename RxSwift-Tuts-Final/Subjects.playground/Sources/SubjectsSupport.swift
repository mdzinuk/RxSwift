import Foundation

public func example(_ desc : String, execute: ()-> Void) {
    print("\n--- Subjects:", desc, "---")
    execute()
}

public enum RxError: Error, LocalizedError {
    case subjectError
    
    public var errorDescription: String? {
        switch self {
        case .subjectError:
            return "RxSwift-Tuts Subjects playground error!"
        }
    }
}
