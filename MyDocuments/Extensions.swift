//
//  Extensions.swift
//  MyDocuments
//
//  Created by Егор Никитин on 02.04.2021.
//

import UIKit

extension UITextField {
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(
                                x: self.frame.minX,
                                y: self.frame.minY,
                                width: size,
                                height: self.frame.height))
        self.leftViewMode = .always
    }
}

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
