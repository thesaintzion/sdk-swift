//
//  ValidationType.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation

enum ValidationType {
    case email, 
         emailOrPhone,
         phoneNumber,
         password,
         confirmPassword,
         name, 
         amount,
         numeric, 
         address,
         dob,
         alphaNumeric
}
