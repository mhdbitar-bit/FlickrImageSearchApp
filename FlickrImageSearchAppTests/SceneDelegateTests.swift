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
}
