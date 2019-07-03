//
//  ViewController.swift
//  ScrollModifyNavi
//
//  Created by pxh on 2019/7/3.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit

let Screen_Width = UIScreen.main.bounds.width
let Screen_height = UIScreen.main.bounds.height

/// 滚动修改 导航栏
class ViewController: UIViewController {

    
    
    /// 1.用imageView作头部背景图片，并保存初始frame
    lazy var bgIM: UIImageView = {
        let view = UIImageView.init(image: UIImage.init(named: "SK_JN_bg"))
        view.frame = CGRect.init(x: 0, y: 0, width: Screen_Width, height: Screen_Width * (142.0 / 350))
        self.view.addSubview(view)
        return view
    }()
    
    var originalFame = CGRect.zero
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deploySubviews()
        self.navigationItem.title = "test"
    }
//    3、顶部的导航栏可以使用系统的，也可以使用自定义的导航栏
//
//    1）使用系统导航栏：需要在storyboard或者代码设置导航栏属性
//
//    （1）将导航栏设置为透明并去掉下方黑线
    //系统导航栏，利用push跳转，但是有个问题是状态栏的颜色未渐变
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func deploySubviews(){
        //背景图片相关
        self.view.sendSubviewToBack(bgIM)
        self.originalFame = self.bgIM.frame
        //设置列表数据相关
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView.init()
        tableview.backgroundColor = UIColor.clear
        //2.创建tableView的透明头部，目的是显露出头部的背景图片
        let headerVW = UIView.init(frame: self.originalFame)
        headerVW.backgroundColor = UIColor.clear
        tableview.tableHeaderView = headerVW
    }

}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    //    （2）根据滑动时偏移的y值作相应操作
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        //第一种：系统导航栏，利用push跳转，但是有个问题是状态栏的颜色未渐变
        if offsetY < 100 {
            //滑到底部之前
            let colorAlpha = offsetY / 160
            self.navigationController?.navigationBar.backgroundColor = UIColor.red.withAlphaComponent(colorAlpha)
            self.navigationController?.title = "测试标题"
        }else{
            //滑动超过导航栏底部
            self.navigationController?.navigationBar.backgroundColor = UIColor.red
        }
        //处理图片放大效果、网上移动的效果
        if offsetY > 0{
            //往上缩小
            self.bgIM.frame = {
                var bgFrame = self.originalFame
                bgFrame.origin.y = self.originalFame.origin.y - offsetY
                return bgFrame
            }()
        }else{
            //往下放大
            self.bgIM.frame = {
                var bgFrame = self.originalFame
                bgFrame.size.height = self.originalFame.size.height - offsetY
                bgFrame.size.width = bgFrame.size.height / 142 * 350
                bgFrame.origin.x = (originalFame.size.width - bgFrame.size.width) * 0.5
                return bgFrame
            }()
        }
    }
    
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

