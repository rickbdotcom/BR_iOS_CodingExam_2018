//
//  RestaurantsView.swift
//  Lunch Tyme
//
//  Created by rickb on 6/6/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import SwiftUI

extension Restaurant: Identifiable {
	var id: String { return name ?? "" }
}

struct RestaurantsView : View {
	@ObjectBinding var restaurants: RestaurantsModel

    var body: some View {
       List(restaurants.restaurants) { restaurant in
			Text(restaurant.id)
		}
    }
}

#if DEBUG
struct RestaurantsView_Previews : PreviewProvider {
    static var previews: some View {
        RestaurantsView(restaurants: RestaurantsModel())
    }
}
#endif
