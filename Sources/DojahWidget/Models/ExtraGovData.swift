//
//  GovData.swift
//  DojahWidget
//
//  Created by AbdulMujeeb on 22/05/2025.
//



public struct ExtraGovData: Codable  {
    
    var bvn: String? = nil

    var dl: String? = nil

    var nin: String? = nil

    var vnin: String? = nil
    
    public init(bvn: String? = nil, dl: String? = nil, nin: String? = nil, vnin: String? = nil) {
        self.bvn = bvn
        self.dl = dl
        self.nin = nin
        self.vnin = vnin
    }
    
    enum CodingKeys: String, CodingKey  {
        case bvn = "bvn"
        case dl = "dl"
        case nin = "nin"
        case vnin = "vnin"
    }
    

}
