//
//  WebViewController.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import WebKit

/// Not using SFSafariViewController since we're customizing the look
class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView { return view as! WKWebView }

// in a real app, I typically use an extension I wrote that uses an associated object on NSObject to store these w/o requiring you to define a variable for this.
    private var kvoObservers = [NSKeyValueObservation]()

    override func loadView() {
        view = WKWebView()
        webView.navigationDelegate = self

        let backButton = UIBarButtonItem(image: UIImage(named: "ic_webBack"), style: .plain, target: self, action: #selector(goBack))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "ic_webRefresh"), style: .plain, target: self, action: #selector(refresh))
        let forwardButton = UIBarButtonItem(image: UIImage(named: "ic_webForward"), style: .plain, target: self, action: #selector(goForward))
        navigationItem.leftBarButtonItems = [ backButton, refreshButton, forwardButton]

        kvoObservers.append(webView.observe(\.canGoBack, options: [.initial, .new]) { _, value in
            backButton.isEnabled = value.newValue ?? false
        })
        kvoObservers.append(webView.observe(\.canGoForward, options: [.initial, .new]) { webivew, value in
            forwardButton.isEnabled = value.newValue ?? false
        })

// in a real app, we'd pass this in
        webView.load(URLRequest(url: URL(string: "https://www.bottlerocketstudios.com")!))
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
