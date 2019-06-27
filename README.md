# RxSwift Tutorial

```
RxSwift, basically a swift based reactive programming library to develop 
asynchronous program by emitting events either on sequential or isolated manner.
```

## System requirements
For this tutorial we'll use Xcode 10.2.1, Swift 5.*,  [cocoapods 1.7.2](https://cocoapods.org) and [RxSwift 5.0](https://github.com/ReactiveX/RxSwift.git). 

If you don't have cocoapods installed on your machine then please [visit cocoapods website](https://cocoapods.org) to install and learn how it works.


## Agenda
We will discuss about 
* Observable
* DisposeBag
* Subject and Relays
* Operators
* Schedulers

### Installing RxSwift
To get started, download [RxSwift-Tuts](https://github.com/mdzinuk/RxSwift-Part-01/tree/master/RxSwift-Tuts) project. Once the project is downloaded then navigate to the prject directory from Terminal.
```
cd /Users/zinuk/Downloads/RxSwift/RxSwift-Tuts
```
Install pods from Terminal:
```
$ pod install
```

### Getting Started with [RxSwift-Tuts](https://github.com/mdzinuk/RxSwift-Part-01/tree/master/RxSwift-Tuts)
Open the **RxSwift-Tuts.xcworkspace**  project in Xcode to build, build the project by selecting **RxSwift-Tut** target if it is not selected.

You might noticed <em>**DisposeBagAndSchedulers**</em>, <em>**Operators**</em>, <em>**Subjects**</em> and <em>**Observable**</em> playground files are there along with <em>**Pods**</em>. So, just ignore them for now and consider them as normal plaground files.

### Observable:
<em>**Observables**</em> are the core part of RxSwift, produce events overt a period of time where events can be somethings like value, type, UIEvents etc. 

Observable is just a sequence, with ability to do fun(like asynchronous) by operators!

It can emits next events until a terminating event(<em>**either success or error**</em>), once ternimation is done Observable is no longer able to send events.

That's enough about Observable, lets do some fun:
Open Observable playground from our RxSwift-Tuts project and create some observables:

```swift
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
```
Just run the playground and watch result, Nothing huh!!!

Yeah, that's right because an observable doesn’t do anything until it receives a subscription. 

Here are some examples:
```swift
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
```
### DisposeBag:
When we subscribe an Observable the Disposable keeps a strong reference to the Observable, Rx creates a retain cycle somehow, which needs to deallocate by calling deinit.

```swift
deinit {
    subscription?.dispose()
}
```
Creating subscriptions and manually disposing them is not easy sometimes, luckily **RxSwift** giving us a flexibility to this by introducing **DisposeBag** class. 

Single instant of DisposeBag() can be used in multiple places.

<em>**Note: Without disposing a subscribe there will be a memory leak.**</em>

Here is an example ofcreating, subscibing and disposing observable:

```swift
    let disposeBag = DisposeBag()
    Observable<String>
        .create({ (observer: AnyObserver<String>) -> Disposable in
            observer.onNext("First emitt")
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
```
**output**: 
```
--- Observable: Dispose Example ---
Look what is coming: First emitt
Look what is coming: Next
see error: RxSwift-Tuts Observable playground error!
Subscription Disposed
```

### Subject and Relays:

Subjects act as both an observable and an observer, they can receive .next events emits events to their correspondent subscriers.

There are four diffrent types of subject along with two relays wrapper on first two subjects.

Subjects:
PublishSubject: Starts with empty and only emits new element through its subscriber. Example:
```swift
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
```
Output:
```
--- Subjects: PublishSubject Example ---
Subscription {1 = 2}
Subscription {1 = 3}
Subscription {2 = 3}
Subscription {2 = 4}
Subscription {2 = 5}
see error: RxSwift-Tuts Subjects playground error!
```

BehaviorSubject: Starts with an initial value and emits new element to its subscriber. Example:

```swift
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
```


Output:
```
--- Subjects: BehaviorSubject Example ---
Subscription {1 = 1}
Subscription {2 = 1}
Subscription {1 = 3}
Subscription {2 = 3}
see error: RxSwift-Tuts Subjects playground error!
see error: RxSwift-Tuts Subjects playground error!
```

ReplaySubject: Initialize with buffer size and will maintain a buffer of elements upto that bbuffer size. Example: 

```swift
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
```
Output:
```
--- Subjects: ReplaySubject Example ---
Subscription {1 = next(2)}
Subscription {1 = next(3)}
Subscription {2 = next(2)}
Subscription {2 = next(3)}
Subscription {1 = next(4)}
Subscription {2 = next(4)}
Subscription {1 = error(subjectError)}
Subscription {2 = error(subjectError)}
```
AsyncSubject: Emits only the last .next event when subject reveives .completed event.

On the otherhand, PublishRelay and BehaviorRelay wrap their relative subjects, accept .next event without having either .completed or .error event(Non terminated sequences).

You may notice we import <em>**RxCocoa**</em> along with RxSwift, because Relays were defined in RxCocoa, which replaced Variable from RxSwift.

```swift
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

```
Output:
```
--- Subjects: PublishRelay + BehaviorRelay Examples ---
{ Subscription = Hello Subscription}
{ Subscription = Second relay}
```
### Operators:
RxSwift support so many useful operators, we will discuss some useful operators here, few of them we regularly use in our swift code base.

Now open up the <em>**Operators.playground**</em> from the project and try to play again

<em>**Filter:**</em>  

* IgnoreElements: Ignore the next event but allow .completed and .error event.
* ElementAt: Handle only nth elements.
* Filter: Same as swift filter
* DistinctUntilChanged:
* Skip:

```swift
example("FilterOperators Examples") {
    let disposeBag = DisposeBag()
    let publishrelay = PublishRelay<String>()
    publishrelay
        .ignoreElements() //  Will ignore everything
        .subscribe({ observer in
            print("{ Subscription = \(observer)}")
        }).disposed(by: disposeBag)
    
    publishrelay.accept("ignore forever")
    publishrelay.accept("ignore forever")
    
    publishrelay
        .elementAt(2)// will take element index [2]
        .filter{ $0 == "index 03" } // allow string match only
        .subscribe(onNext: { (str) in
            print("{ Subscription = \(str)}")
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            print("Completed")
        })
    publishrelay.accept("index 01")
    publishrelay.accept("index 02")
    publishrelay.accept("index 03")
    publishrelay.accept("index 04")
    publishrelay.accept("index 05")
    
    publishrelay
        .skip(1) // Skip until [1] index element
        .distinctUntilChanged() // discard the duplicate events
        .subscribe({
            print("{ Subscription = \($0.element ?? "")}")
        })
    
    publishrelay.accept("index 06")
    publishrelay.accept("index 06")
    publishrelay.accept("index 06")
    publishrelay.accept("index 07")
    publishrelay.accept("index 08")
}

```
Output:
```
--- Operators: FilterOperators Examples ---
{ Subscription = index 03}
Completed
{ Subscription = index 06}
{ Subscription = index 07}
{ Subscription = index 08}
```

<em>**Transformation:**</em>
* Map:
* CompactMap:
These two operators work same way as swift does

```swift
example("Transforming Examples") {
    let disposeBag = DisposeBag()
    struct Game {
        let player: String
        let score: Int?
    }
    
    let publisher = PublishSubject<Game>()
    publisher
        .compactMap { (game: Game) in // allow scorer only
            print((game.score != nil) ? game.player : "")
            return game.score
        }.map {$0 + 1} // Add extra bonus
        .subscribe({ observer in
            print("got bonous for each score = \(observer.element ?? 0)")
        })
        .disposed(by: disposeBag)
    
    publisher.onNext(Game(player: "Player 01", score: 1))
    publisher.onNext(Game(player: "Player 02", score: nil))
}

```
```
--- Operators: Transforming Examples ---
Player 01
got bonous for each score = 2
```


<em>**Combine:**</em>
* StartWith:
* Merge:
* Zip:
* CombineLatest:

Here is an Zip example:
```swift
example("Combine Examples") {
    let disposeBag = DisposeBag()
    
    let relay1 = BehaviorRelay<Int>.of(1, 2, 3)
    let relay2 = BehaviorRelay<Int>.of(6, 7, 8)
    
    BehaviorRelay
        .zip(relay1, relay2)
        .subscribe(onNext: { (realy1: Int, relay2: Int) in
            print("Result = \(relay2 + realy1)")
        }).disposed(by: disposeBag)
}
```
Output:
```
--- Operators: Combine Examples ---
Result = 7
Result = 9
Result = 11
```


### Schedulers:

In RxSwift we can us schedulers to force operators to do their work on any specific ques, which can be done by using subscribeOn and observeOn tasks. Othewise operators will run as in same thread as they subscribe on.

They are mainly five types
* MainScheduler: Usually perform UI work, start immediately without any scheduling.
* CurrentThreadScheduler: Schedulels the work on the current thread.
* SerialDispatchQueueScheduler: Perform specific tasks on dipatch_queue_t by transforming task on serial queue even if tasks were running on concurrent queue.
* ConcurrentDispatchQueueScheduler: Useful to perform long run task inside backgroud queue on dispatch_queue_t.
* OperationQueueScheduler: Allow task to run on NSOperationQueue.

```swift
example("Scheduler Examples") {
    let disposeBag = DisposeBag()
    let relay1 = PublishRelay<String>()
    let relay2 = PublishRelay<String>()
    let background = ConcurrentDispatchQueueScheduler(qos: .background)
    let main = MainScheduler.instance
    
    Observable.of(relay1, relay2)
        .observeOn(background)
        .merge()
        .subscribeOn(main)
        .subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
    
    relay1.accept("Relay01 = value01")
    relay1.accept("Relay01 = value02")
    relay1.accept("Relay01 = value03")
    relay1.accept("Relay01 = value04")
    relay2.accept("Relay02 = value01")
    relay2.accept("Relay02 = value02")
}
```
Output:
```
--- Schedulers: Scheduler Examples ---
Relay01 = value01
Relay01 = value02
Relay01 = value03
Relay01 = value04
Relay02 = value01
Relay02 = value02
```


Here is the [Final project](https://github.com/mdzinuk/RxSwift-Part-01/tree/master/RxSwift-Tuts-Final) has been done for clear understanding. 

Still confusing? 

Explore more with two additional [Sample project(Networking & UI)](https://github.com/mdzinuk/RxSwift-More-Example).

## What's next? 
Explore **[RxCocoa Tutorial](https://github.com/mdzinuk/RxCocoa)** :)