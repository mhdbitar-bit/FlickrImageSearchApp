//
//  Photo.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import Foundation

struct Photo: Equatable {
    let id : String
    let owner: String
    let secret : String
    let server : String
    let farm : Int
    let title: String
    let ispublic : Int
    let isfriend : Int
    let isfamily : Int
}
