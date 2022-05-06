//
//  FlickrCollectionViewControllerViewModel.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import Foundation
import Combine

final class PhotoListViewModel {
    var remoteService: RemotePhotoService
    var imageService: ImageDataService
    var searchKeywordService: SearchKeywordService
    var photoOperation: Operations
    
    let title = "Photos"
    @Published var photos: [Photo] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    init(remoteService: RemotePhotoService, imageService: ImageDataService, searchKeywordService: SearchKeywordService, photoOperation: Operations) {
        self.remoteService = remoteService
        self.imageService = imageService
        self.searchKeywordService = searchKeywordService
        self.photoOperation = photoOperation
    }
    
    func loadPhotos(keyword: String) {
        isLoading = true
        if let url = URL(string: Constants.baseURL) {
            let endpoint = FlickrEndpoint.getPhotos.url(baseURL: url, keyword: keyword, perPage: Constants.perPage, page: 1)
            remoteService.getPhotos(url: endpoint) { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case let .success(photos):
                    self.searchKeywordService.insert(keyword) { _ in }
                    self.photos = photos
                    
                case let .failure(error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
