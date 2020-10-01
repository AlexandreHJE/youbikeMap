//
//  ViewController.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }

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

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
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

extension ViewController: ListViewCellDelegate {
    func cell(_ cell: ListViewCell, buttonTouchUpInside button: UIButton, stationID: String?) {
        
    }
    
    
}
