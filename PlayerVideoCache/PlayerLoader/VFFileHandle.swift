//
//  VFFileHandle.swift
//  PlayerVideoCache
//
//  Created by ChenJiangLin on 2020/4/14.
//  Copyright © 2020 LoveToday. All rights reserved.
//

import UIKit

class VFFileHandle: NSObject {
    var writeFileHandle: VFFileHandle?
    var readFileHandle: FileManager?
    /// 创建临时文件
    static func createTempFile() -> Bool{
        let manager = FileManager.default
        let path = String.tempFilePath()
        if manager.fileExists(atPath: path) {
            try? manager.removeItem(atPath: path)
        }
        return manager.createFile(atPath: path, contents: nil, attributes: nil)
    }
    /// 往临时文件写入数据
    static func writeTempFile(data: Data){
        let path = String.tempFilePath()
        let handle = FileHandle(forWritingAtPath: path)
        /// 将后一个数据写在前一个数据的后面
        handle?.seekToEndOfFile()
        handle?.write(data)
    }
    /// 读取临时文件数据
    static func readTempFileDataWith(offset: UInt64, length: Int)->Data?{
        let path = String.tempFilePath()
        let handle = FileHandle(forReadingAtPath: path)
        handle?.seek(toFileOffset: offset)
        return handle?.readData(ofLength: length)
    }
    /// 保存临时文件到缓存文件夹
    static func cacheTempFileWithFile(name: String){
        let manager = FileManager.default
        let cacheFolderPath = String.cacheFolderPath()
        if !manager.fileExists(atPath: cacheFolderPath) {
            try? manager.createDirectory(atPath: cacheFolderPath, withIntermediateDirectories: true, attributes: nil)
        }
        let cacheFilePath = String(format: "%@/%@", cacheFolderPath, name)
        try? FileManager.default.copyItem(atPath: String.tempFilePath(), toPath: cacheFilePath)
        
        
    }
    /// 是否存在缓存文件 存在：返回文件路径 不存在：返回nil
    static func cacheFileExistsWith(url: URL)->String?{
        guard let fileName = String.fileName(url: url) else { return nil }
        let cacheFilePath = String(format: "%@/%@", String.cacheFolderPath(), fileName)
        if FileManager.default.fileExists(atPath: cacheFilePath) {
            return cacheFilePath
        }
        return nil
    }
    /// 清空缓存文件
    static func clearCache(){
        let path = String.cacheFolderPath()
        let manager = FileManager.default
        try? manager.removeItem(atPath: path)
    }

}
