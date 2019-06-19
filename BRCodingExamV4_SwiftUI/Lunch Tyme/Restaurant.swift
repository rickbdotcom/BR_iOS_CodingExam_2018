//
//  Restaurant.swift
//  BRCodingExam
//
//  Created by rickb on 5/20/19.
//  Copyright © 2019 rickb. All rights reserved.
//

import Foundation

struct Restaurant: Decodable {

    let name: String?
    let backgroundImageURL: URL?
    let category: String?
    let contact: Contact?
    let location: Location?

    struct Contact: Decodable {
        let phone: String?
        let formattedPhone: String?
        let twitter: String?
        let facebook: String?
        let facebookUsername: String?
        let facebookName: String?
    }

    struct Location: Decodable {
        let address: String?
        let crossStreet: String?
        let lat: Double?
        let lng: Double?
        let postalCode: String?
        let cc: String?
        let city: String?
        let state: String?
        let country: String?
        let formattedAddress: [String]?
    }
}
