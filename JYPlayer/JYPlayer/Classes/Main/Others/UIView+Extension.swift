
//  Created by 靳志远 on 16/3/25.
//  Copyright © 2016年 830clock. All rights reserved.
//

import UIKit

extension UIView {
    /**
     @IBInspectable 用于修饰属性，其修饰的属性可以在xib右侧面板中修改，也可以直接通过代码.出来
     */
    
    /// 设置圆角
   @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    /// 设置描边
    @IBInspectable var borderColor: UIColor {
        get {
            guard let c = layer.borderColor else {
                return UIColor.clear
            }
            return UIColor(cgColor: c)
        }
        
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    /// 设置描边粗细
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// x
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        
        set {
            frame.origin.x = newValue
        }
    }
    
    /// y
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        
        set {
            frame.origin.y = newValue
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get {
            return center.x
        }
        
        set {
            center.x = newValue
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get {
            return center.y
        }
        
        set {
            center.y = newValue
        }
    }
    
    /// width
    var width: CGFloat {
        get {
            return frame.size.width
        }
        
        set {
            frame.size.width = newValue
        }
    }
    
    /// height
    var height: CGFloat {
        get {
            return frame.size.height
        }
        
        set {
            frame.size.height = newValue
        }
    }
    
    /// size
    var size: CGSize {
        get {
            return frame.size
        }
        
        set {
            frame.size = newValue
        }
    }
}








