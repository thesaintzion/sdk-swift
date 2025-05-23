//
//  UserData.swift
//  DojahWidget
//
//  Created by AbdulMujeeb on 22/05/2025.
//



public struct UserBioData: Codable  {
    var firstName: String? = nil

    var lastName: String? = nil

    var dob: String? = nil

    var email: String? = nil
    
    public init(
        firstName: String? = nil,
        lastName: String? = nil,
        dob: String? = nil,
        email: String? = nil
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
        self.email = email
    }


    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case dob
        case email
    }
}
