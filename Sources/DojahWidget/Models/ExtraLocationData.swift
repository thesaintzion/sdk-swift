//
//  LocationRecord.swift
//  DojahWidget
//
//  Created by AbdulMujeeb on 22/05/2025.
//



public struct ExtraLocationData: Codable  {
    
    var latitude: String? = nil

    var longitude: String? = nil
    
    public init(longitude: String? = nil, latitude: String? = nil){
        self.latitude = latitude
        self.longitude = longitude
    }
    

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    public func isParamSet() -> Bool {
        return self != nil  && latitude != nil && longitude != nil
    }
}
