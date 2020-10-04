//
//  MoviezUITests.swift
//  MoviezUITests
//
//  Created by Ibram on 10/4/20.
//  Copyright © 2020 Ibram. All rights reserved.
//

import XCTest

class MoviezUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testScrollTableView() throws {
        let app = XCUIApplication()
        app.launch()
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["Den of Thieves"].swipeRight()/*[[".cells.staticTexts[\"Den of Thieves\"]",".swipeUp()",".swipeRight()",".staticTexts[\"Den of Thieves\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
    }
    
    func testSearchAndShowDetails() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["Movies"].buttons["Search"].tap()
        app.buttons["Cancel"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
