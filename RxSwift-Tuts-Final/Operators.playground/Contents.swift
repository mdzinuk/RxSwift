import RxCocoa
import RxSwift

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
