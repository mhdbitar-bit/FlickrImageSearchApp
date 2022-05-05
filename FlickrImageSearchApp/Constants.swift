//
//  Constants.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import Foundation

class Constants: NSObject {

    static let api_key = "5b189ce4293089d8736f7bbf2882a960"
    static let per_page = 60
    static let searchURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.api_key)&format=json&nojsoncallback=1&safe_search=1&per_page=60&text=%@&page=%ld"
    static let imageURL = "http://farm%d.static.flickr.com/%@/%@_%@.jpg"
        
    static let defaultColumnCount: Int = 2
}
