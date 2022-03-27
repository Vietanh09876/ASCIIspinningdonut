//
//  CollectionViewCell.swift
//  ASCIISpinningDonut
//
//  Created by Nguyễn Việt Anh on 24/03/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        label.backgroundColor = .green
//        label.layer.borderWidth = 0.5
//        label.layer.borderColor = UIColor.blue.cgColor
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }

}
