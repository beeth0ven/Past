//
//  UIKit+.swift
//  Past
//
//  Created by luojie on 16/3/30.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get { return layer.borderColor?.uiColor }
        set { layer.borderColor = newValue?.CGColor }
    }
}

extension CGColor {
    var uiColor: UIColor {
        return UIColor(CGColor: self)
    }
}

extension UITableView {
    func dequeueReusableCellWithType<T: UITableViewCell>(_: T.Type) -> T? {
        let identifier = String(T)
        return dequeueReusableCellWithIdentifier(identifier) as? T
    }
}
