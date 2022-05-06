//
//  Operations.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/6/22.
//

import Foundation

typealias ImageClosure = (_ result: Result<Data, Error>, _ url: URL) -> Void

class Operations {
    private var operationQueue = OperationQueue()
    private var dictionaryBlocks = [Data: (imageURL: URL, imageClousre: ImageClosure, operation: ImageDownloadOperation)]()
    
    func addOperation(url: URL, imageService: ImageDataService, imageData: Data, completion: @escaping ImageClosure) {
        if !checkOperationExists(with: url) {
            if let tupple = self.dictionaryBlocks.removeValue(forKey: imageData) {
                tupple.operation.cancel()
            }
            
            let newOperation = ImageDownloadOperation(url: url, imageService: imageService) { data, downloadedImageURL in
                if let tupple = self.dictionaryBlocks[imageData] {
                    if tupple.imageURL == downloadedImageURL {
                        if let data = data {
                            tupple.imageClousre(.success(data), downloadedImageURL)
                            
                            if let tupple = self.dictionaryBlocks.removeValue(forKey: imageData) {
                                tupple.operation.cancel()
                            }
                        } else {
                            tupple.imageClousre(.failure(NetworkError.invalidData), downloadedImageURL)
                        }
                        
                        self.dictionaryBlocks.removeValue(forKey: imageData)
                    }
                }
            }
            
            dictionaryBlocks[imageData] = (url, completion, newOperation)
            operationQueue.addOperation(newOperation)
        }
    }
    
    private func checkOperationExists(with url: URL) -> Bool {
        if let arrayOperation = operationQueue.operations as? [ImageDownloadOperation] {
            let opeartions = arrayOperation.filter{$0.url == url}
            return opeartions.count > 0 ? true : false
        }
        
        return false
    }
}

