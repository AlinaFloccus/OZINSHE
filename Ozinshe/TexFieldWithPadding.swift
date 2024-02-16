//
//  TexFieldWithPadding.swift
//  Ozinshe
//
//  Created by Alina Floccus on 28.11.2023.
//

import UIKit

@IBDesignable
class TexFieldWithPadding: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
