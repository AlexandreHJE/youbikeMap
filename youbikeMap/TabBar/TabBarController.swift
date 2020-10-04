//
//  TabBarController.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/4.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit
import CoreLocation

class TabBarController: UITabBarController {

    
    let firstViewController = ListViewController()
    let secondViewController = MapViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)

        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

        let tabBarList = [firstViewController, secondViewController]
        firstViewController.delegate = self
        
        viewControllers = tabBarList
    }
}

extension TabBarController: ListViewControllerDelegate {
    func didSelectStation(_ station: ListViewViewModel.Station) {
        selectedViewController = secondViewController
        let coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
        secondViewController.focusOnSelectedStation(with: coordinate)
        
    }
}
