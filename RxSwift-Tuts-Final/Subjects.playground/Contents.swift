import RxSwift
import RxCocoa

example("PublishSubject Example") {
    let subject = PublishSubject<Int>()
    // 1 will not recieve because it emits event before subscription
    subject.onNext(1)
    
    let subscription1 = subject.subscribe(onNext: { (int: Int) in
        print("Subscription {1 = \(int)}")
    }, onError: { (error: Error) in
        print("see error: \(error.localizedDescription)")
    }, onCompleted: {
        print("subscription1 completed")
    })
    
    // 2 will be received by subscription 1 only
    subject.onNext(2)
    
    let subscription2 = subject
        .subscribe(onNext: { (int: Int) in
            print("Subscription {2 = \(int)}")
        }, onError: { (error: Error) in
            print("see error: \(error.localizedDescription)")
        })
    // 3 will be received by both subscription 1 and 2
    subject.onNext(3)
    
    // Subscription1 will no longer receive any events
    subscription1.dispose()
    
    // 4 & 5 will recieve only subscription 1
    subject.onNext(4)
    subject.onNext(5)
    
    // Subscription2 will recceive an error after that it will never receive any events.
    subject.onError(RxError.subjectError)
    
    //will not receive anymore
    subject.onNext(6)
    subscription2.dispose()
}

example("BehaviorSubject Example") {
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject<Int>(value: 1)
    
    let subscription1 = subject
        .subscribe(onNext: { (int: Int) in
            print("Subscription {1 = \(int)}")
        }, onError: { (error: Error) in
            print("see error: \(error.localizedDescription)")
        }, onCompleted: {
            print("subscription1 completed")
        }, onDisposed: {
            disposeBag
        })
    
    let subscription2 = subject
        .subscribe(onNext: { (int: Int) in
            print("Subscription {2 = \(int)}")
        }, onError: { (error: Error) in
            print("see error: \(error.localizedDescription)")
        }, onCompleted: {
            print("subscription2 completed")
        }, onDisposed: {
            disposeBag
        })
    
    // 3 will be received by both subscription 1 and 2
    subject.onNext(3)
    // Error will be received by both subscription 1 and 2
    subject.onError(RxError.subjectError)
    subject.onNext(4)
}
 

example("ReplaySubject Example") {
    let subject = ReplaySubject<Int>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
   
    // 1 will not receive since bufferSize == 2
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
    
    
    let subscription1 = subject.subscribe {
        print("Subscription {1 = \($0)}")
        }.disposed(by: disposeBag)
    
    let subscription2 = subject.subscribe {
        print("Subscription {2 = \($0)}")
    }.disposed(by: disposeBag)
    
    subject.onNext(4)
    
    subject.onError(RxError.subjectError)
    subject.dispose()
}
 
example("PublishRelay + BehaviorRelay Examples") {
    let disposeBag = DisposeBag()
    let publishrelay = PublishRelay<String>()
    publishrelay.accept("First relay")
    publishrelay.subscribe(onNext: { (str) in
        print("{ Subscription = \(str)}")
    }, onError: { (error) in
        print("see error: \(error.localizedDescription)")
    }, onCompleted: {
        print("subscription2 completed")
    }).disposed(by: disposeBag)
    
    //These two statements are compiler error so commented out
    //publishrelay.accept(RxError.subjectError)
    //relay.onCompleted()
    publishrelay.accept("Hello Subscription")
    
    // Initialized with a default value
    let behaviorRelay = BehaviorRelay(value: "Initial value")
    behaviorRelay.accept("Second relay")
    behaviorRelay.subscribe({
        print("{ Subscription = \($0.element ?? "")}")
    }).disposed(by: disposeBag)
}
