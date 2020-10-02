//
//  ListViewCell.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit
import RxSwift

protocol ListViewCellDelegate {
    
    func cell(_ cell: ListViewCell, buttonTouchUpInside button: UIButton, stationID: String?)
}

class ListViewCell: UITableViewCell {

    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var amount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var address: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        
        return button
    }()
    
    
    
    private var stationID: String?
    private(set) var bag = DisposeBag()
    var delegate: ListViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        contentView.addSubview(amount)
        contentView.addSubview(address)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            favoriteButton.widthAnchor.constraint(equalToConstant: contentView.frame.width/4.0),
            favoriteButton.heightAnchor.constraint(equalToConstant: 20.0),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            title.heightAnchor.constraint(equalToConstant: 20.0),
            amount.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            amount.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 10.0),
            amount.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor),
            amount.heightAnchor.constraint(equalToConstant: 20.0),
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10.0),
            address.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            address.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            address.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor),
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setContent(with station: YouBikeStation) {
        title.text = station.sna
        amount.text = station.bemp
        address.text = station.ar
        favoriteButton.setTitle("加入最愛", for: .normal)
        favoriteButton.setTitleColor(.blue, for: .normal)
    }
    
}
