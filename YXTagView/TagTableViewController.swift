//
//  TagTableViewController.swift
//  YXTagView
//
//  Created by 蔡志文 on 2020/9/16.
//

import UIKit

class TagTableViewController: UITableViewController {
    
    let dataArray = [
        ["123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``3","123", "123"],
        ["123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``3","123", "123","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23"],
        ["123","12223","22222","111123","13","12``3","123","123","11额1123","13","12``3","123", "123","12223","22222","111123","13","12``3","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23"],
        ["123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``3","123", "123","12223","22222","111123","13","12``3","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23"],
        ["123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``3","123", "123","12223","22222","111123","13","12``3","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23"],
        ["123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``3","123", "123","12223","22222","111123","13","12``3","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23"],
        ["123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``3","123", "123","12223","22222","1就好23","1是否23"],
        ["123","12223","123","123", "123","12223","22222","11额1123","13","12``3","123", "123","12223","22222","111123","13","12``3","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23"],
        ["123","12223","22222","111123","13","12``3","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23"],
        ["123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``3","123", "123","12223","22222","111123","13","12``3","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23"],
        ["123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``3","123", "123","12223","22222","111123","13","12``3","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23"],
        ["123","12223","22222","111123","13","12``3","123","123", "123","12223","22222","11额1123","13","12``3","123", "123","12223","22222","111123","13","12``3","12ss3","12大幅度3","1好好计划23","12553","1就好23","1是否23"],
    ]
    
    var dataSizes: [CGSize] = []
    
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TagCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        dataArray.forEach {
            var sizes: [CGSize] = []
            $0.forEach {
                label.text = $0
                var size = label.sizeThatFits(CGSize.zero)
                size.width += 14
                size.height += 10
                sizes.append(size)
            }
            let size = TagView.calculateContentSize(with: sizes, itemSpacing: 10, lineSpacing: 10, contentInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), preferredMaxLayoutWidth: view.bounds.width)
//            let size = TagView.calculateContentSize(with: sizes, itemSpacing: 10, lineSpacing: 10, contentInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), preferredMaxLayoutWidth: view.bounds.width, limitLine: 2, limitViewSize: CGSize(width: 30, height: 14))
            dataSizes.append(size)
        }
        
    }

  
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TagCell
        cell.dataArray = dataArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSizes[indexPath.row].height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
