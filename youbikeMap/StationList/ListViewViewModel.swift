//
//  ListViewViewModel.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import Foundation
import CoreLocation
import RxRelay
import RxSwift

class ListViewViewModel {
    
    struct Station {
        let ID: String
        let coordinate: CLLocationCoordinate2D
        var isFavorite: Bool = false
        let name: String // -> sna
        let address: String // -> ar
        let emptySlot: Int // -> bemp
        let avaliableBikes: Int // -> sbi
        let area: String // -> sarea
    }
    
//    let stations: BehaviorRelay<[YouBikeStation]> = .init(value: [])
    let stations: PublishRelay<[Station]> = .init() //Observabel, Subscriber
    
    private let bag = DisposeBag()
//
//    func fetchStations(_ event: Observable<Void>) {
//        event
//        .flatMap { (_) -> Observable<[String: YouBikeStation]> in
//            return DataManager.shared.getYoubikeData()
//        }
//        .map({ (stations) -> [YouBikeStation] in
//            return stations.values.map({ $0 })
//        })
//        .subscribe(onNext: { (stations) in
//
//            self.stations.accept(stations)
//        })
//        .disposed(by: bag)
//    }
    
    func fs(_ event: Observable<Void>) {
        Observable.combineLatest(
            UserDefaults.standard.rx.observe([String].self, "favoriteIDs"),
            Observable<Int>.timer(.seconds(0), period: .seconds(5), scheduler: MainScheduler.instance)
                .flatMap { (_) -> Observable<[String: YouBikeStation]> in
                    return DataManager.shared.getYoubikeData()
            }, event.flatMap({ _ in
                return DataManager.shared.getYoubikeData()
            })
        )
        .map({ (IDs, stations, refresh) -> ([String]?, [YouBikeStation]) in
            var temps = [YouBikeStation]()
            for k in stations.keys {
                temps.append(stations[k]!)
            }
            temps.sort { (lhs, rhs) -> Bool in
                return lhs.sno > rhs.sno
            }
            return (IDs, temps)
        })
        .map({ (IDs, stations) -> [Station] in
            return stations.map {
                var new = $0.toStation()
                new.isFavorite = (IDs ?? []).contains(new.ID)
                return new
            }
        })
        .subscribe(onNext: { (stations) in
            self.stations.accept(stations)
        })
        .disposed(by: bag)
        
    }
    
    
    func fetchStations(_ event: Observable<Void>, keywordEvent: Observable<String?>) {
        Observable.combineLatest(
            UserDefaults.standard.rx.observe([String].self, "favoriteIDs"),
            event.flatMap { (_) -> Observable<[String: YouBikeStation]> in
                return DataManager.shared.getYoubikeData()
            },
            keywordEvent
        )
            .map({ (IDs, stations, keyword) -> ([String]?, [YouBikeStation], String?) in
                var temps = [YouBikeStation]()
                for k in stations.keys {
                    temps.append(stations[k]!)
                }
                temps.sort { (lhs, rhs) -> Bool in
                    return lhs.sno > rhs.sno
                }
                return (IDs, temps, keyword)
            })
            .map({ (IDs, stations, keyword) -> [Station] in
                let newStations: [Station] = stations.map {
                    var new = $0.toStation()
                    new.isFavorite = (IDs ?? []).contains(new.ID)
                    return new
                }
                guard let keyword = keyword else { return newStations }
                if keyword.isEmpty { return newStations }
                return newStations.filter { (station) -> Bool in
                    return keyword.contains(station.area)
                }
            })
            .subscribe(onNext: { stations in
                print(stations.first)
                self.stations.accept(stations)
            })
            .disposed(by: bag)
    }
}

extension YouBikeStation {
    func toStation() -> ListViewViewModel.Station {
        let coordinate = CLLocationCoordinate2D(latitude: Double(lat) ?? 0.0, longitude: Double(lng) ?? 0.0)
        return ListViewViewModel.Station(ID: sno,
                                         coordinate: coordinate,
                                         name: sna,
                                         address: ar,
                                         emptySlot: Int(bemp) ?? 0,
                                         avaliableBikes: Int(sbi) ?? 0,
                                         area: sarea)
    }
}
