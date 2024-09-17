//
//  CustomBundle.swift
//  DojahWidget
//
//  Created by AbdulMujeeb Shittu on 15/09/2024.
//

import Foundation


class DojahBundle{
    public static var bundle: Bundle {
      #if SWIFT_PACKAGE
      return Bundle.module
      #else
        return BundleLocator.bundle
//        return Bundle(for: DojahWidgetSDK.self)
      #endif
    }
}

private class BundleLocator {
    static var bundle: Bundle {
        let bundleName = "DojahWidgetResources" // Replace with the name of the generated bundle.
        let candidates = [
            Bundle.main.resourceURL,
            Bundle.main.bundleURL,
            Bundle(for: BundleLocator.self).resourceURL,
            Bundle(for: BundleLocator.self).bundleURL
        ]
        
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        
        fatalError("Unable to locate bundle named \(bundleName)")
    }
}
