//
//  FlickrCollectionViewControllerViewModel.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import Foundation

final class FlickrCollectionViewControllerViewModel {
    private var remoteService: RemotePhotoService
    private var imageService: ImageDataService
    
    init(remoteService: RemotePhotoService, imageService: ImageDataService) {
        self.remoteService = remoteService
        self.imageService = imageService
    }
    
    
}
