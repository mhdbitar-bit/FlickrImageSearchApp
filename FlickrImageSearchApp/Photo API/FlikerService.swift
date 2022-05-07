//
//  FlikerService.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import Foundation

enum NetworkError: Error {
    case connectivity
    case invalidData
}

protocol FlikerService {
    typealias Result = Swift.Result<Flickr, Error>
    
    func getPhotos(url: URL, completion: @escaping (Result) -> Void)
}

final class RemotePhotoService: FlikerService {
    typealias Result = FlikerService.Result
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func getPhotos(url: URL, completion: @escaping (Result) -> Void) {
        client.getRquest(from: url) { result in
            switch result {
            case .success(let (data, response)):
                completion(RemotePhotoService.map(data, from: response))
            case .failure:
                completion(.failure(NetworkError.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let flickr = try FlickrMapper.map(data, from: response)
            return .success(flickr)
        } catch {
            return .failure(error)
        }
    }
}
