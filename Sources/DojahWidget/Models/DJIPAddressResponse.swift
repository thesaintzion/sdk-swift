//
//  DJIPAddressResponse.swift
//
//
//  Created by Isaac Iniongun on 07/12/2023.
//

import Foundation

struct DJIPAddressResponse: Codable {
    let entity: DJIPAddressEntity?
}

struct DJIPAddressEntity: Codable {
    let lon: Double?
    let zip: String?
    let mobile, hosting: Bool?
    let entityAs, isp, query: String?
    let proxy: Bool?
    let lat: Double?
    let city, district, timezone, org: String?
    let country, countryCode, status, regionName: String?

    enum CodingKeys: String, CodingKey {
        case lon, zip, mobile, hosting
        case entityAs = "as"
        case isp, query, proxy, lat, city, district, timezone, org, country, countryCode, status, regionName
    }
}
