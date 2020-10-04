//
//  ViewController.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit
import RxSwift
import MapKit

class ViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }

//    let reuseID = "ListCell"
//    lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(ListViewCell.self, forCellReuseIdentifier: reuseID)
//        return tableView
//    }()
//    
//    private let viewModel = ListViewViewModel()
//    let disposeBag: DisposeBag = .init()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        viewModel.didUpdateDataRelay
//            .subscribe(onNext: { [weak self] in self?.didUpdateData(data: $0) })
//            .disposed(by: disposeBag)
//        
//        loadTableView()
////        bindTableView()
//    }
//    
//    private func bindTableView() {
//        let station = Observable.just(viewModel.stations)
//        station.bind(to: tableView.rx.items(cellIdentifier: reuseID, cellType: ListViewCell.self))
//        { (row, element, cell) in
//            cell.setContent(with: element)
//        }.disposed(by: disposeBag)
//        tableView.rx.modelSelected(String.self).subscribe(onNext: {
//            print("tap index: \($0)")
//            }).disposed(by: disposeBag)
//    }
//    
//    private func loadTableView() {
//        view.addSubview(tableView)
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//        ])
//    }
//    
//    
//    private func didUpdateData(data: [YouBikeStation]) {
//        tableView.reloadData()
//    }
//
//}
//
//extension ViewController: UITableViewDelegate {
//
//}
//
//extension ViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return viewModel.stations.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let station = viewModel.stations[indexPath.row]
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? ListViewCell else { return UITableViewCell() }
//        cell.delegate = self
//        cell.setContent(with: station)
//
//        return cell
//    }
//}
//
//extension ViewController: ListViewCellDelegate {
//    func cell(_ cell: ListViewCell, buttonTouchUpInside button: UIButton, stationID: String?) {
//        
//    }
//
    
    var annotations = [MKPointAnnotation]()
    var selectedAnnotation: MKAnnotation?
    var youBikeData = [String: YouBikeStation]()
    var filteredData = [String: YouBikeStation]()
    private let viewModel = ListViewViewModel()
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
        stationMap.delegate = self
        //set initial location in Taipei 101
        let initialLocation = CLLocation(latitude: 25.0339639, longitude: 121.5622835)
        
        centerMapOnLocation(location: initialLocation)
        
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
    
//    private func bindTableView() {
//            viewModel.stations
//                .bind(to: tableView.rx.items(cellIdentifier: reuseID, cellType: ListViewCell.self)) { (row, element, cell) in
//                    cell.setContent(with: element)
//            }
//            .disposed(by: disposeBag)
//
//            tableView.rx
//                .modelSelected(YouBikeStation.self)
//                .subscribe(onNext: {
//                    print("tap index: \($0)")
//                })
//                .disposed(by: disposeBag)
//
//    //        let mapView = MKMapView()
//    //        viewModel.stations
//    //            .bind(to: mapView.rx.)
//        }
    
    private func makePins(){
        annotations = []
    
//        viewModel.stations.map({$0 as [MKAnnotation] })
//            .asDriver(onErrorJustReturn: [])
//            .drive(stationMap.rx.annotations(viewModel.stations))
//        annotations = (viewModel.stations).map({ $0.setStationAnnotation() })
        stationMap.addAnnotations(annotations)
    }
    
    private func didDataUpdate(data: [YouBikeStation]) {
        stationMap.removeAnnotations(annotations)
        makePins()
    }
    
}

extension ViewController: MKMapViewDelegate {
    
}
