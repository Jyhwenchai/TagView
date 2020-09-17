//
//  TagCell.swift
//  YXTagView
//
//  Created by 蔡志文 on 2020/9/16.
//

import UIKit

class TagCell: UITableViewCell {

    let tagView: TagView = {
        let tagView = TagView()
        tagView.itemSpacing = 10
        tagView.lineSpacing = 10
        tagView.alignment = .center
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return tagView
    }()
    
    var dataArray: [String] = []
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tagView)
        tagView.delegate = self
        tagView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        tagView.frame = self.bounds
        tagView.reloadData()
        selectedBackgroundView?.frame = bounds
    }
}

extension TagCell: TagViewDataSource, TagViewDelegate {
    
    func numbers(in tagView: TagView) -> Int {
        dataArray.count
    }
    
    func tagView(_ tagView: TagView, itemAt index: Int) -> TagItem {
        let item = tagView.dequeueReusableItem(with: ImageTextTagItem.self)
        item.textLabel.font = UIFont.systemFont(ofSize: 13)
        item.textLabel.text = dataArray[index]
        item.borderWidth = 1
        item.borderColor = UIColor.red
        item.cornerRadius = 13
        return item
    }

    
    func tagView(_ tagView: TagView, sizeAt index: Int) -> CGSize {
        label.text = dataArray[index]
        var size = label.sizeThatFits(CGSize.zero)
        size.width += 14
        size.height += 10
        return size
    }
    
    
}
