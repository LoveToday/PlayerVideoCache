//
//  URL+VFLoader.swift
//  PlayerVideoCache
//
//  Created by ChenJiangLin on 2020/4/23.
//  Copyright © 2020 LoveToday. All rights reserved.
//

import Foundation

extension URL{
    func customSchemeURL() -> URL?{
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = "streaming"
        return components?.url
    }
    
    func originalSchemeURL()->URL?{
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = "http"
        return components?.url
    }
    
}
