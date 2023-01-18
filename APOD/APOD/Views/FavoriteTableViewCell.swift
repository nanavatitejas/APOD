//
//  FavoriteTableViewCell.swift
//  APOD
//
//  Created by Tejas Nanavati on 17/01/23.
//

import Foundation
import UIKit

class FavoriteTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let apodImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        // Configure the date label
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(dateLabel)
        
        // Configure the apod image view
        apodImageView.translatesAutoresizingMaskIntoConstraints = false
        apodImageView.contentMode = .scaleAspectFit
        contentView.addSubview(apodImageView)
        
        
        // Add constraints for the apod image view
        apodImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        apodImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        NSLayoutConstraint.activate([
           
            apodImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            apodImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
           
        ])
        
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: apodImageView.rightAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
        ])
        
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leftAnchor.constraint(equalTo: apodImageView.rightAnchor, constant: 8),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(favorite: Favorite) {
        titleLabel.text = favorite.title
        let dateFormatter = Helper.shared.dateFormatter

        if let date = dateFormatter.date(from: favorite.date ?? "") {
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        
        if let url = URL(string: favorite.url ?? "") {
            Helper.shared.downloadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.apodImageView.image = image
                }
            }
         
        }
    }
}
