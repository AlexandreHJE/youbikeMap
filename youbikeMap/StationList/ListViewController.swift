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
    
    let districtList = [
        "一般",
        "最愛",
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
    
    let reuseID = "ListCell"
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ListViewCell.self, forCellReuseIdentifier: reuseID)
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        //        searchBar.delegate = self
        searchBar.searchTextField.inputView = self.picker
        
        //TODO: 讓 keyboard 隱藏
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44.0)) //原本想用 .zero 但這樣似乎會無法顯示，只好給個預設高度 44.0
        toolbar.setItems([doneButtonItem], animated: false)
        searchBar.searchTextField.inputAccessoryView = toolbar
        return searchBar
    }()
    
    lazy var doneButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hide))
        return item
    }()
    
    lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        //        picker.isHidden = true
        //        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        //        picker.backgroundColor = .gray
        
        return picker
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = UIImage(named: "refresh.png") {
            button.setImage(image, for: .normal)
        }
        return button
    }()
    
    private let viewModel = ListViewViewModel()
    let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews()
        bindTableView()
        let event = Observable<Void>.merge([
            Observable.just(Void()),
            Observable<Int>.timer(.seconds(0), period: .seconds(10), scheduler: MainScheduler.instance).flatMap({ _ in Observable.just(Void()) }),
            refreshButton.rx.tap.asObservable(),
        ])
        
        //naming 有問題
        let keywordEvent =
            Observable<String?>.merge([
                Observable.just(nil),
                doneButtonItem.rx.tap.flatMap({
                    return self.searchBar.rx.text.distinctUntilChanged().asObservable()
                })
            ])
        viewModel.fetchStations(event,
                                keywordEvent: keywordEvent)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func bindTableView() {
        viewModel.stations
            .bind(to: tableView.rx.items(cellIdentifier: reuseID, cellType: ListViewCell.self)) { (row, element, cell) in
                cell.setContent(with: element)
        }
        .disposed(by: disposeBag)
        
        //        searchBar.rx.text
        //            .orEmpty
        //            .distinctUntilChanged()
        //            .subscribe(onNext: { (text) in
        //                print("searchBar.rx.text.onNext: \(String(describing: text))")
        //            })
        //            .disposed(by: self.disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: {() in
                print("searchBar.rx.searchButtonClicked.onNext: text: \(String(describing: self.searchBar.text))")
            })
            .disposed(by: self.disposeBag)
        
        tableView.rx
            .modelSelected(ListViewViewModel.Station.self)
            .subscribe(onNext: {
                print("tap index: \($0.ID)")
                self.popMessage($0)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func loadViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        //        view.addSubview(picker)
        view.addSubview(refreshButton)
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: view.frame.width/5.0),
            refreshButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: refreshButton.safeAreaLayoutGuide.leadingAnchor),
            refreshButton.bottomAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            //            picker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            //            picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //            picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            //            picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
        let seeMap = UIAlertAction(title: "前往地圖查看位置", style: .default, handler: nil)
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
    
    @objc
    func hide() {
        picker.isHidden = true
    }
    
}

//extension ListViewController: UISearchBarDelegate {
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print("aaa")
//        picker.isHidden = false
//
//    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("Search Icon tapped")
//        picker.isHidden = !picker.isHidden
//    }
//
//}

extension ListViewController: UIPickerViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return districtList[row]
    }
}

extension ListViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return districtList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        searchBar.text = ""
        searchBar.searchTextField.text = districtList[row]
    }
}
