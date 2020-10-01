//
//  ListViewViewModel.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import Foundation
import RxRelay

class ListViewViewModel {
    
    let didUpdateDataRelay: PublishRelay<[YouBikeStation]> = .init()
    
    var stations = [YouBikeStation]() {
        didSet {
            didUpdateDataRelay.accept(stations)
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(processingDataToArray(_:)), name: NSNotification.Name(rawValue: "Get Data"), object: nil)
    }
    
    @objc
    func processingDataToArray(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            //print(userInfo)
            //print(userInfo["stations"])
            if let stations = userInfo["stations"] as? [String: YouBikeStation] {
                var temps = [YouBikeStation]()
                for k in stations.keys {
                    temps.append(stations[k]!)
                }
                temps.sort { (lhs, rhs) -> Bool in
                    return lhs.sno > rhs.sno
                }
                
                self.stations = temps
            }
        }
    }
    
}
