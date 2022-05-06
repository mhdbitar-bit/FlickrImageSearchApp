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
        service.retrieve { result in
            switch result {
            case .success(let keywords):
                self.keywords = keywords
            case .failure(let error):
                self.error = error.localizedDescription
            }
        }
    }
}
