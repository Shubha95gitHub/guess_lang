//
//  TVCell.swift
//  TableVwCellExpandCollapse
//
//  Created by MAC on 07/11/24.
//

import UIKit

class TVCell: UITableViewCell {

    let contentLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(contentLabel)
            NSLayoutConstraint.activate([
                contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}
