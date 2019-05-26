//
//  WebViewController.swift
//  BRCodingExam
//
//  Created by rickb on 5/16/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import WebKit
import ExtraKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView { return view as! WKWebView }

    convenience init(with url: URL) {
        self.init(with: URLRequest(url: url))
    }
    
    convenience init(with urlRequest: URLRequest) {
        self.init()
        load(with: urlRequest)
        tabBarItem = UITabBarItem(title: .tab_internets, image: .tab_internets, tag: 0)
    }

    func load(with urlRequest: URLRequest) {
        loadViewIfNeeded()
        webView.load(urlRequest)
    }

    override func loadView() {
        view = WKWebView()
        webView.navigationDelegate = self

        let backButton = UIBarButtonItem(image: .ic_webBack, style: .plain, target: self, action: #selector(goBack))
        let refreshButton = UIBarButtonItem(image: .ic_webRefresh, style: .plain, target: self, action: #selector(refresh))
        let forwardButton = UIBarButtonItem(image: .ic_webForward, style: .plain, target: self, action: #selector(goForward))
        navigationItem.leftBarButtonItems = [ backButton, refreshButton, forwardButton]

        kvoObservations.add(webView.observe(\.canGoBack, options: [.initial, .new]) { _, value in
            backButton.isEnabled = value.newValue ?? false
        })
        kvoObservations.add(webView.observe(\.canGoForward, options: [.initial, .new]) { webivew, value in
            forwardButton.isEnabled = value.newValue ?? false
        })
    }

    @IBAction func goBack() {
       _ = webView.goBack()
    }

    @IBAction func refresh() {
        _ = webView.reload()
    }

    @IBAction func goForward() {
        _ = webView.goForward()
    }
}
