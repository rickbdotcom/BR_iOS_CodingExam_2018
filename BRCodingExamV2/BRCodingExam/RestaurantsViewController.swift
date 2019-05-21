//
//  RestaurantsViewController.swift
//  BRCodingExam
//
//  Created by rickb on 5/16/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantsViewController: UICollectionViewController, Activity {

    private var restaurants: [Restaurant]? {
        didSet {
            collectionView.reloadData()
        }
    }
    var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(loadRestaurantsIfNeeded), for: .valueChanged)

        navigationItem.rightBarButtonItem = restaurantMapBarButtonItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if restaurants == nil {
            loadRestaurantsIfNeeded()
        }
    }

    @objc private func loadRestaurantsIfNeeded() {
        guard loading == false else { return }
        appManager?.getRestaurants().done { [weak self] restaurants in
            self?.restaurants = restaurants
        }.show(activity: self).alertErrorHandler(self)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath).inject(value: restaurants?[indexPath.row])
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        appManager?.showDetail(for: restaurants?[indexPath.row])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let numberOfColumns: CGFloat = traitCollection.horizontalSizeClass == .compact ? 1.0 : 2.0
        flowLayout.itemSize.width = collectionView.bounds.width / numberOfColumns
    }

    func startActivity(context: Any?) {
        loading = true
        restaurants = nil
        collectionView.refreshControl?.beginRefreshing()
    }

    func stopActivity(context: Any?) {
        loading = false
        collectionView.refreshControl?.endRefreshing()
    }
}
