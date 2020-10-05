//
//  YoubikeDataManager.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import Foundation
import RxSwift

class DataManager {
    static let shared = DataManager()
}

//TODO: Change Observable to Maybe or Just(?) 
extension DataManager {
    func getYoubikeData() -> Observable<[String: YouBikeStation]> {
        return Observable.create { observer in
            let urlString = "https://tcgbusfs.blob.core.windows.net/blobyoubike/YouBikeTP.json"
            let url = URL(string: urlString)
            let task = URLSession.shared.dataTask(with: url!) {
                (jsonData, response, error)
                in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }
                let decoder = JSONDecoder()
                if let jData = jsonData, let apiReturn = try? decoder.decode(ApiReturn.self, from: jData)
                {
//                        self.saveYouBikeStations(apiReturn)
                    DispatchQueue.main.sync {
                        observer.onNext(apiReturn.value)
                        observer.onCompleted()
                        
                        var sections = [String: [YouBikeStation]]()
                        
                        let stations = apiReturn.value
                        var temps = [YouBikeStation]()
                        for k in stations.keys {
                            temps.append(stations[k]!)
                        }
                        
                        for station in temps {
                            if sections[station.sarea] == nil {
                                sections[station.sarea] = [station]
                            } else {
                                sections[station.sarea]?.append(station)
                            }
                        }
                    }
                }else{
                    print("JSON parse failed...")
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
