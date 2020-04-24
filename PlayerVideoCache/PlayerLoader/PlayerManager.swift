//
//  PlayerManager.swift
//  PlayerVideoCache
//
//  Created by ChenJiangLin on 2020/4/14.
//  Copyright © 2020 LoveToday. All rights reserved.
//

import UIKit
import AVKit

enum VPPlayerState {
    case wainting
    case playing
    case paused
    case stopped
    case buffering
    case error
}

class PlayerManager: NSObject {
    var state: VPPlayerState?
    var progress: CGFloat?
    var duration: CGFloat?
    var cacheProgress: CGFloat?
    
    private var url: URL?
    private var player: AVPlayer?
    private var currentItem: AVPlayerItem?
    
    
    
    /// 网络地址或者本地地址
    init(url: URL) {
        
    }
    /// 地址替换
    func peplaceItem(url: URL){
        
    }
    /// 播放
    func play(){
        
    }
    /// 暂停
    func pause(){
        
    }
    /// 停止
    func stop(){
        
    }
    /// 正在播放
    func isPlaying(){
        
    }
    /// 跳到某个时间进度
    func seekToTime(seconds: CGFloat){
        
    }
    /// 缓存情况 YES：已缓存  NO：未缓存
    func currentItemCacheState(){
        
    }
    /// 缓存文件完整路径
    func currentItemCacheFilePath(){
        
    }
    /// 清除缓存
    func clearCache(){
        
    }
    
    

}
