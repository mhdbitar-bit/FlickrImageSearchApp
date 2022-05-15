//
//  PhotoCollectionViewCell.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var photo: UIImageView!
    
    func configure(with photo: Photo, imageService: ImageDataService, operation: Operations) {
        self.photo.image = UIImage(systemName: "photo.fill")
        self.photo.contentMode = .scaleAspectFit
        imageService.loadImageData(from: photo.url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                operation.addOperation(url: photo.url, imageService: imageService, imageData: data) { result, url in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let imageData):
                            self.photo.image = UIImage(data: imageData)
                            self.photo.contentMode = .scaleToFill
                        default: break
                        }
                    }
                }
            default: break
            }
        }
    }
}
