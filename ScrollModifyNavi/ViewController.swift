//
//  ViewController.swift
//  ScrollModifyNavi
//
//  Created by pxh on 2019/7/3.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit

/// 滚动修改 导航栏
class ViewController: UIViewController {

    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deploySubviews()
        self.navigationItem.title = "test"
    }

    
    private func deploySubviews(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView.init()
    }

}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellID"
        var cell = tableview.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        cell?.detailTextLabel?.text = "test"
        return cell!
    }
    
    
}

