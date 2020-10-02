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
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(ListViewCell.self, forCellReuseIdentifier: reuseID)
            return tableView
        }()
        
        private let viewModel = ListViewViewModel()
        let disposeBag: DisposeBag = .init()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            viewModel.didUpdateDataRelay
                .subscribe(onNext: { [weak self] in self?.didUpdateData(data: $0) })
                .disposed(by: disposeBag)
            
            loadTableView()
    //        bindTableView()
        }
        
        private func bindTableView() {
            let station = Observable.just(viewModel.stations)
            station.bind(to: tableView.rx.items(cellIdentifier: reuseID, cellType: ListViewCell.self))
            { (row, element, cell) in
                cell.setContent(with: element)
            }.disposed(by: disposeBag)
            tableView.rx.modelSelected(String.self).subscribe(onNext: {
                print("tap index: \($0)")
                }).disposed(by: disposeBag)
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

    extension ListViewController: UITableViewDelegate {

    }

    extension ListViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return viewModel.stations.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let station = viewModel.stations[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? ListViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setContent(with: station)

            return cell
        }
    }

    extension ListViewController: ListViewCellDelegate {
        func cell(_ cell: ListViewCell, buttonTouchUpInside button: UIButton, stationID: String?) {
            
        }
    
}
