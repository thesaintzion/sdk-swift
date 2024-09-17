//
//  LoaderViewController.swift
//
//
//  Created by Isaac Iniongun on 08/12/2023.
//

import UIKit
import Lottie

final class LoaderViewController: UIViewController {
    
    private let animationView = LottieAnimationView(
        name: "circle-loader",bundle: DojahBundle.bundle
    ).withSize(width: 200, height: 150)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInterfaceStyle()
        
        with(animationView) {
            addSubview($0)
            $0.centerInSuperview()
            $0.loopMode = .loop
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }

}
