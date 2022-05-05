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
    typealias Result = Swift.Result<[Photo], Error>
    
    func getPhotos(completion: @escaping (Result) -> Void)
}

final class RemotePhotoService: FlikerService {
    typealias Result = FlikerService.Result
    
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    func getPhotos(completion: @escaping (Result) -> Void) {
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
            let photos = try FlickrMapper.map(data, from: response)
            return .success(photos)
        } catch {
            return .failure(error)
        }
    }
}
