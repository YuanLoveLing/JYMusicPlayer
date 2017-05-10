//
//  JYLocalMusicListViewController.swift
//  JYPlayer
//
//  Created by 靳志远 on 2017/3/15.
//  Copyright © 2017年 靳志远. All rights reserved.
//

import UIKit

fileprivate let JYLocalMusicListCellId = "JYLocalMusicListCellId"

class JYLocalMusicListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI
        setupUI()
    }
    
    /// 设置UI
    fileprivate func setupUI() {
        // 设置导航栏
        title = "在线音乐列表"
        
        // 设置tableView
        
    }
    
    // MARK: - lazy
    /// 数据源数据
    fileprivate lazy var dataSourceArray: [JYMusic] = {
        var array = [JYMusic]()
        for i in 0...2 {
            var music = JYMusic()
            music.name = "在线音乐名称\(i)"
            music.singerName = "在线歌手名称\(i)"
            music.urlString = Bundle.main.path(forResource: "test\(i + 1)", ofType: "mp3")
            array.append(music)
        }
        return array
    }()
}


// MARK: - UITableViewDataSource
extension JYLocalMusicListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: JYLocalMusicListCellId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: JYLocalMusicListCellId)
            
        }
        let music = dataSourceArray[indexPath.row]
        cell!.textLabel?.text = music.name
        cell!.detailTextLabel?.text = music.singerName
        return cell!
    }
}


// MARK: - UITableViewDelegate
extension JYLocalMusicListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let music = dataSourceArray[indexPath.row]
        // 2、开始现在
        JYPlayView.shareInstance.showWithPlayerItem(music: music, isOnline: false)
    }
}








