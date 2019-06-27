import UIKit
import RxSwift
import RxCocoa

 
example("Create Observables With Different Operators Examples") {
    //Create observable sequence of type String using just operator
    let singleElementObservable = Observable<String>.just("Just")
    
    //Create observable sequence of type variadic String using of operator
    let variadicElementsObservable = Observable<String>.of("This is variadic", "not array")
    
    //Create observable sequence of array[String] using of operator
    let arrayObservable = Observable<[String]>.of(["First element", "Second element"])
    
    //Create observable sequence from array using from operator
    let singleElementFromObservable = Observable<String>.from(["First element", "Second element"])
    
    //Create observable sequence of Void using empty operator
    let emptyElementObservable = Observable<Void>.empty()
    
    //Create observable sequence of using never operator
    let neverObservable = Observable<Void>.never()
    
    //Create observable sequence of using range operator
    let rangeObservable = Observable<Int>.range(start: 1, count: 10)
}

example("Subscribe Examples") {
    //Create observable sequence of type String using just operator
    //Observer with subscribe
    Observable<String>
        .just("Just")
        .subscribe({ (event: Event<String>) in
            print(event.element ?? "")
        })
    
    //Create observable sequence of type variadic String using of operator
    //Observer with subscribe, error and completed
    Observable<String>
        .of("This is variadic", "not array")
        .subscribe(onNext: { (str: String) in
            print(str)
        }, onError: { (error: Error) in
            print(error.localizedDescription)
        }, onCompleted: {
            print("Cmpleted variadic Observable subscription")
        })
    
    //Create observable sequence of array[String] using of operator
    //Observer with subscribe
    Observable<[String]>
        .of(["First element", "Second element"])
        .subscribe({ (event: Event<[String]>) in
            print(event.element?.count ?? 0)
        })
    
    //Create observable sequence from array using from operator
    //Observer with subscribe
    Observable<String>
        .from(["First element", "Second element"])
        .subscribe({ (event: Event<String>) in
            print(event.element ?? "")
        })
    
    //Create observable sequence of Void using empty operator
    //Observer with subscribe, error and completed
    //Terminate immediately, useful when we need just an observable or somehing zero
    Observable<Void>
        .empty()
        .subscribe(onNext: { (element: Void) in
            print("Empty subscribe element \(element)")
        }, onError: { (error: Error) in
            print(error)
        }, onCompleted: {
            print("Completed Empty Subscribe")
        })
    
    //Create observable sequence of using never operator
    //Opposite to empty, and never terminate means infinite
    Observable<Void>
        .never()
        .subscribe({ (event: Event<Void>) in
            print(event.element ?? "")
        })
    
    //Create observable sequence of using range operator
    //Observer with subscribe, error and completed
    Observable<Int>
        .range(start: 1, count: 10)
        .subscribe(onNext: { (int: Int) in
            print((int % 2 == 0) ? "even number = \(int)" : "odd number = \(int)")
        }, onError: { (error: Error) in
            print(error)
        }, onCompleted: {
            print("Completed Range Subscribe")
        })
}

example("Dispose Example") {
    let disposeBag = DisposeBag()
    Observable<String>
        .create({ (observer: AnyObserver<String>) -> Disposable in
            observer.onNext("First emit")
            observer.onNext("Next")
            //We can either use onCompleted or onError
            //observer.onCompleted()
            observer.onError(RxError.observableError)
            observer.onNext("Next is not coming now")
            return Disposables.create()
        })
        .subscribe(onNext: { (string: String) in
            print("Look what is coming: \(string)")
        }, onError: { (error: Error) in
            print("see error: \(error.localizedDescription)")
        }, onCompleted: {
            print("Subscription Completed")
        }, onDisposed: {
            print("Subscription Disposed")
        })
        .disposed(by: disposeBag)
}




