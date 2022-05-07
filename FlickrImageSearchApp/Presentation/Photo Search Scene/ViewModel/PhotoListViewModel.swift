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
    
    private var serachKeyword = ""
    private var pageNo = 1
    private var totalPageNo = 1
    
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
    
    func searchPhotos(by keyword: String) {
        serachKeyword = keyword
        photos = []
        pageNo = 1
        totalPageNo = 1
        loadPhotos()
    }
    
    private func loadPhotos() {
        isLoading = true
        if let url = URL(string: Constants.baseURL) {
            let endpoint = FlickrEndpoint.searchPhotos.url(
                baseURL: url,
                keyword: serachKeyword,
                perPage: Constants.perPage, page: pageNo
            )
            remoteService.getPhotos(url: endpoint) { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case let .success(flickr):
                    self.searchKeywordService.insert(self.serachKeyword) { _ in }
                    self.photos.append(contentsOf: flickr.photos)
                    self.totalPageNo = flickr.pages
                    
                case let .failure(error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func loadNextPage() {
        if pageNo < totalPageNo {
            pageNo += 1
        } else {
            pageNo = 1
        }
        
        loadPhotos()
    }
}
