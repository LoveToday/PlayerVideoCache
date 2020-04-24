//
//  String+Extension.swift
//  PlayerVideoCache
//
//  Created by ChenJiangLin on 2020/4/14.
//  Copyright © 2020 LoveToday. All rights reserved.
//

import Foundation

extension String{
    /// 临时文件地址
    static func tempFilePath() -> String{
        let homeDirectory = NSHomeDirectory()
        let tmp = homeDirectory.appending("tmp")
        return tmp.appending("MusicTemp.mp4")
    }
    
    static func cacheFolderPath() -> String{
        let homeDirectory = NSHomeDirectory()
        return homeDirectory.appending("Library").appending("MusicCaches")
    }
    
    static func fileName(url: URL) -> String? {
        return url.path.components(separatedBy: "/").last
    }
    
}
