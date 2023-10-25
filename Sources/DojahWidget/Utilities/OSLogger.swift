//
//  File.swift
//  
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation
import os.log

final class OSLogger {
    static func debug(_ msg: String) {
        #if DEBUG
        os_log(.debug, "[DEBUG]: %s", msg)
        #endif
    }
    
    static func info(_ msg: String) {
        #if DEBUG
        os_log(.debug, "[INFO]: %s", msg)
        #endif
    }
    
    static func warning(_ msg: String) {
        #if DEBUG
        os_log(.fault, "[WARNING]: %s", msg)
        #endif
    }
    
    static func error(_ msg: String) {
        #if DEBUG
        os_log(.error, "[ERROR]: %s", msg)
        #endif
    }

}
