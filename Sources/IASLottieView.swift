//
//  IASLottieView.swift
//  IASLottie
//
//  Created by StPashik on 08.05.2024.
//

import UIKit
import Lottie

public typealias AnimationLoadedHandler = (_ :UIView) -> Void
public typealias AnimationDataLoaded = (_ loop: Bool, _ startFrame: CGFloat, _ endFrame: CGFloat) -> Void
public typealias AnimationCompletedHandler = (_ completed: Bool) -> Void

public class IASLottieView: UIView {
    
    @objc public var isAnimationLoaded: Bool = false
    @objc public var isAnimationLoop: Bool = false
    @objc public var startFrame: CGFloat = 0
    @objc public var endFrame: CGFloat = 100
        
    fileprivate var lottieAnimationView: LottieAnimationView!
    
    /// Initialize animation view with JSON file
    /// - Parameter filePath: path to the animation file in JSON format
    internal init(filePath: String, complete: AnimationLoadedHandler) {
        super.init(frame: .zero)
        
        lottieAnimationView = .init(filePath: filePath)
        
        setupLottieAnimationView()
        
        isAnimationLoaded = true
        complete(self)
    }
    
    /// Initialize animation view with .lottie file
    /// - Parameter lottiePath: path to the animation file in .lottie format
    internal init(lottiePath: String, complete: @escaping AnimationLoadedHandler) {
        super.init(frame: .zero)
        
        lottieAnimationView = .init(dotLottieFilePath: lottiePath) { [weak self] lottieAnimation, error in
            guard let weakSelf = self else { return }
            if let error = error {
                print(error.localizedDescription)
            }
            
            weakSelf.setupLottieAnimationView()
            
            weakSelf.isAnimationLoaded = true
            complete(weakSelf)
        }
    }
    
    internal init() {
        super.init(frame: .zero)
        
        lottieAnimationView = .init()
        
        setupLottieAnimationView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension IASLottieView {
    /// Start animation
    @objc class func isLottieConnected() -> Bool {
        guard NSClassFromString("Lottie.LottieAnimationView") != nil else { return false }

        return true
    }
}

public extension IASLottieView {
    /// Load animation to view from data
    /// - Parameter data: data with animation
    @objc func setAnimationData(_ data: Data, complete: @escaping AnimationDataLoaded) {
        guard let lottieAnimationView = lottieAnimationView else { return }
            
        DotLottieFile.loadedFrom(data: data, filename: "animation") { [weak self] result in
            guard case Result.success(let lottie) = result else { return }
            guard let weakSelf = self else { return }
            
            guard lottie.animations.count > 0 else { return }
            
            weakSelf.isAnimationLoop = lottie.animations[0].configuration.loopMode == .loop
            weakSelf.startFrame = lottie.animations[0].animation.startFrame
            weakSelf.endFrame = lottie.animations[0].animation.endFrame
            
            lottieAnimationView.loadAnimation(from: lottie)
            
            if weakSelf.isAnimationLoop {
                lottieAnimationView.play()
            }
            
            weakSelf.isAnimationLoaded = true
            
            complete(weakSelf.isAnimationLoop, weakSelf.startFrame, weakSelf.endFrame)
        }
    }
}

public extension IASLottieView {
    /// Start animation
    @objc func play() {
        guard let lottieAnimationView = lottieAnimationView else { return }
        
        lottieAnimationView.play()
    }
    
    /// Play animation with frame range
    /// - Parameters:
    ///   - start: first animation frame
    ///   - end: final animation frame
    ///   - loop: looped animations played in a range of
    @objc func play(from start: CGFloat, to end: CGFloat, loop: Bool, completion: AnimationCompletedHandler? = nil) {
        guard let lottieAnimationView = lottieAnimationView else { return }
        
        lottieAnimationView.play(fromFrame: start, toFrame: end, loopMode: loop ? .loop : .playOnce, completion: completion)
    }
    
    /// Pause animation
    @objc func pause() {
        guard let lottieAnimationView = lottieAnimationView else { return }
        
        lottieAnimationView.pause()
    }
    
    /// Full stop animation
    @objc func stop() {
        guard let lottieAnimationView = lottieAnimationView else { return }
        
        lottieAnimationView.stop()
    }
    
    /// Get animation current frame
    @objc func getCurrentFrame() -> CGFloat {
        guard let lottieAnimationView = lottieAnimationView else { return 0 }
        
        return lottieAnimationView.currentFrame
    }
    
    /// Setting animation in a specific frame
    /// - Parameter frame: Animation frame to set the position in
    @objc func setCurrentFrame(_ frame: CGFloat) {
        guard let lottieAnimationView = lottieAnimationView else { return }
        
        lottieAnimationView.currentFrame = frame
    }
}

fileprivate extension IASLottieView {
    func setupLottieAnimationView() {
        guard let lottieAnimationView = lottieAnimationView else { return }
        
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lottieAnimationView)
        
        var allConstraints: [NSLayoutConstraint] = []
        let horConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[lottieAnimationView]-(0)-|",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["lottieAnimationView": lottieAnimationView])
        allConstraints += horConstraint
        let vertConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[lottieAnimationView]-(0)-|",
                                                            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                            metrics: nil,
                                                            views: ["lottieAnimationView": lottieAnimationView])
        allConstraints += vertConstraint
        NSLayoutConstraint.activate(allConstraints)
    }
}
