//
//  RestaurantsViewController.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit

/// In a real, complex app I'd use a more sophisticated approach with proper data model objects, managers, dependency injection, endpoint abstractions, promises, etc,
class RestaurantsViewController: UICollectionViewController {

    private var restaurants: [Restaurant]? {
        didSet {
            collectionView.reloadData()
        }
    }
    private var downloadTask: URLSessionTask?
    private var session = URLSession(configuration: .default)

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(loadRestaurants), for: .valueChanged)

        navigationItem.rightBarButtonItem = restaurantMapBarButtonItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if restaurants == nil {
            loadRestaurants()
        }
    }

    @objc private func loadRestaurants() {
        guard downloadTask == nil else { return }
        restaurants = nil
        collectionView.refreshControl?.beginRefreshing()

        downloadTask = session.getRestaurants { [weak self] response, error in
            self?.collectionView?.refreshControl?.endRefreshing()
            self?.restaurants = response?.restaurants
            self?.downloadTask = nil
            if let error = error {
                self?.show(error: error)
            }
        }
        downloadTask?.resume()
    }

    private func show(error: Error) {
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)

    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
// An aside on force unwrapping and IUOs, coming from Obj-C initially I found the idea of crashing on nil abhorrent, but I have
// slowly come around to the "crash early and often" Swift approach of ensuring program correctness by using these types of
// crashes to indicate non-recoverable, this should never happen, programming errors that should be caught immediately in testing
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RestaurantCell
        cell.restaurant = restaurants![indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .showRestaurantDetailNotification, object: restaurants![indexPath.row])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
// adjust layout if we're running on iPhone vs iPad, i.e. compact vs regular horizontal size class
// the two column thing was a little unclear, if it also meant landscape on iPhone we'd have to introduce some more logic here
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let numberOfColumns: CGFloat = traitCollection.horizontalSizeClass == .compact ? 1.0 : 2.0
        // we'd also need to take into account section insets and line spacing if they weren't 0
        flowLayout.itemSize.width = collectionView.bounds.width / numberOfColumns
    }
}
