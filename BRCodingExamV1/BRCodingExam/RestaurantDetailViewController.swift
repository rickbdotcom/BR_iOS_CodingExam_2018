//
//  RestaurantDetailViewController.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let showRestaurantDetailNotification = Notification.Name("showRestaurantDetail")
}

class RestaurantDetailViewController: UIViewController {

    @IBOutlet var mapView: RestaurantMapView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var stackView: UIStackView!

    var restaurant: Restaurant! {
        didSet {
            loadViewIfNeeded()

            mapView.restaurants = [restaurant]
            nameLabel.text = restaurant.name
            categoryLabel.text = restaurant.category

            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            if let addressInfo = restaurant.location?.addressInfo {
                stackView.addArrangedSubview(RestaurantInfoLabel(with: addressInfo))
            }

            if let phoneInfo = restaurant.contact?.phoneInfo {
                stackView.addArrangedSubview(RestaurantInfoLabel(with: phoneInfo))
            }

            if let twitterInfo = restaurant.contact?.twitterInfo {
                stackView.addArrangedSubview(RestaurantInfoLabel(with: twitterInfo))
            }
            if let facebookInfo = restaurant.contact?.facebookInfo {
                stackView.addArrangedSubview(RestaurantInfoLabel(with: facebookInfo))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        navigationItem.rightBarButtonItem = restaurantMapBarButtonItem()
    }
}
