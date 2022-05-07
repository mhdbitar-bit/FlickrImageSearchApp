//
//  SearchKeywordListTableViewModel.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/6/22.
//

import Foundation
import Combine

final class SearchKeywordListTableViewModel {
    
    var service: SearchKeywordService
    let title = "Keywords"
    @Published var keywords: [String] = []
    @Published var error: String? = nil
    
    init(service: SearchKeywordService) {
        self.service = service
    }
    
    func load() {
        service.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let keywords):
                self.keywords = keywords
            case .failure(let error):
                self.error = error.localizedDescription
            }
        }
    }
    
    func deleteKeyword(at index: Int) {
        if !keywords.isEmpty {
            let keyword = keywords[index]
            keywords.remove(at: index)
            service.delete(where: keyword) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.error = error.localizedDescription
                default: break
                }
            }
        }
    }
}
