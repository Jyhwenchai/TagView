//
//  ImageTextTagItem.swift
//  YXTagView
//
//  Created by 蔡志文 on 2020/9/15.
//

import UIKit

class ImageTextTagItem: TagItem {
    
    var alignment: Alignmet = .center
    
    /// image text spacing
    var spacing: CGFloat = 0
    
    var reverseTextImageLayout: Bool = false
    
    var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    var selectBackgroundView: UIView = UIView()
    
    enum Alignmet {
        case left
        case center
        case right
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLayout()
    }
    
    func contentLayout() {
        let imageSize = imageView.sizeThatFits(.zero)
        let textSize = textLabel.sizeThatFits(.zero)
        let spacing = self.spacing
        let alignment = self.alignment
        let reverseTextImageLayout = self.reverseTextImageLayout
        
        let contentframe = bounds

        var textFrame: CGRect = CGRect(origin: .zero, size: textSize)
        var imageFrame: CGRect = CGRect(origin: .zero, size: imageSize)
        
        var x: CGFloat = 0
        
        switch alignment {
        case .left:
                x = contentframe.origin.x
        case .center:
            let totalWidth = textSize.width + imageSize.width + spacing
            x = contentframe.minX + (contentframe.size.width - totalWidth) / 2.0
        case .right:
            x = contentframe.minX + contentframe.width - textSize.width - imageSize.width - spacing
        }
        
        if reverseTextImageLayout {
            imageFrame.origin.x = x
            textFrame.origin.x = imageFrame.maxX + spacing
        } else {
            textFrame.origin.x = x
            imageFrame.origin.x = textFrame.maxX + spacing
        }
        
        imageFrame.origin.y = (frame.size.height - imageSize.height) / 2.0
        textFrame.origin.y = (frame.size.height - textFrame.height) / 2.0
        imageView.frame = imageFrame
        textLabel.frame = textFrame
    }
    
    struct Configure {
        
        var backgroundColor: UIColor?
        var textColor: UIColor
        var font: UIFont
        var cornerRadius: CGFloat
        var borderWidth: CGFloat
        var borderColor: UIColor?
        
        init(font: UIFont = .systemFont(ofSize: 15),
             textColor: UIColor = .black,
             backgroundColor: UIColor? = nil,
             cornerRadius: CGFloat = 0.0,
             borderWidth: CGFloat = 0.0,
             borderColor: UIColor? = nil,
             state: State = .normal) {
            self.backgroundColor = backgroundColor
            self.textColor  = textColor
            self.font = font
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.borderColor = borderColor
        }
    }
    
    var state: State = .normal
    
    struct State {
        var rawValue: Int
        
        init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        static let disabled = State(rawValue: -1)
        static let normal = State(rawValue: 0)
        static let selected = State(rawValue: 1)
    }
}
