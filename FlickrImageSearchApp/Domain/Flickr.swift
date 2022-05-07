//
//  Flickr.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/7/22.
//

import Foundation

struct Flickr: Equatable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photos: [Photo]
}
