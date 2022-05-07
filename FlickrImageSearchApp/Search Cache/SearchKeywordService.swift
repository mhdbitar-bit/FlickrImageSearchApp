//
//  SearchKeywordService.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/6/22.
//

import Foundation

final class SearchKeywordService {
    private let store: SearchKeywoardStore
    
    init(store: SearchKeywoardStore) {
        self.store = store
    }
}

extension SearchKeywordService: SearchKeywoardStore {
    func insert(_ keyword: String, completion: @escaping (InsertionResult) -> Void) {
        store.insert(keyword) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            default: break
            }
        }
    }
    
    func retrieve(completion: @escaping (RetrievalResult) -> Void) {
        store.retrieve { result in
            switch result {
            case .success(let keywords):
                completion(.success(keywords))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func delete(where keyword: String, completion: @escaping (DeletionResult) -> Void) {
        store.delete(where: keyword) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

