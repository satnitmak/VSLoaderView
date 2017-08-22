//
//  VSLoaderView.swift
//  LoaderView
//
//  Created by Sathyanarayanan V on 8/1/17.
//  Copyright © 2017 Sathyanarayanan V. All rights reserved.
//

import Foundation
import UIKit

class VSLoaderView: UIView {
    
    fileprivate var timer: Timer?
    fileprivate var animateViews = [UIView]()
    
    var animateBarCount = 6                         // total number of bars for animations
    var animationStep:CGFloat = 0.25                // vertical step for each animation bar
    var isBarDepthEnabled: Bool = true
    var depthFactor: CGFloat = 1
    var animateBarCornerRadius:CGFloat = 2
    var animationFrequency:TimeInterval = 200       // number of times each animation bar moves with animationStep in one second
    var animateBarColor: UIColor = UIColor.black    // color for each animation bar
    
    func startAnimation() {
        addAnimation()
    }
    
    func stopAnimation() {
        removeAnimation()
    }
}

extension VSLoaderView {
    
    fileprivate func addAnimation() {
        
        // 1: Set LoaderView properties
        backgroundColor = UIColor.clear
        clipsToBounds = true
        layer.cornerRadius = animateBarCornerRadius
        
        // 2: Initialize animation bars
        var count = animateBarCount
        animateViews.removeAll()
        while count > 0 {
            animateViews.append(UIView())
            count -= 1
        }
        
        // 3: Set correct frames for animation bars
        let barHeight = (frame.size.height/CGFloat(2 * (animateBarCount - 1)))
        for animateView in animateViews {
            animateView.backgroundColor = animateBarColor
            animateView.layer.cornerRadius = animateBarCornerRadius
            animateView.frame.size = CGSize(width: frame.size.width, height: barHeight * 1.5)
            animateView.frame.origin = CGPoint(x: 0, y: CGFloat(2 * count) * barHeight - barHeight/2)
            count += 1
            addSubview(animateView)
        }
        
        // 4: Start Animation Timer
        timer?.invalidate()
        timer = Timer.init(timeInterval: 1.0 / animationFrequency, target: self, selector: #selector(VSLoaderView.animator), userInfo: nil, repeats: true)
        let mainRunLoop:RunLoop = RunLoop.main
        mainRunLoop.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    @objc fileprivate func animator() {
        // Moves all animation bars by animationStep on each call
        // Once an animation bar goes out of the view frame, move it to the top of all the animation bars
        UIView.beginAnimations("vsAnimation", context: nil)
        UIView.setAnimationDuration(0)
        let barHeight = (frame.size.height/CGFloat(2 * (animateBarCount - 1)))
        for animateView in animateViews {
            if animateView.frame.origin.y > frame.size.height {
                animateView.frame.origin.y = -2 * barHeight
            } else {
                animateView.frame.origin.y += animationStep
            }
            if isBarDepthEnabled {
                animateView.alpha = (animateView.center.y < frame.size.height/2) ?
                    (frame.size.height/2 + animateView.center.y + barHeight/4) / frame.size.height :
                    (1 - (animateView.center.y - frame.size.height/2) / frame.size.height)
                animateView.frame.size.width = animateView.alpha * frame.size.width
                animateView.frame.origin.x = (frame.size.width - animateView.frame.size.width)/2
            }
        }
        UIView.commitAnimations()
    }
    
    fileprivate func removeAnimation() {
        timer?.invalidate()
        for animateView in animateViews {
            animateView.removeFromSuperview()
        }
    }
}
