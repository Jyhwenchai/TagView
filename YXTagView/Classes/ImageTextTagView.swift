//
//  ImageTextTagView.swift
//  YXTagView
//
//  Created by 蔡志文 on 2020/9/16.
//

import UIKit

class ImageTextTagView: TagView {
    
    private var ignoreActionStates: [ImageTextTagItem.State] = [.disabled]
    
    typealias DataItem = (ImageTextTagItem.Data, ImageTextTagItem.Configure, ImageTextTagItem.State)
    var dataArray: [DataItem] = []
    
    private var actionClosure: ((Int, ImageTextTagItem.Data, ImageTextTagItem.Configure, ImageTextTagItem.State) -> Void)? = nil
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        delegate = self
        dataSource = self
    }
    
    let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: Control ignore action state
    func addIgnoreActionState(_ state: ImageTextTagItem.State) {
        ignoreActionStates.append(state)
    }
    
    func removeIgnoreActionState(_ state: ImageTextTagItem.State) {
        if state.rawValue == ImageTextTagItem.State.disabled.rawValue {
            return
        }
        ignoreActionStates.removeAll { $0.rawValue == state.rawValue }
    }
    
    // MARK: data operation
    func addData(_ data: ImageTextTagItem.Data, by configure: ImageTextTagItem.Configure, state: ImageTextTagItem.State = .normal) {
        dataArray.append((data, configure, state))
    }
    
    func insertData(_ data: ImageTextTagItem.Data, by configure: ImageTextTagItem.Configure, state: ImageTextTagItem.State = .normal, at index: Int) {
        if index < 0, index > dataArray.count {
            fatalError("Specified index is out of range")
        }
        
        dataArray.insert((data, configure, state), at: index)
    }
    
    func addDatas(_ datas: [ImageTextTagItem.Data], by configure: ImageTextTagItem.Configure, state: ImageTextTagItem.State = .normal) {
        datas.forEach { dataArray.append(($0, configure, state)) }
    }
    
    func insertDatas(_ datas: [ImageTextTagItem.Data], by configure: ImageTextTagItem.Configure, state: ImageTextTagItem.State = .normal, at index: Int) {
        if index < 0, index > dataArray.count {
            fatalError("Specified index is out of range")
        }
        
        datas.forEach { dataArray.append(($0, configure, state)) }
    }
    
    func removeData(at index: Int) {
        if index < 0, index > dataArray.count {
            fatalError("Specified index is out of range")
        }
        dataArray.remove(at: index)
    }
    
    // listen click event
    func listenActionEvent(with closure: ((Int, ImageTextTagItem.Data, ImageTextTagItem.Configure, ImageTextTagItem.State) -> Void)?) {
        self.actionClosure = closure
    }
}

extension ImageTextTagView: TagViewDataSource, TagViewDelegate {
    
    func numbers(in tagView: TagView) -> Int {
        dataArray.count
    }
    
    func tagView(_ tagView: TagView, itemAt index: Int) -> TagItem {
        let item = tagView.dequeueReusableItem(with: ImageTextTagItem.self)
        let (data, config, state) = dataArray[index]
        item.configuration = config
        item.data = data
        item.state = state
        return item
    }

    func tagView(_ tagView: TagView, sizeAt index: Int) -> CGSize {
        let (data, config, _) = dataArray[index]
        label.font = config.font
        label.text = data.text
        var size = label.sizeThatFits(CGSize.zero)
        let imageWidth = data.image?.size.width ?? 0
        size.width = size.width + imageWidth + config.spacing + config.contentInset.left + config.contentInset.right
        size.height = size.height + config.contentInset.top + config.contentInset.bottom
        return size
    }
    
    func tagView(_ tagView: TagItem, didSelectAt index: Int) {
        let dataItem = dataArray[index]
        let contain = ignoreActionStates.contains {
            $0.rawValue == dataItem.2.rawValue
        }
        
        if contain { return }
        
        actionClosure?(index, dataItem.0, dataItem.1, dataItem.2)
    }
    
    
}
