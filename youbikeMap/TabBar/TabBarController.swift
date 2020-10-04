//
//  TabBarController.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/4.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstViewController = ListViewController()
                
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)

        let secondViewController = MapViewController()

        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

        let tabBarList = [firstViewController, secondViewController]

        viewControllers = tabBarList
    }
    
    

}
