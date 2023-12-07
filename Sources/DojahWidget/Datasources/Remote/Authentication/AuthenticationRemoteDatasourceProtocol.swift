//
//  AuthenticationRemoteDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 02/12/2023.
//

import Foundation

protocol AuthenticationRemoteDatasourceProtocol {
    func getPreAuthenticationInfo(params: DJParameters, completion: @escaping DJResultAction<DJPreAuthResponse>)
    func authenticate(params: DJParameters, completion: @escaping DJResultAction<DJAuthResponse>)
    func getIPAddress(completion: @escaping DJResultAction<DJIPAddress>)
    func saveIPAddress(params: DJParameters, completion: @escaping DJResultAction<DJIPAddressResponse>)
}
