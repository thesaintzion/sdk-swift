//
//  DJEventName.swift
//
//
//  Created by Isaac Iniongun on 07/12/2023.
//

import Foundation

enum DJEventName: String, Codable {
    case stepCompleted = "step_completed"
    case verificationTypeSelected = "verification_type_selected"
    case verificationModeSelected = "verification_mode_selected"
    case governmentImageCollected = "government_image_collected"
    case customerGovernmentDataCollected = "customer_government_data_collected"
    case countrySelected = "country_selected"
    case amlCheck = "aml_check"
    case phoneNumberValidation = "phone_number_validation"
    case emailCollected = "email_collected"
    case customerBusinessDataCollected = "customer_business_data_collected"
    case stepFailed = "step_failed"
    case signature
    case verificationsPageConfigCollected = "verifications_page_config_collected"
}
