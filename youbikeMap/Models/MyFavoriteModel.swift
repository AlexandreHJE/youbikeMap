//
//  MyFavoriteModel.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay



class FavoriteList {
//    let stations: PublishRelay<[YouBikeStation]> = .init() //Observabel, Subscriber
//
//    private let bag = DisposeBag()
//
    let favorites: PublishRelay<[String]> = .init()
    private let bag = DisposeBag()
    
    func fetchFavorites() {
        
    }
//    @objc
//    func fetchStations() {
//        Observable<Int>
//            .timer(.seconds(0), period: .seconds(5), scheduler: MainScheduler.instance)
//            .flatMap { (_) -> Observable<[String: YouBikeStation]> in
//                return DataManager.shared.getYoubikeData()
//        }
//        .map({ (stations) -> [YouBikeStation] in
//            var temps = [YouBikeStation]()
//            for k in stations.keys {
//                temps.append(stations[k]!)
//            }
//            temps.sort { (lhs, rhs) -> Bool in
//                return lhs.sno > rhs.sno
//            }
//            return temps
//        })
//            .subscribe(onNext: { (stations) in
//                print(stations.first)
//                self.stations.accept(stations)
//            })
//            .disposed(by: bag)
//    }
}
