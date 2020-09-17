//
//  ImageTextTagViewController.swift
//  YXTagView
//
//  Created by 蔡志文 on 2020/9/16.
//

import UIKit

class ImageTextTagViewController: UIViewController {

    var tagView: ImageTextTagView = {
        let tagView = ImageTextTagView()
        tagView.itemSpacing = 10
        tagView.lineSpacing = 10
        tagView.alignment = .center
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return tagView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tagView.frame = view.bounds
        tagView.frame.origin.y += 100
        view.addSubview(tagView)
        let config = ImageTextTagItem.Configure(font:.systemFont(ofSize: 13), cornerRadius: -1, borderWidth: 1, borderColor: UIColor.red, contentInset: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
        for _ in 0..<20 {
            tagView.addData(ImageTextTagItem.Data(text: "hello"), by: config)
        }
        
        var selectedConfig = config
        selectedConfig.backgroundColor = UIColor.systemBlue
        selectedConfig.borderColor = nil
        selectedConfig.borderWidth = 0.0
        selectedConfig.textColor = UIColor.white
        for _ in 0..<5 {
            tagView.insertData(ImageTextTagItem.Data(text: "selected"), by: selectedConfig, state: .selected, at: Int.random(in: 2...20))
        }
        
        var disabledConfig = config
        disabledConfig.backgroundColor = UIColor.lightGray
        disabledConfig.borderColor = nil
        disabledConfig.borderWidth = 0.0
        disabledConfig.textColor = UIColor.white
        for _ in 0..<3 {
            tagView.insertData(ImageTextTagItem.Data(text: "disabled"), by: disabledConfig, state: .disabled, at: Int.random(in: 2...20))
        }
        
        var reversedConfig = config
        reversedConfig.backgroundColor = UIColor.systemTeal
        reversedConfig.borderColor = nil
        reversedConfig.borderWidth = 0.0
        reversedConfig.textColor = UIColor.white
        for _ in 0..<3 {
            tagView.insertData(ImageTextTagItem.Data(text: "reversed"), by: reversedConfig, state: .reversed, at: Int.random(in: 2...20))
        }
        
        var imageConfig = config
        imageConfig.backgroundColor = UIColor.systemOrange
        imageConfig.borderColor = nil
        imageConfig.borderWidth = 0.0
        imageConfig.textColor = UIColor.white
        imageConfig.spacing = 6
        for _ in 0..<3 {
            tagView.insertData(ImageTextTagItem.Data(image: UIImage(named: "homepage_icon_myposition"), text: "center align"), by: imageConfig, state: .reversed, at: Int.random(in: 2...20))
        }
        
        imageConfig.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 15)
        imageConfig.alignment = .left
        imageConfig.reverseLayout = true
        for _ in 0..<3 {
            tagView.insertData(ImageTextTagItem.Data(image: UIImage(named: "homepage_icon_myposition"), text: "left align"), by: imageConfig, state: .reversed, at: Int.random(in: 2...20))
        }
        
        imageConfig.alignment = .right
        imageConfig.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 5)
        for _ in 0..<3 {
            tagView.insertData(ImageTextTagItem.Data(image: UIImage(named: "homepage_icon_cancel"), text: "right align"), by: imageConfig, state: .reversed, at: Int.random(in: 2...20))
        }
        
        tagView.addIgnoreActionState(.reversed)
        tagView.sizeToFit()
        
        tagView.listenActionEvent { (index, data, config, state) in
            print("click index \(index), \(state)")
        }
    }
    

}


extension ImageTextTagItem.State {
    static let reversed = ImageTextTagItem.State(rawValue: 2)
}
