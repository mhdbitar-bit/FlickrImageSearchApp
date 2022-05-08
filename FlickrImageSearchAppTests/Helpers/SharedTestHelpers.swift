//
//  SharedTestHelpers.swift
//  FlickrImageSearchAppTests
//
//  Created by Mohammad Bitar on 5/7/22.
//

import Foundation

func anyURL(path: String = "") -> URL {
    return URL(string: !path.isEmpty ? path : "https://any-url.com")!
}

func anyResponse() -> HTTPURLResponse {
    return HTTPURLResponse(statusCode: 200)
}

func anyData() -> Data {
    return Data("any data".utf8)
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
