//
//  ViewController.swift
//  JYPlayer
//
//  Created by 靳志远 on 2017/3/15.
//  Copyright © 2017年 靳志远. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// 点击“在线播放”按钮触发事件
    @IBAction func onlinePlayButtonDidClick(_ sender: Any) {
        let vc = JYOnlineMusicListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    /// 点击“本地播放”按钮触发事件
    @IBAction func localPlayButtonDidClick(_ sender: Any) {
        let vc = JYLocalMusicListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


}

