//
//  TagVIewDelegate.swift
//  YXTagView
//
//  Created by 蔡志文 on 2020/9/14.
//

import UIKit

@objc
protocol TagViewDelegate: NSObjectProtocol {
    func tagView(_ tagView: TagView, sizeAt index: Int) -> CGSize
    @objc optional func tagView(_ tagView: TagItem, didSelectAt index: Int)
}
