//
//  WallpaperViewModel.swift
//  WallSplash
//
//  Created by Adarsh Singh on 10/10/23.
//

import Foundation

final class WallpaperViewModel{
    
    var wallpaper: WallpaperModel?
    var eventHandler:((_ event: Event)->Void)?
    
    func fetchData(){
        
        self.eventHandler?(.loading)
        ApiManager.sharedInstance.fetchWallpaper{
            response in
            self.eventHandler?(.stopLoading)
            
            switch response{
                
            case .success(let wallpaper):
                self.wallpaper = wallpaper
                self.eventHandler?(.loaded)
                
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
}
extension WallpaperViewModel{
    enum Event{
        
        case loading
        case stopLoading
        case loaded
        case error(Error?)
    }
}
