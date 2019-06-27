import UIKit
import RxCocoa
import RxSwift

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
