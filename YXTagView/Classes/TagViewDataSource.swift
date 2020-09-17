//
//  TagViewDataSource.swift
//  YXTagView
//
//  Created by 蔡志文 on 2020/9/14.
//

import UIKit

protocol TagViewDataSource: NSObjectProtocol {
    func numbers(in tagView: TagView) -> Int
    
    func tagView(_ tagView: TagView, itemAt index: Int) -> TagItem
}
