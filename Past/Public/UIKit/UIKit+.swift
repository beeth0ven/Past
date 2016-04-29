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

extension UIViewController {
    func viewFromNibWithType<T: UIView>(_: T.Type) -> T? {
        let nibName = String(T)
        return NSBundle.mainBundle().loadNibNamed(nibName, owner: self, options: nil).first as? T
    }
}


extension UITableView {
    
    @IBInspectable
    public var cellSelfSized: Bool {
        
        get {
            
            return rowHeight == UITableViewAutomaticDimension
        }
        set(enable) {
            if enable {
                estimatedRowHeight = rowHeight
                rowHeight = UITableViewAutomaticDimension
            }
        }
    }
}

extension UICollectionView {
    
    @IBInspectable
    public var cellSelfSized: Bool {
        
        get {
            
            guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return false }
            return layout.estimatedItemSize != CGSizeZero
        }
        set(enable) {
            if enable {
                
                guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
                layout.estimatedItemSize = layout.itemSize
            }
        }
    }
}
