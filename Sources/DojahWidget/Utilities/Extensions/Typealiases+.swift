//
//  Typealiases+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation
import UIKit

typealias NoParamHandler = () -> Void

typealias ParamHandler<T> = (T) -> Void

typealias StringParamHandler = (String) -> Void

typealias DoubleParamHandler = (Double) -> Void

typealias IntParamHandler = (Double) -> Void

typealias DoubleStringParamHandler = (String, String) -> Void

typealias TripleStringParamHandler = (String, String, String) -> Void

typealias StringIntParamHandler = (String, Int) -> Void

typealias IntStringParamHandler = (Int, String) -> Void

typealias NumericParamHandler = (any Numeric) -> Void

typealias ErrorParamHandler = (Error) -> Void

typealias UITableViewConformable = UITableViewDelegate & UITableViewDataSource

typealias UICollectionViewConformable = UICollectionViewDelegateFlowLayout & UICollectionViewDelegate & UICollectionViewDataSource

typealias UIImagePickerViewConformable = UIImagePickerControllerDelegate & UINavigationControllerDelegate

typealias StringURLParam = [String : URL]

typealias DJParameters = [String: Any]

typealias DJHeaderParameters = [String: String]

typealias DJResult<T: Codable> = Result<T, DJSDKError>

typealias DJResultAction<T: Codable> = (DJResult<T>) -> Void
