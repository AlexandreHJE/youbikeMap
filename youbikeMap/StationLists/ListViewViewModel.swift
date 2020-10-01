//
//  ListViewViewModel.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import Foundation
import RxRelay

class YouBikeStationsMapViewModel {
    
    let didUpdateDataRelay: PublishRelay<[YouBikeStation]> = .init()
    
    var stations = [YouBikeStation]() {
        didSet {
            didUpdateDataRelay.accept(stations)
        }
    }
    
    init() {
        processingDataToArray()
    }
    
    func processingDataToArray() {
        var temps = [YouBikeStation]()
        for station in stations {
            temps.append(station)
        }
        temps.sort { (lhs, rhs) -> Bool in
            return lhs.sno > rhs.sno
        }
        
        self.stations = temps
    }
    
}
