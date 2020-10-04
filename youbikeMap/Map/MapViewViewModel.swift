//
//  MapViewViewModel.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/2.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import RxRelay
import RxSwift

class MapViewViewModel {
    
    struct Station {
        let ID: String
        let coordinate: CLLocationCoordinate2D
        var isFavorite: Bool = false
        let name: String // -> sna
        let address: String // -> ar
        let emptySlot: Int // -> bemp
        let area: String // -> sarea
    }
    
    let stations: BehaviorRelay<[YouBikeStation]> = .init(value: [])
    //Observabel, Subscriber
    
    private let bag = DisposeBag()
    
    func fetchStations(_ event: Observable<Void>) {
        event
        .flatMap { (_) -> Observable<[String: YouBikeStation]> in
            return DataManager.shared.getYoubikeData()
        }
        .map({ (stations) -> [YouBikeStation] in
            return stations.values.map({ $0 })
        })
        .subscribe(onNext: { (stations) in
            self.stations.accept(stations)
        })
        .disposed(by: bag)
    }
    
    func station(with coordinate: CLLocationCoordinate2D) -> YouBikeStation? {

        return stations.value.first { (station) -> Bool in
            let stationCoordinate = CLLocationCoordinate2D(latitude: Double(station.lat) ?? 0.0,
                                                           longitude: Double(station.lng) ?? 0.0)
            return stationCoordinate == coordinate
                
        }
    }
}

extension CLLocationCoordinate2D: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}
