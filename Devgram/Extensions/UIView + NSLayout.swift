//
//  UIView + NSLayout.swift
//  Devgram
//
//  Created by ScaRiLiX on 9/28/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit

extension UIView
{
    func anchor(top: NSLayoutYAxisAnchor?,
                left: NSLayoutXAxisAnchor?,
                right: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                width: CGFloat?,
                height: CGFloat?,
                paddingFromTop: CGFloat,
                paddingFromLeft: CGFloat,
                paddingFromRight: CGFloat,
                paddingFromBottom: CGFloat)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top
        {
            self.topAnchor.constraint(equalTo: top, constant: paddingFromTop).isActive = true
        }
        
        if let left = left
        {
            self.leftAnchor.constraint(equalTo: left, constant: paddingFromLeft).isActive = true
        }
        
        if let right = right
        {
            self.rightAnchor.constraint(equalTo: right, constant: paddingFromRight).isActive = true
        }
        
        
        if let bottom = bottom
        {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingFromBottom).isActive = true
        }
        
        if let width = width
        {
            self.widthAnchor.constraint(equalToConstant: width)
        }
        
        if let height = height
        {
            self.heightAnchor.constraint(equalToConstant: height)
        }
        
    }
    
    func center(horizontal: NSLayoutXAxisAnchor?, vertical: NSLayoutYAxisAnchor?)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let horizontal = horizontal
        {
            self.centerXAnchor.constraint(equalTo: horizontal).isActive = true
        }
        
        if let vertical = vertical
        {
            self.centerYAnchor.constraint(equalTo: vertical).isActive = true
        }
    }
}
