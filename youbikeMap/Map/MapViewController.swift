//
//  MapViewController.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/2.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController {

    var annotations = [MKPointAnnotation]()
    var selectedAnnotation: MKAnnotation?
    var youBikeData = [String: YouBikeStation]()
    var filteredData = [String: YouBikeStation]()
    private let viewModel = ListViewViewModel()
    
    let districtList = [
        "中正區",
        "大同區",
        "中山區",
        "松山區",
        "大安區",
        "萬華區",
        "信義區",
        "士林區",
        "北投區",
        "內湖區",
        "南港區",
        "文山區"
    ]
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchBar
    }()
    
    lazy var stationMap: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        
        return map
    }()
    
    let regionRad: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    private func setUIComponents() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stationMap.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stationMap.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stationMap.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stationMap.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
