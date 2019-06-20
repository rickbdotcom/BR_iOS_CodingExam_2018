//
//  ContentView.swift
//  Lunch Tyme
//
//  Created by rickb on 6/5/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @State var selection = 1
 
    var body: some View {

        TabbedView(selection: $selection){

            Text("First View")
			.font(.title)
			.tabItemLabel(VStack {
				Image("tab_lunch")
				Text("lunch")
			}).tag(0)

			NavigationView {
				InternetsView(request: URLRequest(url: URL(string: "https://www.bottlerocketstudios.com")!))
			}
			.tabItemLabel(VStack {
				Image("tab_internets")
				Text("internets")
			}).tag(1)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
