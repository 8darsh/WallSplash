//
//  WallpaperModel.swift
//  WallSplash
//
//  Created by Adarsh Singh on 10/10/23.
//

import Foundation

struct WallpaperModel: Codable{
    var hits: [photosUrl]
}
struct photosUrl: Codable{
    var webformatURL: String
}
