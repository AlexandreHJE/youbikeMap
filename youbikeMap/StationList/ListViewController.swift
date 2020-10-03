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
        
        loadTableView()
        bindTableView()
        
        viewModel.fetchStations()
    }
        
    private func bindTableView() {
        viewModel.stations
            .bind(to: tableView.rx.items(cellIdentifier: reuseID, cellType: ListViewCell.self)) { (row, element, cell) in
                cell.setContent(with: element)
        }
        .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(YouBikeStation.self)
            .subscribe(onNext: {
                print("tap index: \($0)")
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
        
        
        private func didUpdateData(data: [YouBikeStation]) {
            tableView.reloadData()
        }
    }

    extension ListViewController: ListViewCellDelegate {
        func cell(_ cell: ListViewCell, buttonTouchUpInside button: UIButton, stationID: String?) {
            
        }
    
}
