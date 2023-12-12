//
//  GovernmentDataViewModel.swift
//
//
//  Created by Isaac Iniongun on 12/12/2023.
//

import Foundation

final class GovernmentDataViewModel: BaseViewModel {
    private let remoteDatasource: GovernmentDataRemoteDatasourceProtocol
    
    init(remoteDatasource: GovernmentDataRemoteDatasourceProtocol) {
        self.remoteDatasource = remoteDatasource
        super.init()
    }
}
