//
//  ExtraUserData.swift
//  DojahWidget
//
//  Created by AbdulMujeeb on 22/05/2025.
//



public struct ExtraUserData:Codable {
    var userData: UserBioData? = nil

    var govData: ExtraGovData? = nil

    var govId: ExtraGovIdData? = nil

    var location: ExtraLocationData? = nil

    var businessData: ExtraBusinessData? = nil

    var address: String? = nil

    var metadata: [String:Any]? = nil
    
    public init(userData: UserBioData? = nil, govData: ExtraGovData? = nil, govId: ExtraGovIdData? = nil, location: ExtraLocationData? = nil, businessData: ExtraBusinessData? = nil, address: String? = nil, metadata: [String : Any]? = nil) {
        self.userData = userData
        self.govData = govData
        self.govId = govId
        self.location = location
        self.businessData = businessData
        self.address = address
        self.metadata = metadata
    }
    
    enum CodingKeys: CodingKey {
        case userData
        case govData
        case govId
        case location
        case businessData
        case address
    }

}
