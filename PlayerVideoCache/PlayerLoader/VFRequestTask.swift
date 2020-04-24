//
//  VPRequestTask.swift
//  PlayerVideoCache
//
//  Created by ChenJiangLin on 2020/4/23.
//  Copyright © 2020 LoveToday. All rights reserved.
//

import UIKit
import Foundation
/// 请求超时
let requestTimeOut: TimeInterval = 10

protocol VFRequestTaskDelegate {
    /// 更新缓冲进度代理方法
    func requestTaskDidUpdateCache()
    
    func requestTaskDidReceiveResponse()
    
    func requestTaskDidFinishLoading(with cache: Bool)
    
    func requestTaskDidFail(with error: Error)
}

class VFRequestTask: NSObject {
    /// 会话对象
    var session: URLSession?
    /// 任务
    var task: URLSessionDataTask?
    
    var delegate: VFRequestTaskDelegate?
    /// 请求地址
    var requetURL: URL?
    /// 请求起始位置
    var requestOffset: Int64?
    /// 文件长度
    var fileLength: Int64?
    /// 缓存长度
    var cacheLength: Int64?
    /// 是否缓存文件
    var cache: Bool = false
    /// 是否取消请求
    var cancel: Bool = false
    
    override init() {
        VFFileHandle.createTempFile()
    }
    
    /// 开始请求
    func start(){
        guard let url = self.requetURL?.originalSchemeURL() else { return }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: requestTimeOut)
        if let offset = self.requestOffset, offset > 0, let fileLength = self.fileLength {
            request.addValue(String(format: "bytes=%ld-%ld", offset, fileLength - 1), forHTTPHeaderField: "Range")
        }
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        self.task = self.session?.dataTask(with: request)
        /// 启动
        self.task?.resume()
    }
    /// 取消
    func setCancel(cancel: Bool){
        self.cancel = cancel
        self.task?.cancel()
        self.session?.invalidateAndCancel()
    }
    
    
    

}

extension VFRequestTask: URLSessionDataDelegate{
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void){
        if self.cancel { return }
        
        completionHandler(.allow)
        if let httpResponse = response as? HTTPURLResponse, let contentRange = httpResponse.allHeaderFields["Content-Range"] as? String {
            if let fileLength = contentRange.components(separatedBy: "/").last, let length = fileLength as? Int64 {
                self.fileLength = length > 0 ? length : response.expectedContentLength
                
            }
        }
        self.delegate?.requestTaskDidReceiveResponse()
    }

    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask){
        
    }

    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask){
        
    }

    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        if self.cancel { return }
        VFFileHandle.writeTempFile(data: data)
        if let length = self.cacheLength {
            self.cacheLength = length + Int64(data.count)
        }
        
        self.delegate?.requestTaskDidUpdateCache()
        
    }

    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void){
        if self.cancel { return }
        if let error = dataTask.error {
            self.delegate?.requestTaskDidFail(with: error)
        }else{
            if self.cache, let url = self.requetURL, let fileName = String.fileName(url: url)  {
                VFFileHandle.cacheTempFileWithFile(name: fileName)
            }
            self.delegate?.requestTaskDidFinishLoading(with: self.cache)
        }
    }
}
