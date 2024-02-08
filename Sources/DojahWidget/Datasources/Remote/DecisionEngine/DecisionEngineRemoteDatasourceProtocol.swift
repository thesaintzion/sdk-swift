//
//  DecisionEngineRemoteDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 08/02/2024.
//

import Foundation

protocol DecisionEngineRemoteDatasourceProtocol {
    func makeVerificationDecision(completion: @escaping DJResultAction<EntityResponse<DecisionResponse>>)
}
