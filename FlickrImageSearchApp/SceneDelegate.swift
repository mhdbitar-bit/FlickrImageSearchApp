//
//  SceneDelegate.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/5/22.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let navigationController = UINavigationController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        configureWindow()
    }
    
    func configureWindow() {
        navigationController.setViewControllers([makeRootViewController()], animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func makeRootViewController() -> PhotoListViewController {
        let client = URLSessionHTTPClient(session: .shared)
        let remoteService = RemotePhotoService(client: client)
        let imageService = RemoteImageDataService(client: client)
        
        let localStoreURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("image-search-store.sqlite")
        
        let localStore = try! CoreDataSearchStore(storeURL: localStoreURL)
        let keywordsService = SearchKeywordService(store: localStore)
        
        let photoOperation = Operations()
        let viewModel = PhotoListViewModel(
            remoteService: remoteService,
            imageService: imageService,
            searchKeywordService: keywordsService,
            photoOperation: photoOperation)
        let vc = PhotoListViewController(viewModel: viewModel)
        return vc
    }
}
