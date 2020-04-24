//
//  VFPlayer.swift
//  PlayerVideoCache
//
//  Created by ChenJiangLin on 2020/4/23.
//  Copyright © 2020 LoveToday. All rights reserved.
//

import UIKit
import AVFoundation

enum VFPlayerState {
    /// 正在等待
    case waiting
    /// 正在播放
    case playing
    /// 已经暂停
    case paused
    /// 停止
    case stopped
    case buffering
    case error
}

class VFPlayer: NSObject {
    var state: VFPlayerState?
    var progress: CGFloat?
    var duration: CGFloat?
    var cacheProgress: CGFloat?
    
    private var url: URL?
    private var player: AVPlayer?
    private var currentItem: AVPlayerItem?
    private var resourceLoader: VFResourceLoader?
    private var timeObserve: Any?
    
    /// 网络地址或者本地地址
    init(url: URL) {
        self.url = url
    }
    
    func reloadCurrentItem(){
        guard let url = self.url else { return }
        if url.absoluteString.hasPrefix("http") {
            /// 有缓存播放缓存文件
            if let cacheFilePath = VFFileHandle.cacheFileExistsWith(url: url) {
                let fileUrl = URL(fileURLWithPath: cacheFilePath)
                self.currentItem = AVPlayerItem(url: fileUrl)
            }
        }else{
            ///没有缓存播放网络文件
            self.resourceLoader = VFResourceLoader()
//            self.resourceLoader.dele
        }
    }
    
    /// 网络地址或者本地地址  逻辑：stop -> replace -> play
    func replaceItemWith(url: URL){
        
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
    func seek(toTime seconds: CGFloat){
        
    }
    /// 当前文件缓存情况 YES：已缓存  NO：未缓存
    func currentItemCacheState()->Bool{
        return false
    }
    /// 当前缓存文件完整路径
    func currentItemCacheFilePath(){
        
    }
    /// 清除缓存
    func clearCache()->Bool{
        return false
    }

}
extension VFPlayer{
    
}
