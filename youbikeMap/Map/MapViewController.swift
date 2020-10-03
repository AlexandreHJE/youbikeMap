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
        stationMap.delegate = self
        centerMapOnLocation(location: initialLocation)
        makePins()
    }
    
    private func makePins(){
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

    private func popMessage(_ station: YouBikeStation) {
           let alertController = UIAlertController(title: "請選擇欲操作的行為", message: "站點：\(station.sna)", preferredStyle: .alert)
           
           
           var favoriteAction = "加入最愛"
           
           if let array = UserDefaults.standard.array(forKey: "favoriteIDs") as? [String] {
               if Set([station.sno]).isSubset(of: Set(array)) {
                   favoriteAction = "移除最愛"
               }
           }
           
           let addFavorite = UIAlertAction(title: favoriteAction, style: .default, handler: { _ in self.addToFavorite(station.sno)})
           
           let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
           alertController.addAction(addFavorite)
           alertController.addAction(cancel)
        
           present(alertController, animated: true, completion: nil)
       }
    
       func addToFavorite(_ stationID: String) {
           if var array = UserDefaults.standard.array(forKey: "favoriteIDs") as? [String] {
               var favSet = Set(array)
               if Set([stationID]).isSubset(of: favSet) {
                   favSet.remove(stationID)
                   array = Array(favSet)
               } else {
                   array.append(stationID)
               }
               UserDefaults.standard.set(array, forKey: "favoriteIDs")
           } else {
               UserDefaults.standard.set([stationID], forKey: "favoriteIDs")
           }
       }
    
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "MapPinAnnotationView"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {

            annotationView = MapPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)

            annotationView?.canShowCallout = true
            
            let subtitleText = annotation.subtitle ?? "修復中..."

            let subtitleLabel = UILabel()
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            subtitleLabel.text = subtitleText
            subtitleLabel.numberOfLines = 0
            annotationView?.detailCalloutAccessoryView = subtitleLabel
            annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
        
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self, action: #selector(didClickDetailDisclosure(_:)), for: .touchUpInside)
            
            annotationView?.rightCalloutAccessoryView = rightButton
        }

        return annotationView
    }
    
    @objc
    func didClickDetailDisclosure(_ button: UIButton) {
//        popMessage(button.superview?.value(forKey: "stationID") as! YouBikeStation)
//        print(button.superview?.value(forKey: "stationID") as! YouBikeStation)
    }
}
