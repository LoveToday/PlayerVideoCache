//
//  VFResourceLoader.swift
//  PlayerVideoCache
//
//  Created by ChenJiangLin on 2020/4/14.
//  Copyright © 2020 LoveToday. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

var mimeType = "Video/mp4"

protocol VFResourceLoaderDelegate {
    func loader(_ loader: VFResourceLoader, cacheProgress: CGFloat)
    func loader(_ loader: VFResourceLoader, failLoading error: Error)
}

class VFResourceLoader: NSObject {
    var delegate: VFResourceLoaderDelegate?
    /// seek标识
    var seekRequired: Bool?
    var cacheFinished: Bool = false
    
    var requestList: [AVAssetResourceLoadingRequest] = []
    var requestTask: VFRequestTask?
    
    func stopLoading(){
        self.requestTask?.cancel = true
    }
    
    /// AVAssetResourceLoaderDelegate
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForResponseTo authenticationChallenge: URLAuthenticationChallenge) -> Bool {
        return false
    }
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        
    }
    
    func newTask(with loadingRequest: AVAssetResourceLoadingRequest, cache: Bool){
        var fileLength: UInt? = 0
        if let task = self.requestTask {
            fileLength = task.fileLength
            task.cancel = true
        }
        self.requestTask = VFRequestTask()
        self.requestTask?.requetURL = loadingRequest.request.url
        self.requestTask?.requestOffset = loadingRequest.dataRequest?.requestedOffset
        self.requestTask?.cache = cache
        if let length = fileLength, length > 0 {
            self.requestTask?.fileLength = length
        }
        self.requestTask?.delegate = self
        self.requestTask?.start()
        self.seekRequired = false
    }
    func processRequestList(){
        var finishRequestList = [AVAssetResourceLoadingRequest]()
        self.requestList.forEach {[weak self] (loadingRequest) in
            guard let `self` = self else { return }
            
        }
    }
    
    func finishLoading(with loadingRequest: AVAssetResourceLoadingRequest){
        /// 填充信息
        let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)
        loadingRequest.contentInformationRequest?.contentType = (contentType as CFTypeRef?) as? String
        loadingRequest.contentInformationRequest?.isByteRangeAccessSupported = true
        if let length = self.requestTask?.fileLength  {
            loadingRequest.contentInformationRequest?.contentLength = length
        }
        
        /// 读取文件 填充数据
        let cacheLength = self.requestTask?.cacheLength ?? 0
        var requestOffset = loadingRequest.dataRequest?.requestedOffset ?? 0
        
        if requestOffset > 0 {
            requestOffset = loadingRequest.dataRequest?.currentOffset ?? 0
        }
        
        let canReadLength = cacheLength - (requestOffset - (self.requestTask?.requestOffset ?? 0))
        
        let respondLength = min(canReadLength, loadingRequest.dataRequest?.requestedOffset ?? 0)
        let offset = requestOffset - (self.requestTask?.requestOffset ?? 0)
        if  let data = VFFileHandle.readTempFileDataWith(offset: UInt64(offset), length: Int(respondLength))  {
            loadingRequest.dataRequest?.respond(with: data)
        }
        
        
        
        
    }
    
    

}
extension VFResourceLoader: VFRequestTaskDelegate{
    func requestTaskDidUpdateCache() {
        
    }
    
    func requestTaskDidReceiveResponse() {
        
    }
    
    func requestTaskDidFinishLoading(with cache: Bool) {
        self.cacheFinished = cache
    }
    
    func requestTaskDidFail(with error: Error) {
        //// 加载数据错误处理
    }
    
    
}

//extension VFResourceLoader: AVAssetResourceLoaderDelegate, {
//
//}
