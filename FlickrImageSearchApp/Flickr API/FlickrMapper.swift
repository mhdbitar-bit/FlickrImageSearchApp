//
//  FlickrMapper.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import Foundation

final class FlickrMapper {
    private struct FlickrResponse: Decodable {
        let photos: FlickerPhotoResponse
        
        var flickr: Flickr {
            return Flickr(
                page: photos.page,
                pages: photos.pages,
                perpage: photos.perpage,
                total: photos.total,
                photos: photos.items)
        }
        
        struct FlickerPhotoResponse: Decodable {
            let page: Int
            let pages: Int
            let perpage: Int
            let total: Int
            let photo: [FlickrPhotoResponse]
            
            var items: [Photo] {
                photo.map { return Photo(url: $0.imageURL) }
            }
            
            struct FlickrPhotoResponse: Decodable {
                private let id: String
                private let owner: String
                private let secret: String
                private let server: String
                private let farm: Int
                private let title: String
                private let ispublic: Int
                private let isfriend: Int
                private let isfamily: Int
                
                var imageURL: URL {
                    let urlString = String(format: Constants.imageURL, farm, server, id, secret)
                    return URL(string: urlString)!
                }
            }
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> Flickr {
        guard response.statusCode == 200, let result = try? JSONDecoder().decode(FlickrResponse.self, from: data) else {
            throw NetworkError.invalidData
        }
        
        return result.flickr
    }
}
