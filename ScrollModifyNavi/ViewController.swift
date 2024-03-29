//
//  ViewController.swift
//  ScrollModifyNavi
//
//  Created by pxh on 2019/7/3.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit

let Screen_Width = UIScreen.main.bounds.width
let Screen_Height = UIScreen.main.bounds.height
let StatusBar_Height = UIApplication.shared.statusBarFrame.height

/// 滚动修改 导航栏
class ViewController: UIViewController {
    
    //实现思路
    //1、用一张图片做头部的背景，同时记录原始的frame
    //2、写一个tableview添加一个跟头部背景大小一致的透明头部，注意tableView的背景也是透明的
    //3、在scroll函数中通过计算变更颜色，实现方式有两种1、用navigation取点是statusBar不能同时渐变2、隐藏navi 自定义navi 可以完美实现效果
    //注释的代码使用的是方式1，直接运行的代码是方式二
    /// 1.用imageView作头部背景图片，并保存初始frame
    lazy var bgIM: UIImageView = {
        let view = UIImageView.init(image: UIImage.init(named: "SK_JN_bg"))
        view.frame = CGRect.init(x: 0, y: 0, width: Screen_Width, height: Screen_Width * (142.0 / 350))
        self.view.addSubview(view)
        return view
    }()
    
    var originalFame = CGRect.zero
    
    private let customNavi = CustomNaviBar.init(frame: CGRect.init(x: 0, y: 0, width: Screen_Width, height: StatusBar_Height + 44))
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deploySubviews()
//        self.navigationItem.title = "test"
        self.view.addSubview(customNavi)
        customNavi.alpha = 0.0
        self.view.bringSubviewToFront(customNavi)
    }
    //    3、顶部的导航栏可以使用系统的，也可以使用自定义的导航栏
    //
    //    1）使用系统导航栏：需要在storyboard或者代码设置导航栏属性
    //
    //    （1）将导航栏设置为透明并去掉下方黑线
    //系统导航栏，利用push跳转，但是有个问题是状态栏的颜色未渐变
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏navi 和分割线
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
            //            self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(colorAlpha)
//            self.navigationController?.title = "测试标题"
            self.customNavi.alpha = colorAlpha
        }else{
            //滑动超过导航栏底部
            //            self.navigationController?.navigationBar.backgroundColor = UIColor.white
            self.customNavi.alpha = 1.0
        }
        //处理图片放大效果、网上移动的效果
        if offsetY > 0{
            //往上缩小
            self.bgIM.frame = {
                var bgFrame = self.originalFame
                let space = offsetY > StatusBar_Height + 44 ? StatusBar_Height + 44 : offsetY
                bgFrame.origin.y = self.originalFame.origin.y - space
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


/// 当前页面定制的naviBar
private class CustomNaviBar: UIView{
 
    /// 左侧返回按钮
    lazy var leftBTN: UIButton = {
        let view = UIButton()
        self.addSubview(view)
        view.setTitle("返回", for: UIControl.State.normal)
        view.setTitleColor(UIColor.black, for: UIControl.State.normal)
        return view
    }()
    
    /// 标题标签
    lazy var titleLB: UILabel = {
        let view = UILabel()
        self.addSubview(view)
        view.textAlignment = NSTextAlignment.center
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = UIColor.black
        view.text = "text标题"
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        deploySubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func deploySubviews(){
        leftBTN.frame = CGRect.init(x: 16, y: StatusBar_Height, width: 60, height: 44)
        
        titleLB.frame = CGRect.init(x: Screen_Width * 0.5 - 50, y: StatusBar_Height, width: 100, height: 44)
    }
    
}
