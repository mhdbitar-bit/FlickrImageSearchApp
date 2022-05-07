@testable import FlickrImageSearchApp
import XCTest

private class UIWindowSpy: UIWindow {
    var makeKeyAndVisibleCallCount = 0
    
    override func makeKeyAndVisible() {
        makeKeyAndVisibleCallCount = 1
    }
}

final class SceneDelegateTests: XCTestCase {
    
    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window
        
        sut.configureWindow()
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1)
    }
    
    func test_configureWindow_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindowSpy()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is PhotoListViewController, "Expected a photos controller as top view controller, got \(String(describing: topController)) instead")
    }
}
