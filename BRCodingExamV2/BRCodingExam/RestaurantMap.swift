//
//  RestaurantMap.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit
import MapKit

extension Notification.Name {
    static let restaurantMapRegionChangedNotification = Notification.Name("restaurantMapRegionChanged")
}

class RestaurantMapView: MKMapView, MKMapViewDelegate {

    var appManager: AppManager?

    var restaurants: [Restaurant]? {
        didSet {
            annotations.forEach { removeAnnotation($0) }
            restaurants?.compactMap { RestaurantAnnotation(restaurant: $0) }.forEach { addAnnotation($0) }
            showAnnotations(annotations, animated: false)
        }
    }
    var canShowCallout = false

    override required init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let restaurantAnnotation = annotation as? RestaurantAnnotation else {
            return nil
        }
        let annotationView = MKMarkerAnnotationView(annotation: restaurantAnnotation, reuseIdentifier: "Restaurant")
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoDark)
        annotationView.canShowCallout = canShowCallout
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let restaurant = (view.annotation as? RestaurantAnnotation)?.restaurant {
            appManager?.showDetail(for: restaurant)
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        NotificationCenter.default.post(name: .restaurantMapRegionChangedNotification, object: self)
    }

    var allRevealed: Bool {
        return annotations(in: visibleMapRect).count == annotations.count
    }
}

class RestaurantAnnotation: MKPointAnnotation {

    let restaurant: Restaurant

    required init?(restaurant: Restaurant) {
        guard let coordinate = restaurant.coordinate else {
            return nil
        }
        self.restaurant = restaurant
        super.init()
        self.coordinate = coordinate
        title = restaurant.name
        subtitle = restaurant.category
    }
}

extension Restaurant {

    var coordinate: CLLocationCoordinate2D? {
        if let lat = location?.lat, let lng = location?.lng {
            return CLLocationCoordinate2D(latitude: lat, longitude: lng)
        } else {
            return nil
        }
    }
}

class RestaurantMapViewController: UIViewController {

    var mapView: RestaurantMapView { return view as! RestaurantMapView }
    var canShowCallout = false {
        didSet {
            loadViewIfNeeded()
            mapView.canShowCallout = canShowCallout
        }
    }

    var restaurants: [Restaurant]? {
        didSet {
            loadViewIfNeeded()
            mapView.restaurants = restaurants
        }
    }

    override var appManager: AppManager? {
        didSet {
            loadViewIfNeeded()
            mapView.appManager = appManager
        }
    }

    override func loadView() {
        view = RestaurantMapView(frame: .zero)
        navigationItem.title = .restaurants
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem =  UIBarButtonItem(title: .revealAll, style: .plain, target: self, action: #selector(revealAll))
        navigationItem.leftBarButtonItem?.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(regionChanged), name: .restaurantMapRegionChangedNotification, object: mapView)
        regionChanged()
    }

    @objc func regionChanged() {
        navigationItem.leftBarButtonItem?.isEnabled = mapView.allRevealed == false
    }

    @objc func revealAll() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {

    func restaurantMapBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: .icon_map, style: .plain, target: self, action: #selector(showRestaurantMap))
    }

    @IBAction func showRestaurantMap() {
        appManager?.showRestaurantMap(with: self)
    }
}
