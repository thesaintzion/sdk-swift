//
//  FontRegistration.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit
import CoreGraphics
import CoreText

public enum FontError: Swift.Error {
   case failedToRegisterFont
}

func registerFont(named name: String) throws {
    print("DojahWidget Bundle Url: \(DojahBundle.bundle.bundleURL)\n")

    if let fontURL = DojahBundle.bundle.url(forResource: name, withExtension: "ttf"){
        print("Front Url is \(fontURL)")
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, CTFontManagerScope.process, nil)
    }else{
        print("can't get Url")
        throw FontError.failedToRegisterFont
    }
//   guard let asset = NSDataAsset(name: "Fonts/\(name)", bundle: DojahBundle.bundle),
//      let provider = CGDataProvider(data: asset.data as NSData),
//      let font = CGFont(provider),
//      CTFontManagerRegisterGraphicsFont(font, nil) else {
//    throw FontError.failedToRegisterFont
//   }
}

struct DJFont {
   public let name: String

   private init(named name: String) {
      self.name = name
      do {
         try registerFont(named: name)
      } catch {
         let reason = error.localizedDescription
         fatalError("Failed to register font: \(reason)")
      }
   }

   static let light = DJFont(named: "Atakk-Light")
   static let regular = DJFont(named: "Atakk-Regular")
   static let bold = DJFont(named: "Atakk-Bold")
   static let semibold = DJFont(named: "Atakk-Semibold")
   static let medium = DJFont(named: "Atakk-Medium")
}
