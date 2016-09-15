//
//  Helpers.swift
//  Rewise
//
//  Created by Igor Nikolaev on 24/06/16.
//  Copyright © 2016 IgorNikolaev. All rights reserved.
//

import UIKit

protocol CanPaintBackground {
    func applyGradientOnBackground()
    func createGradientLayer(colors: [CGColor], frame: CGRect) -> CAGradientLayer
}

extension CanPaintBackground where Self: UIViewController {
    
    func applyGradientOnBackground() {
        let secondColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        let firstColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        
        let layer = createGradientLayer([firstColor.CGColor, secondColor.CGColor], frame: self.view.frame)
        self.view.layer.insertSublayer(layer, atIndex: 0)
    }
    
    func createGradientLayer(colors: [CGColor], frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = frame
        
        return gradientLayer
    }
}

extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _round(corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners, radius: radius)
        addBorder(mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor;
    }
    
}

private extension UIView {
    
    func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clearColor().CGColor
        borderLayer.strokeColor = borderColor.CGColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}

struct Constants {
    static let transitAnimationTime: Double = 0.4
    static let darkColor = UIColor(colorLiteralRed: 85.0/255.0, green: 97.0/255.0, blue: 112.0/255.0, alpha: 1.0)
    static let lightColor = UIColor(colorLiteralRed: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
}
