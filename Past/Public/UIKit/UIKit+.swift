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

protocol ViewType {}
extension UIView: ViewType {}
extension ViewType where Self: UIView {
    static func viewFromNib() -> Self? {
        let nibName = String(self)
        return NSBundle.mainBundle().loadNibNamed(nibName, owner: self, options: nil).first as? Self
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

extension UIScrollView {
    
    @IBInspectable
    public var autoShrink: Bool {
        // get method not used
        get {
            return false
        }
        
        set(auto) {
            if auto {
                observeForName(UIKeyboardDidShowNotification, didReceiveNotification: { [unowned self] noti in
                    let info = noti.userInfo!
                    let kbSize = info[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
                    
                    var contentInsets = self.contentInset
                    contentInsets.bottom = kbSize.height
                    
                    self.contentInset = contentInsets
                    self.scrollIndicatorInsets = contentInsets
                    })
                
                observeForName(UIKeyboardWillHideNotification, didReceiveNotification: { [unowned self] noti in
                    var contentInsets = self.contentInset
                    contentInsets.bottom = 0
                    UIView.animateWithDuration(0.4, animations: { self.contentInset = contentInsets })
                    self.scrollIndicatorInsets = contentInsets
                    })
                
            }
        }
    }
}

extension UIView {
    func animatedRelayout() {
        UIView.animateWithDuration(0.3) { 
            self.layoutIfNeeded()
        }
    }
}