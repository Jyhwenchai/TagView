//
//  LimitLineViewController.swift
//  YXTagView
//
//  Created by 蔡志文 on 2020/9/17.
//

import UIKit

class LimitLineViewController: UIViewController {

    let tagView: TagView = {
        let tagView = TagView()
        tagView.itemSpacing = 10
        tagView.lineSpacing = 10
        tagView.alignment = .left
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagView.limitLine = 2
        tagView.limitView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 14)))
        tagView.limitView?.backgroundColor = UIColor.systemPink
        return tagView
    }()
    
    let dataArray = [
        "123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``3","123", "123","12223","22222","111123","13","12``3","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23",
    ]
    
    //    let dataArray = ["123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``31111"]
        
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tagView.delegate = self
        tagView.dataSource = self
        
        tagView.frame = view.bounds
        tagView.frame.origin.y += 100
        view.addSubview(tagView)
        tagView.sizeToFit()
    }
    @IBAction func alignmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tagView.alignment = .left
        } else if sender.selectedSegmentIndex == 1 {
            tagView.alignment = .center
        } else {
            tagView.alignment = .right
        }
     }
}

extension LimitLineViewController: TagViewDataSource, TagViewDelegate {
    
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
        size.height += CGFloat(Int.random(in: 6...16))
        return size
    }
    
    
}
