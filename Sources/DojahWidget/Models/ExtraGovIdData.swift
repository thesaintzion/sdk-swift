//
//  GovId.swift
//  DojahWidget
//
//  Created by AbdulMujeeb on 22/05/2025.
//




public struct ExtraGovIdData: Codable  {
    
    var national: String? = nil

    var passport: String? = nil

    var dl: String? = nil

    var voter: String? = nil

    var nin: String? = nil

    var others: String? = nil
    
    public init(national: String? = nil, passport: String? = nil, dl: String? = nil, voter: String? = nil, nin: String? = nil, others: String? = nil) {
        self.national = national
        self.passport = passport
        self.dl = dl
        self.voter = voter
        self.nin = nin
        self.others = others
    }
    
    enum CodingKeys: String, CodingKey {
        case national = "national_id"
        case passport
        case dl
        case voter
        case nin
        case others
    }
}
