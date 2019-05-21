//
//  RestaurantCell.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit

class RestaurantCell: UICollectionViewCell {

// I finally started using IUO on IBOutlets, at least when the outlets should never be nil. However, Apple's default of weak + IUO is absolutely wrong
// weak means "this can totally be nil" and IUO means "this can never ever be nil"
    @IBOutlet var imageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    var restaurant: Restaurant! {
        didSet {
            nameLabel.text = restaurant.name
            categoryLabel.text = restaurant.category
            imageView.loadImage(from: restaurant.backgroundImageURL)
        }
    }
}
