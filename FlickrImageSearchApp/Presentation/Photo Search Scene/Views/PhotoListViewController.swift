//
//  FlickrCollectionViewController.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import UIKit
import Combine

final class PhotoListViewController: UICollectionViewController, Alertable {
    private var searchBarController: UISearchController!
    private var viewModel: PhotoListViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private let photoReuseIdentifier = "PhotoCollectionViewCell"
    private var numberOfColumns: CGFloat = 2
    private let refreshControl = UIRefreshControl()
    
    convenience init(viewModel: PhotoListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        title = viewModel.title
        createSearchBar()
        setupNavigationController()
        setupCollectionView()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(openKeywordsListPage))
    }
    
    private func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.register(UINib(nibName: photoReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: photoReuseIdentifier)
    }
    
    @objc func openKeywordsListPage() {
        let viewModel = SearchKeywordListTableViewModel(service: viewModel.searchKeywordService)
        let viewController = SearchKeywordListTableViewController(viewModel: viewModel)
        viewController.delegate = self
        show(viewController, sender: self)
    }
    
    @objc func refresh() {
        if collectionView.numberOfItems(inSection: 0) > 0 {
            viewModel.loadNextPage()
        } else {
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - Binding

extension PhotoListViewController {
    private func bind() {
        bindLoader()
        bindPhotos()
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
    
    private func bindPhotos() {
        viewModel.$photos.sink { [weak self] photos in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    private func bindLoader() {
        viewModel.$isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.refreshControl.beginRefreshing()
                } else {
                    self.refreshControl.endRefreshing()
                }
            }
        }.store(in: &cancellables)
    }
}


// MARK: - UICollectionView Configurations

extension PhotoListViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoReuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photo.image = nil
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCollectionViewCell else { return }
        
        cell.configure(with: viewModel.photos[indexPath.row], imageService: viewModel.imageService, operation: viewModel.photoOperation)
        
        if indexPath.row == viewModel.photos.count - 10 {
            viewModel.loadNextPage()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/numberOfColumns, height: (collectionView.bounds.width)/numberOfColumns)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


// MARK: - UISearchController

extension PhotoListViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    private func createSearchBar() {
        searchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBarController
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 1 else { return }
        collectionView.reloadData()
        viewModel.searchPhotos(by: text)
        searchBarController.searchBar.resignFirstResponder()
    }
}

extension PhotoListViewController: SearchKeywordListTableViewControllerDelgate {
    func didSelectKeyword(with keyword: String) {
        navigationController?.popViewController(animated: true)
        viewModel.searchPhotos(by: keyword)
    }
}
