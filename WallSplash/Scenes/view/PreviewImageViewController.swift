//
//  PreviewImageViewController.swift
//  WallSplash
//
//  Created by Adarsh Singh on 10/10/23.
//

import UIKit

class PreviewImageViewController: UIViewController {
    
    var imageUrl: photosUrl?
    @IBOutlet var wallpaperImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.wallpaperImage.setImage(with: imageUrl?.webformatURL ?? "hehe")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wallpaperImage.setImage(with: imageUrl?.webformatURL ?? "hehe")
    }
    
    @objc func saveTapped(){
        let selectedImageURL = URL(string: imageUrl?.webformatURL ?? "hehe")!
        
        // Download the image from the URL
        downloadImage(from: selectedImageURL)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                // Save the image to the photo library
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
                // Set the wallpaper (call a function to set the wallpaper with the saved image)
                //                self.setWallpaper(image)
            }
        }.resume()
        
        
    }
}
