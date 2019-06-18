//
//  InternetsView.swift
//  Lunch Tyme
//
//  Created by rickb on 6/6/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import SwiftUI
import WebKit
import Combine

struct InternetsView : View, Identifiable {
	@State var canGoBack: Bool = false
	@State var canGoForward: Bool = false

	var id: URLRequest { return request }
	let request: URLRequest
	let webView = WKWebView()

	var body: some View {
		WebView(webView: webView, canGoBack: $canGoBack, canGoForward: $canGoForward)
			.navigationBarItems(leading:
				HStack(spacing: 20.0) {
					Button(action: {
						self.webView.goBack()
					}, label: {
						Image("ic_webBack")
					}).environment(\.isEnabled, canGoBack)
					Button(action: {
						self.webView.reload()
					}, label: {
						Image("ic_webRefresh")
					})
					Button(action: {
						self.webView.goForward()
					}, label: {
						Image("ic_webForward")
					}).environment(\.isEnabled, canGoForward)
				}
			)
	}

	init(request: URLRequest) {
		self.request = request
		webView.load(request)
	}
}

struct WebView: UIViewRepresentable {
	@Binding var canGoBack: Bool
	@Binding var canGoForward: Bool

	let webView: WKWebView
	var cancellables: [AnyCancellable]!

	init(webView: WKWebView, canGoBack: Binding<Bool>, canGoForward: Binding<Bool>) {
		self.webView = webView
		$canGoBack = canGoBack
		$canGoForward = canGoForward
		cancellables = [
			AnyCancellable(webView.publisher(for: \.canGoBack, options: [.new]).assign(to: \.canGoBack, on: self)),
			AnyCancellable(webView.publisher(for: \.canGoForward, options: [.new]).assign(to: \.canGoForward, on: self))
		]
	}

    func makeUIView(context: Context) -> WKWebView  {
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

#if DEBUG
struct InternetsView_Previews : PreviewProvider {
    static var previews: some View {
		InternetsView(request: URLRequest(url: URL(string: "https://www.bottlerocketstudios.com")!))
    }
}
#endif
