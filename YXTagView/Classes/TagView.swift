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
    
    enum Alignment {
        case left
        case center
        case right
    }
    
    var alignment: Alignment = .left {
        didSet {
            updateItemGroupsFrame(layoutItems)
        }
    }
    
    private var contentSize: CGSize = .zero
    
    var limitView: UIView? = nil
    
    var limitLine: Int = 0
    
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
        layoutItems.removeAll()
        addItems()
    }
    
    private func removeInUseItems() {
        inUseItems.forEach { (key, items) in
            items.forEach { $0.removeFromSuperview() }
            cacheItems[key] = cacheItems[key] ?? []
            cacheItems[key]?.append(contentsOf: items)
        }
        limitView?.removeFromSuperview()
        inUseItems.removeAll()
    }
    
    private var layoutItems: [[UIView]] = []
    
    private func addItems() {
        guard let dataSource = dataSource else { return }
        let numbers = dataSource.numbers(in: self)
        
        
        var currentLineItems: [UIView] = []
        
        for index in 0..<numbers {
            let item = dataSource.tagView(self, itemAt: index)
            item.tag = index
            let (stop, nextLineItem) = layout(item: item, in: &currentLineItems, at: index)
            if stop { break }
            if let nextItem = nextLineItem {
                layoutItems.append(currentLineItems)
                currentLineItems.removeAll()
                currentLineItems.append(nextItem)
            }
            
            item.isUserInteractionEnabled = true
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemDidClickAction(gesture:))))
            addSubview(item)
        }
        
        if currentLineItems.count > 0 {
            layoutItems.append(currentLineItems)
        }
        updateItemGroupsFrame(layoutItems)
        
        var lastLineMaxFrame: CGRect = .zero
        layoutItems.last?.forEach { lastLineMaxFrame = $0.bounds.height > lastLineMaxFrame.height ? $0.frame : lastLineMaxFrame }
        contentSize = CGSize(width: frame.width, height: lastLineMaxFrame.maxY + contentInset.bottom)

    }
    
    
    func layout(item: TagItem, in currentGroup: inout [UIView], at index: Int) -> (Bool, TagItem?) {
        
        let size = delegate!.tagView(self, sizeAt: index)
        let numbers = dataSource!.numbers(in: self)

        let contentWidth = frame.width - contentInset.left - contentInset.right
        
        if limitLine > 0, layoutItems.count == limitLine - 1, let lastItem = currentGroup.last {
            if let limitView = limitView,
               lastItem.frame.maxX + size.width + limitView.bounds.width + itemSpacing * 2 > contentWidth {
                
                if lastItem.frame.maxX + size.width + itemSpacing < contentWidth && numbers - 1 == index {
                    item.frame = CGRect(x: lastItem.frame.maxX + itemSpacing, y: 0, width: size.width, height: size.height)
                    addSubview(item)
                    currentGroup.append(item)
                } else {
                    limitView.frame = CGRect(x: lastItem.frame.maxX + itemSpacing, y: 0, width: limitView.bounds.width, height: limitView.bounds.height)
                    addSubview(limitView)
                    currentGroup.append(limitView)
                }
                return (true, nil)
            } else if (lastItem.frame.maxX + size.width + itemSpacing > contentWidth) {
                return (true, nil)
            }
        }
        
        var returnNextLineItem = false
        if let lastItem = currentGroup.last {
            if lastItem.frame.maxX + size.width + itemSpacing > contentWidth {
                item.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                returnNextLineItem = true
            } else {
                item.frame = CGRect(x: lastItem.frame.maxX + itemSpacing, y: 0, width: size.width, height: size.height)
                currentGroup.append(item)
            }
        } else {
            item.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            currentGroup.append(item)
        }
        
        return (false, returnNextLineItem ? item : nil)
    }
    
    func updateItemGroupsFrame(_ itemGroups: [[UIView]]) {
        
        let contentWidth = frame.width - contentInset.left - contentInset.right
        
        var currentLine = 0
       
        var maxHeight: CGFloat = 0
        var lineWidth: CGFloat = 0
        var marginTop: CGFloat = 0
        
        for items in itemGroups {
            currentLine += 1
            lineWidth = items.reduce(0) {
                maxHeight = max(maxHeight, $1.bounds.height)
                return $0 + $1.bounds.width + itemSpacing
            }
            lineWidth -= itemSpacing
            
            var x: CGFloat = 0
            switch alignment {
            case .left: x += contentInset.left
            case .center: x += contentInset.left + (contentWidth - lineWidth) / 2.0
            case .right: x +=  contentInset.left + contentWidth - lineWidth
            }
            for item in items {
                let y = marginTop + (maxHeight - item.bounds.height) / 2.0
                item.frame = CGRect(x: x, y: y, width: item.bounds.width, height: item.bounds.height)
                x = item.frame.maxX + itemSpacing
            }
            
            marginTop += lineSpacing + maxHeight
        }
        
        print()
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
    static func calculateContentSize(with itemSizes: [CGSize], itemSpacing: CGFloat, lineSpacing: CGFloat, contentInset: UIEdgeInsets, preferredMaxLayoutWidth: CGFloat, limitLine: Int = 0, limitViewSize: CGSize? = nil) -> CGSize {
        
        if itemSizes.count == 0 {
            return .zero
        }
        
        let contentWidth = preferredMaxLayoutWidth - contentInset.left - contentInset.right
        
        var onelineWidth: CGFloat = 0
        var oneLineMaxHeight: CGFloat = 0
        var numberOfLines: Int = 0
        var lineHeight: CGFloat = 0
        
        var lastLineMaxHeight: CGFloat = 0
        
        for size in itemSizes {
            let wrapLine = onelineWidth + size.width > contentWidth
            if wrapLine {
                numberOfLines += 1
                if limitLine > 0, numberOfLines == limitLine, let limitViewSize = limitViewSize {
                    numberOfLines -= 1
                    oneLineMaxHeight = max(lastLineMaxHeight, limitViewSize.height)
                    break
                }
                
                lineHeight += oneLineMaxHeight
                onelineWidth -= itemSpacing
                lastLineMaxHeight = oneLineMaxHeight
            }
            oneLineMaxHeight = wrapLine ? size.height : max(oneLineMaxHeight, size.height)
            onelineWidth = wrapLine ? size.width + itemSpacing : onelineWidth + size.width + itemSpacing
        }
        
        lineHeight += oneLineMaxHeight
        lineHeight = lineHeight + CGFloat(numberOfLines) * lineSpacing + contentInset.top + contentInset.bottom
    
        return CGSize(width: preferredMaxLayoutWidth, height: lineHeight)
    }
}
