//
//  StationsModel.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import Foundation
import MapKit

struct Response: Decodable {
    
    var retCode: Int
    var values: [YouBikeStation]
    
    enum CodingKeys: String, CodingKey {
        case retCode = "retCode"
        case retVal = "retVal"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        retCode = try value.decode(Int.self, forKey: .retCode)
        let retValues = try value.decode([String: YouBikeStation].self, forKey: .retVal)
        var temps = [YouBikeStation]()
        for k in retValues.keys {
            if let value = retValues[k] {
                temps.append(value)
            }
        }
        temps.sort { (lhs, rhs) -> Bool in
            return lhs.sno > rhs.sno
        }
        values = temps
    }
}

struct ApiReturn: Codable {
    var retCode: Int
    var value: [String : YouBikeStation]

    enum CodingKeys: String, CodingKey {
        case retCode = "retCode"
        case value = "retVal"
    }
}

struct YouBikeStation: Codable, Hashable {
    var sno: String
    var sna: String
    var tot: String
    var sbi: String
    var sarea: String
    var mday: String
    var lat: String
    var lng: String
    var ar: String
    var sareaen: String
    var snaen: String
    var aren: String
    var bemp: String
    var act: String
}

extension YouBikeStation: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return
            lhs.sbi == rhs.sbi &&
            lhs.mday == rhs.mday &&
            lhs.bemp == rhs.bemp &&
            lhs.act == rhs.act
    }
    
    func setStationAnnotation() -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat) ?? 0.0, longitude: Double(lng) ?? 0.0)
        
        annotation.title = "站名：\(sna)"
        annotation.subtitle = """
                            目前腳踏車數量：\(sbi)
                            剩餘車位數量：\(bemp)
                            最後更新時間：\(mday)
                            """
    
        return annotation
    }
}
