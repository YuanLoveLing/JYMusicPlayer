//
//  JYMusicPlayerView.swift
//  JYMusicPlayer
//
//  Created by 靳志远 on 2017/5/10.
//  Copyright © 2017年 靳志远. All rights reserved.
//

import UIKit
import AVFoundation

class JYMusicPlayerView: UIView {
    /// 歌曲名称
    @IBOutlet fileprivate weak var musicNameLbl: UILabel!
    
    /// 进度条视图左边距离
    @IBOutlet fileprivate weak var progressContainerViewLeft: NSLayoutConstraint!
    /// 进度条视图右边距离
    @IBOutlet fileprivate weak var progressContainerViewRight: NSLayoutConstraint!
    
    /// 播放进度圆点
    @IBOutlet fileprivate weak var progressDotView: UIView!
    /// 左边距离
    @IBOutlet fileprivate weak var progressDotViewLeft: NSLayoutConstraint!
    /// 宽度
    @IBOutlet fileprivate weak var progressDotViewWidth: NSLayoutConstraint!
    
    /// 当前播放时间
    @IBOutlet fileprivate weak var currentTimeLbl: UILabel!
    /// 总时长
    @IBOutlet fileprivate weak var durationLbl: UILabel!
    
    /// 播放、暂停按钮
    @IBOutlet fileprivate weak var playOrPauseButton: UIButton!
    
    fileprivate var urlString: String?
    fileprivate var playerItem: AVPlayerItem?
    
    /// 计时器：更新播放进度
    fileprivate var progressTimer: Timer?
    
    /// 实例化对象单例方法
    static let shareInstance = {
        return Bundle.main.loadNibNamed("JYMusicPlayerView", owner: nil, options: nil)?.first as! JYMusicPlayerView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置UI
        setupUI()
    }
    
    /// 设置UI
    fileprivate func setupUI() {
        // 播放进度圆点添加滑动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panProgressPointView(pan:)))
        progressDotView.addGestureRecognizer(pan)
    }
    
    /// 滑动触发事件
    @objc fileprivate func panProgressPointView(pan: UIPanGestureRecognizer) {
        guard let playerItem = playerItem  else {
            return
        }
        
        // 获得移动距离
        let point = pan.translation(in: pan.view)
        // 将translation清空，避免重复叠加
        pan.setTranslation(CGPoint.zero, in: pan.view)
        
        // 最大移动距离
        let maxValue = width - progressContainerViewLeft.constant - progressContainerViewRight.constant - progressDotViewWidth.constant
        progressDotViewLeft.constant += point.x
        
        if progressDotViewLeft.constant < 0 {
            progressDotViewLeft.constant = 0;
            
        }else if progressDotViewLeft.constant > maxValue {
            progressDotViewLeft.constant = maxValue;
        }
        
        // 更新时间
        let percent = progressDotViewLeft.constant / maxValue
        if pan.state == UIGestureRecognizerState.began {// 开始滑动
            // 移除计时器
            removeProgressTimer()
            
        }else if pan.state == UIGestureRecognizerState.ended {// 结束滑动
            let expectedTime = CMTimeGetSeconds(playerItem.duration) * Float64(percent)
            var time = playerItem.currentTime()
            time.value = CMTimeValue(time.timescale) * CMTimeValue(expectedTime)
            playerItem.seek(to: time)
            // 添加计时器
            addProgressTimer()
        }
    }
    
    ///  显示
    func showWithPlayerItem(music: JYMusic, isOnline: Bool) {
        guard let urlString = music.urlString else {
            return
        }
        
        let window = UIApplication.shared.keyWindow!
        window.isUserInteractionEnabled = false
        window.addSubview(self)
        frame = window.bounds
        
        y = window.height
        UIView.animate(withDuration: 0.25, animations: {
            self.y = 0
            
        }) {[weak self] (_) in
            window.isUserInteractionEnabled = true
            // 1、停止之前播放
            JYMusicPlayerManager.shareInstance.destroy()
            // 2、开始现在播放
            self?.playerItem = JYMusicPlayerManager.shareInstance.play(urlString: urlString, isOnline: isOnline)
            self?.urlString = urlString
            // 添加计时器
            self?.addProgressTimer()
            // 歌曲名称
            self?.musicNameLbl.text = music.name
        }
    }
    
    // 点击“隐藏”按钮
    @IBAction fileprivate func dismissButtonDidClick() {
        let window = UIApplication.shared.keyWindow!
        window.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.y = window.height
            
        }) {(_) in
            self.removeFromSuperview()
            window.isUserInteractionEnabled = true
        }
    }
    
    // 点击“上一首”按钮
    @IBAction fileprivate func previousButtonDidClick() {
        print("上一首")
    }
    
    // 点击“播放、暂停”按钮
    @IBAction fileprivate func playOrPauseButtonDidClick() {
        if JYMusicPlayerManager.shareInstance.isPlaying == true {
            JYMusicPlayerManager.shareInstance.pause()
            playOrPauseButton.setImage(UIImage(named: "Player_play"), for: .normal)
            
        }else {
            if let urlString = urlString {
                playOrPauseButton.setImage(UIImage(named: "Player_pause"), for: .normal)
                playerItem = JYMusicPlayerManager.shareInstance.play(urlString: urlString, isOnline: false)
            }
        }
    }
    
    // 点击“下一首”按钮
    @IBAction fileprivate func nextButtonDidClick() {
        print("下一首")
    }
}


// MARK: - 计时器逻辑
extension JYMusicPlayerView {
    /// 添加计时器
    fileprivate func addProgressTimer() {
        removeProgressTimer()
        progressTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
    }
    
    /// 计时器触发方法
    @objc fileprivate func updateProgress() {
        guard let playerItem = playerItem  else {
            return
        }
        let currentTime = CMTimeGetSeconds(playerItem.currentTime())
        var duration = CMTimeGetSeconds(playerItem.duration)
        if duration.isNaN == true {// 当分母为0时，结果为inf（inf表示无穷大）
            duration = 0.001;
        }
        let percent = currentTime / duration
        
        progressDotViewLeft.constant = CGFloat(percent) * (width - progressContainerViewLeft.constant - progressContainerViewRight.constant - progressDotViewWidth.constant)
        currentTimeLbl.text = stringWithTime(time: currentTime)
        durationLbl.text = stringWithTime(time: duration)
        
        if currentTime == duration {
            print("播放完毕")
            // 移除计时器
            removeProgressTimer()
            
            // 可以在这里写自动播放下一首逻辑
        }
    }
    
    /// 移除计时器
    fileprivate func removeProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    /// 时间格式转换
    fileprivate func stringWithTime(time: Float64) -> (String) {
        let minute = Int(time / 60)
        let second = Int(time) % 60
        return String(format: "%02d:%02d", arguments: [minute, second])
    }
}







