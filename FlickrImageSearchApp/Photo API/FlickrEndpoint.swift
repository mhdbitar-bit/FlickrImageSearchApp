//
//  FlickrEndpoint.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import Foundation

enum FlickrEndpoint {
    case getPhotos
    
    func url(baseURL: URL, keyword: String, perPage: Int, page: Int) -> URL {
        switch self {
        case .getPhotos:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/services/rest"
            components.queryItems = [
                URLQueryItem(name: "method", value: "flickr.photos.search"),
                URLQueryItem(name: "api_key", value: Constants.apikey),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "nojsoncallback", value: "1"),
                URLQueryItem(name: "safe_search", value: "1"),
                URLQueryItem(name: "per_page", value: "\(perPage)"),
                URLQueryItem(name: "text", value: keyword),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            return components.url!
        }
    }
}
