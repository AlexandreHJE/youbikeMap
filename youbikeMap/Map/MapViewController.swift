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
import RxMKMapView

class MapViewController: UIViewController {

    var annotations = [MKPointAnnotation]()
    var selectedAnnotation: MKAnnotation?
    var youBikeData = [String: YouBikeStation]()
    var filteredData = [String: YouBikeStation]()
    private let viewModel = MapViewViewModel()
//    private let viewModel = ListViewViewModel()
    private let disposeBag: DisposeBag = .init()
    
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
        
        setUIComponents()
        //set initial location in Taipei 101
        let initialLocation = CLLocation(latitude: 25.0339639, longitude: 121.5622835)
        viewModel.fetchStations()
        centerMapOnLocation(location: initialLocation)
        makePins()
    }
    
    private func makePins(){
        annotations = []
        viewModel.stations
            .asDriver(onErrorJustReturn: [])
            .drive(stationMap.rx.annotations)
            .disposed(by: disposeBag)

        stationMap.rx.willStartLoadingMap
            .asDriver()
            .drive(onNext: {
            print("map started loading")
            })
            .disposed(by: disposeBag)
    }
    
    private func setUIComponents() {
        
        view.addSubview(searchBar)
        view.addSubview(stationMap)
        
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
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRad, longitudinalMeters: regionRad)
        stationMap.setRegion(coordinateRegion, animated: true)
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

extension MapViewController: MKMapViewDelegate {
    
}
