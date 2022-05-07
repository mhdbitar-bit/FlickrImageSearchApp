//
//  SharedTestHelpers.swift
//  FlickrImageSearchAppTests
//
//  Created by Mohammad Bitar on 5/7/22.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(
            url: anyURL(),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)!
    }
}
