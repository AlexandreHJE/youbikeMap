//
//  MapViewViewModel.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/2.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import Foundation
import MapKit
import RxRelay
import RxSwift

class MapViewViewModel {
    
    let stations: PublishRelay<[MKAnnotation]> = .init()
    //Observabel, Subscriber
    
    private let bag = DisposeBag()
    
    @objc
    func fetchStations() {
        Observable<Int>
            .timer(.seconds(0), period: .seconds(5), scheduler: MainScheduler.instance)
            .flatMap { (_) -> Observable<[String: YouBikeStation]> in
                return DataManager.shared.getYoubikeData()
        }
        .map({ (stations) -> [MKAnnotation] in
            var temps = [MKAnnotation]()
            for k in stations.keys {
                temps.append((stations[k]?.setStationAnnotation())!)
                
            }
            return temps
        })
            .subscribe(onNext: { (stations) in
                self.stations.accept(stations)
            })
            .disposed(by: bag)
    }
}
