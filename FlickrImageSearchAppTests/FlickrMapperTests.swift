@testable import FlickrImageSearchApp
import XCTest

final class FlickrMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeJson([:])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FlickrMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = anyData()
        
        XCTAssertThrowsError(
            try FlickrMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoPhotosOn200HTTPResponseWithEmptyJson() throws {
        let json = makeJson([:])
        
        XCTAssertThrowsError(
            try FlickrMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversPhotosOn200HTTPResponseWithJSONItems() throws {
        let photo1 = Photo(url: anyURL(path: "https://farm1.static.flickr.com/server/11_some.jpg"))
        let flickr = Flickr(page: 1, pages: 1, perpage: 1, total: 1, photos: [photo1])
        
        let photo11 = makePhoto()
        
        let json = makeJson([
            "page": 1,
            "pages": 1,
            "perpage": 1,
            "total": 1,
            "photo": [
                photo11
            ]
        ])
        
        let result = try FlickrMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, flickr)
    }
    
    // MARK: - Helpers
    
    private func makeJson(_ photos: [String: Any]) -> Data {
        let json = ["photos": photos]
        print(json)
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makePhoto() -> [String: Any] {
        return [
            "id": "11",
            "owner": "someone",
            "secret": "some",
            "server": "server",
            "farm": 1,
            "title": "some title",
            "ispublic": 1,
            "isfriend": 1,
            "isfamily": 1
        ]
    }
    
}
