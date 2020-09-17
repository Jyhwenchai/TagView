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
        let config = ImageTextTagItem.Configure(font:.systemFont(ofSize: 13), cornerRadius: 13, borderWidth: 1, borderColor: UIColor.red)
        for _ in 0..<20 {
            tagView.addData(ImageTextTagView.Data(text: "hello"), by: config)
        }
        
        var selectedConfig = config
        selectedConfig.backgroundColor = UIColor.systemBlue
        selectedConfig.borderColor = nil
        selectedConfig.borderWidth = 0.0
        selectedConfig.textColor = UIColor.white
        for _ in 0..<5 {
            tagView.insertData(ImageTextTagView.Data(text: "selected"), by: selectedConfig, state: .selected, at: Int.random(in: 2...20))
        }
        
        var disabledConfig = config
        disabledConfig.backgroundColor = UIColor.lightGray
        disabledConfig.borderColor = nil
        disabledConfig.borderWidth = 0.0
        disabledConfig.textColor = UIColor.white
        for _ in 0..<3 {
            tagView.insertData(ImageTextTagView.Data(text: "disabled"), by: disabledConfig, state: .disabled, at: Int.random(in: 2...20))
        }
        
        var reversedConfig = config
        reversedConfig.backgroundColor = UIColor.systemTeal
        reversedConfig.borderColor = nil
        reversedConfig.borderWidth = 0.0
        reversedConfig.textColor = UIColor.white
        for _ in 0..<3 {
            tagView.insertData(ImageTextTagView.Data(text: "reversed"), by: reversedConfig, state: .reversed, at: Int.random(in: 2...20))
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
