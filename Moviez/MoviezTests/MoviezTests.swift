//
//  MoviezTests.swift
//  MoviezTests
//
//  Created by Ibram on 10/2/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import XCTest
@testable import Moviez

class MoviezTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPIHitSuccessful() throws {
        let mocaDataCount = "744"
        let expectatin = XCTestExpectation(description: "Request movie images from Flickr")
        let url = URL(string: "\(Bundle.main.baseURL)?api_key=\(Bundle.main.appKey)&method=flickr.photos.search&text=unitTest&format=json&nojsoncallback=1")
        let task = URLSession.shared.dataTask(with: url!){(data, response, _) in
            if let responseHTTP = response as? HTTPURLResponse{
                XCTAssertEqual(responseHTTP.statusCode, 200)
                if let data = data {
                    do {
                        let model = try JSONDecoder().decode(MovieImagesModel.self, from: data)
                        XCTAssertEqual(model.photos.total, mocaDataCount)
                    }
                    catch {
                        print(error)
                    }
                }
                expectatin.fulfill()
            }
        }
        task.resume()
        wait(for: [expectatin], timeout: 10.0)/// to wait while response back
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
