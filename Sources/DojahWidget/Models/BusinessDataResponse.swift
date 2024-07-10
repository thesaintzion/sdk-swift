//
//  BusinessDataResponse.swift
//
//
//  Created by Isaac Iniongun on 13/02/2024.
//

import Foundation

// MARK: - BusinessDataResponse
struct BusinessDataResponse: Codable {
    let companyName, rcNumber: String?
    let dateOfRegistration: String?
    let address, typeOfCompany, business, status: String?

    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case rcNumber = "rc_number"
        case dateOfRegistration = "date_of_registration"
        case address
        case typeOfCompany = "type_of_company"
        case business, status
    }
}
