//
//  AuthenticationRemoteDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

protocol AuthenticationRemoteDatasourceProtocol {
    func getPreAuthenticationInfo(params: Parameters, completion: @escaping DJResultAction<DJPreAuthResponse>)
}
