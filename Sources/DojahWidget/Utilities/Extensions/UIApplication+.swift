//
//  UIApplication+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UIApplication {
  func setRootViewController(_ vc : UIViewController){
      self.windows.first?.rootViewController = vc
      self.windows.first?.makeKeyAndVisible()
    }
}

func openSettingsApp() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
    }
    if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
}
