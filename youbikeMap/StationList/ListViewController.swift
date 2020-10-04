//
//  ListViewController.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {

    let reuseID = "ListCell"
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListViewCell.self, forCellReuseIdentifier: reuseID)
        return tableView
    }()
    
    
    
    private let viewModel = ListViewViewModel()
    let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFavorites()
        loadTableView()
        bindTableView()
        
        viewModel.fetchStations()
        
    }
    
    private func loadFavorites() {
        UserDefaults.standard.rx
        .observe([String].self, "favoriteIDs")
        .subscribe(onNext: { (value) in
            if let value = value {
                self.tableView.reloadData()
            }
        })
        .disposed(by: disposeBag)
        
    }
    
    private func bindTableView() {
        viewModel.stations
            .bind(to: tableView.rx.items(cellIdentifier: reuseID, cellType: ListViewCell.self)) { (row, element, cell) in
                cell.setContent(with: element)
        }
        .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(ListViewViewModel.Station.self)
            .subscribe(onNext: {
                print("tap index: \($0.ID)")
                self.popMessage($0)
            })
            .disposed(by: disposeBag)
    }
        
    private func loadTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func popMessage(_ station: ListViewViewModel.Station) {
        let alertController = UIAlertController(title: "請選擇欲操作的行為", message: "站點：\(station.name)", preferredStyle: .alert)
        
        
        var favoriteAction = "加入最愛"
        
        if let array = UserDefaults.standard.array(forKey: "favoriteIDs") as? [String] {
            if Set([station.ID]).isSubset(of: Set(array)) {
                favoriteAction = "移除最愛"
            }
        }
        
        let addFavorite = UIAlertAction(title: favoriteAction, style: .default, handler: { _ in self.addToFavorite(station.ID)})
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let seeMap = UIAlertAction(title: "前往地圖看位置", style: .default, handler: nil)
        alertController.addAction(addFavorite)
        alertController.addAction(cancel)
        alertController.addAction(seeMap)
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
