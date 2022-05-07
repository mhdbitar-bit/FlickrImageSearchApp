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
    
    private func makeJson(_ photos: [String: Any]) -> Data {
        let json = ["photos": photos]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(
            url: URL(string: "any-url.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)!
    }
}
