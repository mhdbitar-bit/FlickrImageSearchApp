//
//  ImageDataService.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import Foundation

protocol ImageDataService {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void)
}

final class RemoteImageDataService: ImageDataService {
    typealias Result = ImageDataService.Result
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) {
        client.getRquest(from: url) { result in
            switch result {
            case .success(let (data, response)):
                let isValidResponse = response.statusCode == 200 && !data.isEmpty
                completion(isValidResponse ? .success(data) : .failure(NetworkError.invalidData))
            case .failure:
                completion(.failure(NetworkError.connectivity))
            }
        }
    }
}
