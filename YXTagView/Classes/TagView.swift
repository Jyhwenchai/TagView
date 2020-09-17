//
//  TagView.swift
//  YXTagView
//
//  Created by 蔡志文 on 2020/9/14.
//

import UIKit

class TagView: UIView {

    private var cacheItems: [String: [TagItem]] = [:]
    private var inUseItems: [String: [TagItem]] = [:]
    
    weak var delegate: TagViewDelegate?
    
    weak var dataSource: TagViewDataSource?
    
    var contentInset: UIEdgeInsets = .zero
    
    var lineSpacing: CGFloat = 0
    
    var itemSpacing: CGFloat = 0
    
    var alignment: Alignment = .left {
        didSet {
            layoutItems(subviews)
        }
    }
    
    private var contentSize: CGSize = .zero
    
    enum Alignment {
        case left
        case center
        case right
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shouldReloadData = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        shouldReloadData = true
    }
    
    
    private var shouldReloadData: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shouldReloadData {
            reloadData()
            shouldReloadData = false
        }
    }
    
    func reloadData() {
        removeInUseItems()
        addItems()
    }
    
    private func removeInUseItems() {
        inUseItems.forEach { (key, items) in
            items.forEach { $0.removeFromSuperview() }
            cacheItems[key] = cacheItems[key] ?? []
            cacheItems[key]?.append(contentsOf: items)
        }
        inUseItems.removeAll()
    }
    
    private func addItems() {
        guard let dataSource = dataSource else { return }
        let numbers = dataSource.numbers(in: self)
        var items: [TagItem] = []
        for index in 0..<numbers {
            let item = dataSource.tagView(self, itemAt: index)
            item.tag = index
            item.isUserInteractionEnabled = true
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemDidClickAction(gesture:))))
            addSubview(item)
            items.append(item)
        }
        
        layoutItems(items)
    }
    
    private func layoutItems(_ items: [UIView]) {
        let itemSpacing = self.itemSpacing
        let lineSpacing = self.lineSpacing
        let alignment = self.alignment
        let contentInset = self.contentInset
        let contentWidth = frame.width - contentInset.left - contentInset.right
        
        guard let delegate = delegate else { return }
        
        var onelineWidth: CGFloat = 0
        var oneLineMaxHeight: CGFloat = 0
        var itemInfos: [(Int, CGFloat, CGFloat)] = []
        var lineCount = 0
        
        
        for index in 0..<items.count {
            let size = delegate.tagView(self, sizeAt: index)
            items[index].frame.size = size
            
            let wrapLine = onelineWidth + size.width > contentWidth
            if wrapLine {
                onelineWidth -= itemSpacing
                itemInfos.append((lineCount, onelineWidth, oneLineMaxHeight))
            }
            oneLineMaxHeight = wrapLine ? size.height : max(oneLineMaxHeight, size.height)
            lineCount = wrapLine ? 1 : lineCount + 1
            let width = wrapLine ? size.width + itemSpacing : onelineWidth + size.width + itemSpacing
            onelineWidth = width
        }
        
        onelineWidth -= itemSpacing
        itemInfos.append((lineCount, onelineWidth, oneLineMaxHeight))
        
        var tempItems = items
        var frames: [CGRect] = []
        var marginTop: CGFloat = 0
        
        for (index, (lineCount, lineWidth, maxHeight)) in itemInfos.enumerated() {
            
            let subItems = tempItems.prefix(lineCount)
            tempItems.removeFirst(lineCount)
            
            var x: CGFloat = 0
            switch alignment {
            case .left: x = contentInset.left
            case .center: x = contentInset.left + (contentWidth - lineWidth) / 2.0
            case .right: x =  contentInset.left + contentWidth - lineWidth
            }
            
            subItems.forEach { item in
                let size = item.frame.size
                let y = contentInset.top + CGFloat(index) * lineSpacing + marginTop + (maxHeight - size.height) / 2.0
                frames.append(CGRect(x: x, y: y, width: size.width, height: size.height))
                x += (itemSpacing + size.width)
            }
            
            marginTop += maxHeight
        }
        
        for (index, item) in items.enumerated() {
            item.frame = frames[index]
        }
        
        contentSize.width = frame.width
        if frames.count > 0, let frame = frames.last {
            contentSize.height = frame.maxY + contentInset.bottom
        }
    }
    
    
    
    func dequeueReusableItem<T: TagItem>(with type: T.Type) -> T {
        let key = "\(type)"
        var item: T!
        if var items = self.cacheItems[key], items.count > 0 {
            item = (items.first as! T)
            items.removeFirst()
            self.cacheItems[key] = items
        } else {
            item = type.init()
        }

        var inUseItems = self.inUseItems[key] ?? []
        inUseItems.append(item)
        self.inUseItems[key] = inUseItems

        return item
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        reloadData()
        return contentSize
    }
    
    @objc func itemDidClickAction(gesture: UITapGestureRecognizer) {
        if let item = gesture.view as? TagItem, let delegate = delegate {
            delegate.tagView?(item, didSelectAt: item.tag)
        }
    }

}

extension TagView {
    static func calculateContentSize(with itemSizes: [CGSize], itemSpacing: CGFloat, lineSpacing: CGFloat, contentInset: UIEdgeInsets, preferredMaxLayoutWidth: CGFloat) -> CGSize {
        
        if itemSizes.count == 0 {
            return .zero
        }
        
        let contentWidth = preferredMaxLayoutWidth - contentInset.left - contentInset.right
        
        var onelineWidth: CGFloat = 0
        var oneLineMaxHeight: CGFloat = 0
        var numberOfLines: Int = 0
        var lineHeight: CGFloat = 1
        
        for size in itemSizes {
            let wrapLine = onelineWidth + size.width > contentWidth
            if wrapLine {
                numberOfLines += 1
                lineHeight += oneLineMaxHeight
                onelineWidth -= itemSpacing
            }
            oneLineMaxHeight = wrapLine ? size.height : max(oneLineMaxHeight, size.height)
            onelineWidth = wrapLine ? size.width + itemSpacing : onelineWidth + size.width + itemSpacing
        }
        
        lineHeight += oneLineMaxHeight
        lineHeight = lineHeight + CGFloat(numberOfLines) * lineSpacing + contentInset.top + contentInset.bottom
    
        return CGSize(width: preferredMaxLayoutWidth, height: lineHeight)
    }
}
