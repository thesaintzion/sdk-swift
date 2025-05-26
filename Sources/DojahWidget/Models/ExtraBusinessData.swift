//
//  BusinessDataRecord.swift
//  DojahWidget
//
//  Created by AbdulMujeeb on 22/05/2025.
//



public struct ExtraBusinessData: Codable  {

    var cac: String? = nil
    
    public init(cac: String? = nil) {
        self.cac = cac
    }
    
    enum CodingKeys: String, CodingKey {
        case cac
    }
    
    public func isFilled() -> Bool {
        return cac?.isNotEmpty == true
    }

}
