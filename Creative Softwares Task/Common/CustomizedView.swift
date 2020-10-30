//
//  ConstomImageView.swift
//  NationalUIKit
//
//  Created by Mehsam Saeed on 25/09/2019.
//  Copyright © 2019 Incubasys. All rights reserved.
//

import Foundation
import UIKit
 public class CustomizedView: UIView {
     @IBInspectable public var cornerRadius: CGFloat = 10{
        didSet{
             configureCornerRadious(radious: cornerRadius)
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 3{
        didSet{
            configureborderWidth(radious: borderWidth)
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear{
        didSet{
             configureBorderColor(color: borderColor)
        }
    }
    @IBInspectable public var drawShadow: Bool = false{
        didSet{
            guard drawShadow else {return}
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[weak self] in
                guard let self = self else {return}
                self.applyShadow(color: self.shadowColor,shadowAlpha: self.shadowAlpha)
            }
        }
    }
    @IBInspectable public var shadowColor: UIColor = UIColor.clear{
        didSet{
            guard drawShadow else {return}
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[weak self] in
                guard let self = self else {return}
                self.applyShadow(color: self.shadowColor,shadowAlpha: self.shadowAlpha)
            }
        }
    }
    @IBInspectable public var shadowAlpha: Float = 10
    
    override public func awakeFromNib() {
        configureUI()
    }
    
    private func configureUI(){
        configureCornerRadious(radious: cornerRadius)
        configureBorderColor(color: borderColor)
        configureborderWidth(radious: borderWidth)
    }
    private func configureCornerRadious(radious:CGFloat){
         self.layer.cornerRadius = cornerRadius
    }
    private func configureborderWidth(radious:CGFloat){
          self.layer.borderWidth = borderWidth
    }
    private func configureBorderColor(color:UIColor){
        self.layer.borderColor = borderColor.cgColor
    }
    
    private func applyShadow(color:UIColor,shadowAlpha:Float){
        self.layer.applySketchShadow(color: color, alpha: shadowAlpha, blur: 10, spread: 0)
    }
    
}


extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
