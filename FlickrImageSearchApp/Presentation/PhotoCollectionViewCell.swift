//
//  PhotoCollectionViewCell.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import UIKit
import Combine

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var photo: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: PhotoCollectionViewCellViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bind()
    }
    
    private func bind() {
        bindLoading()
        bindData()
    }
    
    private func bindLoading() {
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }.store(in: &cancellables)
    }
    
    private func bindData() {
        viewModel.$data.sink { [weak self] data in
            guard let self = self else { return }
            if let data = data {
                self.photo.image = UIImage(data: data)
            }
        }.store(in: &cancellables)
    }
}
