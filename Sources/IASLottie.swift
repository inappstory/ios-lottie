//
//  IASLottie.swift
//  IASLottie
//
//  Created by StPashik on 08.05.2024.
//

import UIKit
import Lottie

public var IASLottieVersion: String {
    get {
        "Farmework info:\n\t-version: \(IASLottie.VersionSDK)\n\t-build: \(IASLottie.BuildSDK)"
    }
}

public class IASLottie: NSObject {
    public static let VersionSDK: String = "0.1.0"
    public static let BuildSDK: String = "40"
    
    @objc public class func getLottieViewWith(_ path: String, complete: @escaping AnimationLoadedHandler) -> UIView {
        let fileURL = URL(fileURLWithPath: path)
        
        if fileURL.pathExtension == "lottie" {
            return IASLottieView(lottiePath: path, complete: complete)
        }
        
        return IASLottieView(filePath: path, complete: complete)
    }
    
    @objc public class func getLottieView() -> UIView {
        return IASLottieView()
    }
}
