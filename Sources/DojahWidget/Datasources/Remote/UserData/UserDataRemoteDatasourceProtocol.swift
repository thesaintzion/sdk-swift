//
//  UserDataRemoteDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 25/01/2024.
//

import Foundation

protocol UserDataRemoteDatasourceProtocol {
    func saveUserData(params: DJParameters, completion: @escaping DJResultAction<SuccessEntityResponse>)
}
