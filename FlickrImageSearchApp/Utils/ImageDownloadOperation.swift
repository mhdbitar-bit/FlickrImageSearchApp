//
//  ImageDownloadOperation.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/6/22.
//

import Foundation

class ImageDownloadOperation: Operation {
    let url: URL
    var imageService: ImageDataService
    var customCompletionBlock: ((_ imageData: Data?, _ url: URL) -> Void)?

    init(url: URL, imageService: ImageDataService, completionBlock: @escaping (_ imageData : Data?, _ url: URL) -> Void) {
        self.url = url
        self.imageService = imageService
        self.customCompletionBlock = completionBlock
    }
    
    override func main() {
        if self.isCancelled { return }
        
        imageService.loadImageData(from: url) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let imageData):
                    if self.isCancelled { return }
                    if let completion = self.customCompletionBlock {
                        completion(imageData, self.url)
                    }
                default:
                    if self.isCancelled { return }
                    break
                }
            }
        }
    }
}
