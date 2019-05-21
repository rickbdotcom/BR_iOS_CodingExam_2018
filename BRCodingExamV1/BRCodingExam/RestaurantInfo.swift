//
//  RestaurantInfoLabel.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import UIKit

class RestaurantInfoLabel: UILabel {

    var info: RestaurantInfo? {
        didSet {
            updateDisplay()
        }
    }

    convenience init(with info: RestaurantInfo) {
        self.init(frame: .zero)
        self.info = info
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showInfo)))
        textColor = .text
        numberOfLines = 0
        textAlignment = .left
        font = .regular(size: 16.0)
        updateDisplay()
    }

    private func updateDisplay() {
        text = info?.title
    }

    @objc func showInfo() {
        if let url = info?.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

enum RestaurantInfo {

    case address(lines: [String])
    case phone(number: String, formatted: String?)
    case twitter(handle: String)
    case facebook(id: String?, username: String?, name: String?)

    var title: String? {
        switch self {
        case .address(let lines):
            return lines.joined(separator: "\n")
        case .phone(let number, let formatted):
            return formatted ?? number
        case .twitter(let handle):
            return "@\(handle)"
        case .facebook(let id, let username, let name):
            return "@\(name ?? username ?? id ?? "")"
        }
    }

    var url: URL? {
        switch self {
        case .address(let lines):
            return lines.joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).flatMap { URL(string: "http://maps.apple.com/?daddr=\($0)") }
        case .phone(let number, _):
            return number.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed).flatMap { URL(string: "tel:\($0)") }
        case .twitter(let handle):
            return URL(string: "https://twitter.com/\(handle)")
        case .facebook(let id, let username, _):
            return URL(string: "https://facebook.com/\(id ?? username ?? "")")
        }
    }
}

extension Restaurant.Location {

    var addressInfo: RestaurantInfo? {
        return formattedAddress.flatMap { .address(lines: $0) }
    }
}

extension Restaurant.Contact {

    var phoneInfo: RestaurantInfo? {
        return phone.flatMap { .phone(number: $0, formatted: formattedPhone) }
    }

    var twitterInfo: RestaurantInfo? {
        return twitter.flatMap { .twitter(handle: $0) }

    }

    var facebookInfo: RestaurantInfo? {
        if facebook != nil || facebookUsername != nil {
            return .facebook(id: facebook, username: facebookUsername, name: facebookName)
        } else {
            return nil
        }
    }
}
