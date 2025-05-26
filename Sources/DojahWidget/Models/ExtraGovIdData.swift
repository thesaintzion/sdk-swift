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
    
    
    public func isAnyDataAvailable() -> Bool {
        return national?.isNotEmpty == true || passport?.isNotEmpty == true || dl?.isNotEmpty == true || voter?.isNotEmpty == true || nin?.isNotEmpty == true || others?.isNotEmpty == true
    }
    
    public func getFirstData()-> String{
        if national?.isNotEmpty == true {
            return national!
        }else if passport?.isNotEmpty == true {
            return passport!
        }else if dl?.isNotEmpty == true {
            return dl!
        }else if voter?.isNotEmpty == true {
            return voter!
        }else if nin?.isNotEmpty == true {
            return nin!
        }else if others?.isNotEmpty == true {
            return others!
        }
        return ""
    }
    
    public func getNgIdType()-> String{
        if national?.isNotEmpty == true {
            return DJGovernmentIDType.ngNational.rawValue
        }else if passport?.isNotEmpty == true {
            return DJGovernmentIDType.ngPass.rawValue
        }else if dl?.isNotEmpty == true {
            return DJGovernmentIDType.ngDLI.rawValue
        }else if voter?.isNotEmpty == true {
            return DJGovernmentIDType.ngVotersCard.rawValue
        }else if nin?.isNotEmpty == true {
            return DJGovernmentIDType.ngNINSlip.rawValue
        }else {
            return ""
        }
    }
    
    
}
