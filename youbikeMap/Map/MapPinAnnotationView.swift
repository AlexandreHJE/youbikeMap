//
//  MapPinAnnotationView.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/3.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit
import MapKit

class MapPinAnnotationView: MKPinAnnotationView {
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        
        return button
    }()
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        rightCalloutAccessoryView = actionButton
    }
}
