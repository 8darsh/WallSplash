//
//  CollectionViewController.swift
//  WallSplash
//
//  Created by Adarsh Singh on 10/10/23.
//

import UIKit
import CoreGraphics


class CollectionViewController: UICollectionViewController {
    
    private var viewModel = WallpaperViewModel()
    let search = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        searchBarSetup()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return viewModel.wallpaper?.hits.count ?? 100
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WallpaperCollectionViewCell
        cell.wallpaperImage.setImage(with: (viewModel.wallpaper?.hits[indexPath.row].webformatURL ?? "hehe"))
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PreviewImageViewController") as! PreviewImageViewController
        var imageUrl = viewModel.wallpaper?.hits[indexPath.row]
        vc.imageUrl = imageUrl
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
//    func setWallpaper(_ image: UIImage) {
//        // Set the wallpaper using the selected image
//        let wallpaper = image
//        
//        // Apply the wallpaper to the user's home screen
//        if let imageData = wallpaper.pngData() {
//            if let url = URL(string: "prefs:root=Wallpaper") {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
//    }
}
    
    
    



extension CollectionViewController{
    func configuration(){
        initViewModel()
        observeEvent()
    }
    
    func initViewModel(){
        viewModel.fetchData()
    }
    
    func observeEvent(){
        
        viewModel.eventHandler = {
            [weak self] event in
            
            guard let self else{return}
            
            switch event{
                
            case .loading:
                print("Data Loading")
            case .stopLoading:
                print("Stop loading")
            case .loaded:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .error(let error):
                print(error)
            }
        }
    }
}

extension CollectionViewController:UISearchControllerDelegate, UISearchBarDelegate{
    private func searchBarSetup(){
        search.searchBar.delegate = self
        navigationItem.searchController = search
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        ApiManager.sharedInstance.updateSearchQuery(query: searchText) { [weak self] result in
            switch result{
                
            case .success(let wallpaper):
                self?.viewModel.wallpaper = wallpaper
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
