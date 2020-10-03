//
//  MapAnnotation.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/3.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = title
        self.coordinate = coordinate
    }
    
}
