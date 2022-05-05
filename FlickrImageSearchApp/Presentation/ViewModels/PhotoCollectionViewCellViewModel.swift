//
//  PhotoCollectionViewCellViewModel.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import Foundation
import Combine

final class PhotoCollectionViewCellViewModel {
    private let imageURL: URL
    private let imageService: ImageDataService
    
    @Published var data: Data? = nil
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    init(imageURL: URL, imageService: ImageDataService) {
        self.imageURL = imageURL
        self.imageService = imageService
    }
    
    func loadImage() {
        isLoading = true
        imageService.loadImageData(from: imageURL, completion: handleAPIResult)
    }
    
    private func handleAPIResult(_ result: Result<Data, Error>) {
        isLoading = false
        switch result {
        case let .success(imageData):
            self.data = imageData
            
        case let .failure(error):
            self.error = error.localizedDescription
        }
    }
}