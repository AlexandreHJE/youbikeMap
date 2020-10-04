//
//  ListViewCell.swift
//  youbikeMap
//
//  Created by Alex Hu on 2020/10/1.
//  Copyright © 2020 Alex Hu. All rights reserved.
//

import UIKit
import RxSwift

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
    
    lazy var favoriteStatus: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    
    
    private var stationID: String?
    private(set) var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        contentView.addSubview(amount)
        contentView.addSubview(address)
        contentView.addSubview(favoriteStatus)
        
        NSLayoutConstraint.activate([
            favoriteStatus.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            favoriteStatus.widthAnchor.constraint(equalToConstant: contentView.frame.width/4.0),
            favoriteStatus.heightAnchor.constraint(equalToConstant: 20.0),
            favoriteStatus.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            title.heightAnchor.constraint(equalToConstant: 20.0),
            amount.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            amount.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 10.0),
            amount.trailingAnchor.constraint(equalTo: favoriteStatus.leadingAnchor),
            amount.heightAnchor.constraint(equalToConstant: 20.0),
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10.0),
            address.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            address.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            address.trailingAnchor.constraint(equalTo: favoriteStatus.leadingAnchor),
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(with station: ListViewViewModel.Station) {
        title.text = station.name
        amount.text = "\(station.emptySlot)"
        address.text = station.address
        favoriteStatus.text = station.isFavorite ? "❤️" : "🤍"
    }
    
}
