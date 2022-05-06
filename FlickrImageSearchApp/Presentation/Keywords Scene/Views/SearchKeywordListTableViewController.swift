//
//  SearchKeywordListTableViewController.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/6/22.
//

import UIKit
import Combine

protocol SearchKeywordListTableViewControllerDelgate: AnyObject {
    func didSelectKeyword(with keyword: String)
}

final class SearchKeywordListTableViewController: UITableViewController, Alertable {
      
    private var viewModel: SearchKeywordListTableViewModel!
    private var cancellables: Set<AnyCancellable> = []
    weak var delegate: SearchKeywordListTableViewControllerDelgate?
    
    convenience init(viewModel: SearchKeywordListTableViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.title
        viewModel.load()
        bind()
    }
    
    private func bind() {
        bindKeywords()
        bindError()
    }
    
    private func bindError() {
        viewModel.$error.sink { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: error)
            }
        }.store(in: &cancellables)
    }
    
    private func bindKeywords() {
        viewModel.$keywords.sink { [weak self] keywords in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.keywords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.keywords[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let delegate = delegate else { return }
        delegate.didSelectKeyword(with: viewModel.keywords[indexPath.row])
    }
}
