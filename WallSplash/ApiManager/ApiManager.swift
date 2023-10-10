//
//  ApiManager.swift
//  WallSplash
//
//  Created by Adarsh Singh on 10/10/23.
//

import Foundation

enum DataError: Error{
    case invalidResponse
    case invalidURL
    case invalidDecoding
    case network(Error?)
}

typealias handler = (Result<WallpaperModel,DataError>)->Void

class ApiManager{
    private var searchQuery: String = ""
    var url:URL?
    private var searchTimer: Timer?
    static let sharedInstance = ApiManager()
    init(){}
    
    func fetchWallpaper(completion: @escaping handler){
        if searchQuery == ""{
            url = URL(string: "\(Constant.Api.api)image_type=photo&per_page=200&orientation=vertical")
        }else{
            url = URL(string: "\(Constant.Api.api)q=\(searchQuery)&image_type=photo&per_page=200&orientation=vertical")
        }
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            
            guard let data, error == nil else{
                completion(.failure(.invalidURL))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  200...299 ~= response.statusCode else{
                completion(.failure(.invalidResponse))
                return
            }
            do{
                let wallpaper = try JSONDecoder().decode(WallpaperModel.self, from: data)
                completion(.success(wallpaper))
            }catch{
                completion(.failure(.network(error)))
            }
        }.resume()
    }
}

extension ApiManager{
    
    func updateSearchQuery(query: String, completion: @escaping (Result<WallpaperModel, DataError>) -> Void){
        searchQuery = query
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.fetchWallpaper(completion: completion)
        }
    }
}
