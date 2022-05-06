//
//  SearchStore.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/6/22.
//

import Foundation

protocol SearchStore {
    typealias InsertionResult = Result<Void, Error>
    typealias RetrievalResult = Result<[String], Error>

    func insert(_ keyword: String, completion: @escaping (InsertionResult) -> Void)
    func retrieve(completion: @escaping (RetrievalResult) -> Void)
}
