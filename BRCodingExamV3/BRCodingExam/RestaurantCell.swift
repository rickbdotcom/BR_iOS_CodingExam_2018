//
//  RestaurantCell.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantCell: UICollectionViewCell, RestaurantContainer {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    var restaurant: Restaurant? {
        didSet {
            nameLabel.text = restaurant?.name
            categoryLabel.text = restaurant?.category
            imageView.sd_setImage(with: restaurant?.backgroundImageURL)
        }
    }
}
