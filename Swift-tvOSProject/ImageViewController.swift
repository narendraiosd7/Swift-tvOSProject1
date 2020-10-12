//
//  ImageViewController.swift
//  Swift-tvOSProject
//
//  Created by narendra. vadde on 12/10/20.
//  Copyright © 2020 narendra. vadde. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var category = ""
    var appID = "QHGVhZTRwldr5UzSGiBfTgIEpKvTT1bNKKiXJ9YkPu4"
    var images = [JSON]()
    var imageViews = [UIImageView]()
    var imageCounter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViews = view.subviews.compactMap{ $0 as? UIImageView }
        imageViews.forEach { $0.alpha = 0 }
        creditLabel.layer.cornerRadius = 15
        
        guard let url = URL(string: "https://api.unsplash.com/search/photos?client_id=\(appID)&query=\(category)&per_page=100") else {return}
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetch(url)
        }
    }

    func fetch(_ url: URL) {
        if let data = try? Data(contentsOf: url) {
            let json = JSON(data)
            images = json["results"].arrayValue
            downloadImage()
        }
    }
    
    func downloadImage() {
        let currentImage = images[imageCounter % images.count]
        let imageName = currentImage["urls"]["full"].stringValue
        let imageCredit = currentImage["user"]["name"].stringValue
        
        imageCounter += 1
        
        guard let imageURL = URL(string: imageName) else {
            return
        }
        
        guard let imageData = try? Data(contentsOf: imageURL) else {
            return
        }
        
        guard let image = UIImage(data: imageData) else {
            return
        }
        
        DispatchQueue.main.async {
            self.showImage(image, credit: imageCredit)
        }
    }
    
    func showImage(_ image: UIImage, credit: String) {
        spinner.stopAnimating()
        
        let imageViewToUse = imageViews[imageCounter % imageViews.count]
        let otherImageView = imageViews[(imageCounter+1) % imageViews.count]
        
        UIView.animate(withDuration: 2.0, animations: {
            imageViewToUse.image = image
            imageViewToUse.alpha = 1
            
            self.creditLabel.alpha = 0
            self.view.sendSubviewToBack(otherImageView)
        }) { _ in
            self.creditLabel.text = credit
            self.creditLabel.alpha = 1
            otherImageView.alpha = 0
            otherImageView.transform = .identity
            
            UIView.animate(withDuration: 10.0, animations: {
                imageViewToUse.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                DispatchQueue.global(qos: .userInteractive).async {
                    self.downloadImage()
                }
            }
        }
    }
}
