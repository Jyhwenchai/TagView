//
//  TagItem.swift
//  YXTagView
//
//  Created by 蔡志文 on 2020/9/14.
//

import UIKit

class TagItem: UIView {
    
    /// ＜ 0 则取一半的视图高度为值
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    var borderColor: UIColor? {
        get {
            guard let color = layer.backgroundColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius < 0 ? bounds.height / 2.0 : cornerRadius
    }
}
