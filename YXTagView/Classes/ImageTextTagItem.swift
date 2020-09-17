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
    
    var reverseLayout: Bool = false
    
    var contentInset: UIEdgeInsets = .zero
    
    
    var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
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
        let reverseLayout = self.reverseLayout
        let contentInset = self.contentInset
        
        let contentframe = bounds

        var textFrame: CGRect = CGRect(origin: .zero, size: textSize)
        var imageFrame: CGRect = CGRect(origin: .zero, size: imageSize)
        let totalWidth = textSize.width + imageSize.width + spacing
        
        var x: CGFloat = 0
        
        switch alignment {
        case .left:
            x = contentInset.left
        case .center:
            x = (contentframe.size.width - totalWidth) / 2.0
        case .right:
            x = contentframe.width - totalWidth - contentInset.right
        }
        
        if reverseLayout {
            textFrame.origin.x = x
            imageFrame.origin.x = textFrame.maxX + spacing
        } else {
            imageFrame.origin.x = x
            textFrame.origin.x = imageFrame.maxX + spacing
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
        var contentInset: UIEdgeInsets
        var alignment: Alignmet
        var spacing: CGFloat
        var reverseLayout: Bool
        
        init(font: UIFont = .systemFont(ofSize: 15),
             textColor: UIColor = .black,
             backgroundColor: UIColor? = nil,
             cornerRadius: CGFloat = 0.0,
             borderWidth: CGFloat = 0.0,
             borderColor: UIColor? = nil,
             contentInset: UIEdgeInsets = .zero,
             alignment: Alignmet = .center,
             spacing: CGFloat = 0.0,
             reverseLayout: Bool = false) {
            self.backgroundColor = backgroundColor
            self.textColor  = textColor
            self.font = font
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.borderColor = borderColor
            self.contentInset = contentInset
            self.alignment = alignment
            self.spacing = spacing
            self.reverseLayout = reverseLayout
        }
    }
    
    var configuration: Configure = Configure() {
        didSet {
            textLabel.font =  configuration.font
            textLabel.textColor = configuration.textColor
            borderWidth = configuration.borderWidth
            borderColor = configuration.borderColor
            cornerRadius = configuration.cornerRadius
            backgroundColor = configuration.backgroundColor
            contentInset = configuration.contentInset
            alignment = configuration.alignment
            spacing = configuration.spacing
            reverseLayout = configuration.reverseLayout
        }
    }
    
    struct State {
        var rawValue: Int
        
        init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        static let disabled = State(rawValue: -1)
        static let normal = State(rawValue: 0)
        static let selected = State(rawValue: 1)
    }

    var state: State = .normal
}
